---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Record The Service Path Of probe: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-030-02-01)"
```

## Step 1: Read the Service

```sh
kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}'
```

## Step 2: Read the backend address

The EndpointSlice carries the label `kubernetes.io/service-name` with the name of the Service. Its first endpoint holds the pod address.

```sh
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o jsonpath='{.items[0].endpoints[0].addresses[0]}'
```

## Step 3: Read the node of the backend

```sh
kubectl -n starfleet get pods -l app=probe -o jsonpath='{.items[0].spec.nodeName}'
```

## Step 4: Count the kube-proxy pods

```sh
kubectl -n kube-system get pods -l k8s-app=kube-proxy --no-headers | wc -l
```

## Step 5: Save the report

```sh
kubectl -n starfleet create configmap cni-evidence \
  --from-literal=service-ip="$(kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}')" \
  --from-literal=endpoint-ip="$(kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o jsonpath='{.items[0].endpoints[0].addresses[0]}')" \
  --from-literal=probe-node="$(kubectl -n starfleet get pods -l app=probe -o jsonpath='{.items[0].spec.nodeName}')" \
  --from-literal=kube-proxy-pods="$(kubectl -n kube-system get pods -l k8s-app=kube-proxy --no-headers | wc -l | tr -d ' ')"
```

Submit with `astrona submit -c sections/section-030/module-02/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-030-02-01`.

## Common pitfalls

> [!WARNING]
> Use the live values of your cluster. The Service address and the pod address are different in each cluster. Do not use the pod address in `service-ip`: the Service address is the virtual one. If the EndpointSlice query prints nothing, the pod `probe` is not Ready yet, so wait and try again.
