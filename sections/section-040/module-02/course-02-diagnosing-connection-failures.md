---
draft: true
exam_objectives:
- Troubleshooting Pod Connectivity (DNS, pod-to-pod)
---
# Diagnosing Connection Failures

This part gives an order of tests for a failing request to a Service or a pod. Each step either clears one layer or finds the fault. Run the steps in order and stop at the first failure. The commands use the playground objects, and you replace the names with your own.

## Step 1: Test the name and the address separately

First check whether the name resolves. Request the ClusterIP of the Service directly:

```sh
kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}'
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://CLUSTER_IP:9898/
```

A request that works with the address and fails with the name is a DNS problem. A request that fails with both continues with step 2.

## Step 2: Check the endpoints

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe
kubectl -n starfleet describe service probe
```

The output of `describe` lists `Selector`, `Port`, `TargetPort` and `Endpoints`. If the endpoints are empty, the Service has no pod to send traffic to. There are three causes:

- The selector does not match the labels of any pod. Read both with `kubectl -n starfleet get pods --show-labels` and compare each key and value.
- The pods match but are not ready. Read the readiness status with `kubectl -n starfleet get pods` and the events with `kubectl -n starfleet describe pod`.
- The pods are in a different namespace. A Service selects only pods in its own namespace.

## Step 3: Check the target port

If the endpoints exist, compare the `targetPort` of the Service with the port that the container listens on. The container port is in the Deployment under `containerPort`, but that field is only documentation. The real port is whatever the process listens on. A wrong `targetPort` gives a refused connection or a reset, because the packet reaches the pod and nothing answers on that port.

```sh
kubectl -n starfleet get service probe -o jsonpath='{.spec.ports}'
kubectl -n starfleet get pods -l app=probe -o jsonpath='{.items[0].spec.containers[0].ports}'
```

## Step 4: Bypass the Service and test the pod

Request the pod address directly, from a client in the same namespace and from a client on another node:

```sh
kubectl -n starfleet get pods -o wide
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://POD_IP:9898/
```

If this works and the request through the Service does not, the fault is in the Service objects or in the rules of kube-proxy. If this also fails, the fault is in the pod or in the pod network, and the Service is not the cause.

## Step 5: Separate a pod fault from a network fault

Ask the pod itself. Request localhost from inside the server pod, or read its logs:

```sh
kubectl -n starfleet logs deployment/probe
kubectl -n starfleet exec deployment/probe -- wget -q -O- -T 5 http://127.0.0.1:9898/readyz
```

The second command depends on a tool in the image. If the image does not have it, use the logs or a debug container with `kubectl debug`. If the application answers on localhost and not from another pod, the problem lies between the pods. If it does not answer on localhost either, the application is the problem.

## Step 6: Compare same node and other node

The pods of the cluster are on two nodes. Find which node each pod runs on with `kubectl get pods -A -o wide`. Test the client and server on the same node, and then on different nodes. A request that works on one node and fails across nodes points to the node-to-node path of the network plugin: the overlay, the firewall between nodes or a route. A request that fails in both cases points to the pod, the Service or the policy.

For a cross-node check, place a client pod on a chosen node with a `nodeSelector` on the label `kubernetes.io/hostname`. Use the node name from `kubectl get nodes`.

## Step 7: Check for rules that drop traffic

NetworkPolicy objects can drop traffic. Check them first:

```sh
kubectl get networkpolicy -A
```

The default flannel installation does not enforce NetworkPolicy, so a policy in such a cluster has no effect. A cluster with a network plugin that enforces policies treats it differently.

## Step 8: Apply one change and test again

Change one thing and repeat the failing request. For a Service that points at the wrong label or the wrong port, a patch is enough:

```sh
kubectl -n starfleet patch service probe --type merge -p '{"spec":{"selector":{"app":"probe"},"ports":[{"port":9898,"targetPort":9898}]}}'
```

The EndpointSlice is updated by the control plane within a short time. Read it again before you test the request.

## Reading the result

| Result | Where to look |
| --- | --- |
| Name does not resolve, address works | The cluster DNS |
| Refused immediately, no endpoints | The selector and the readiness of the pods |
| Refused immediately, endpoints exist | The `targetPort` and the listening port |
| Timeout through the Service and by pod address | The pod network or a drop rule |
| Timeout only across nodes | The node-to-node path of the network plugin |
| HTTP 404 or 503 | The application |

## Try it

<!-- astrona:playground:renew -->

Break the Service in the playground, then find the fault with the steps above. Patch the selector to a label that no pod has:

```sh
kubectl -n starfleet patch service probe --type merge -p '{"spec":{"selector":{"app":"nobody"}}}'
```

Run steps 1 to 3 and note how the endpoints and the request result change. Then restore the selector to `app: probe`.

## Common pitfalls

> [!WARNING]
> A working request from one pod does not prove that the Service is healthy for all clients. The result of a Service request depends on which endpoint the rules pick, and one broken endpoint fails only some requests. Repeat a request several times, and check every endpoint address, when the failures are not constant.
