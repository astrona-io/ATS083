---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Packet-level Capstone: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-030-cap)"
```

## Step 1: Create netcheck on the host network

With `hostNetwork: true` the pod shares the network namespace of its node. Its address is the address of the node.

```sh
kubectl apply -f - <<'POD'
apiVersion: v1
kind: Pod
metadata:
  name: netcheck
  namespace: outpost
spec:
  hostNetwork: true
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
POD
kubectl -n outpost wait --for=condition=Ready pod/netcheck --timeout=120s
```

## Step 2: Read the settings of drifter

```sh
kubectl -n outpost exec drifter -- ip -4 -o addr show dev eth0
kubectl -n outpost exec drifter -- cat /sys/class/net/eth0/mtu
```

The address is in the fourth field of the first command, followed by the prefix length, which you must remove.

## Step 3: Read the Service data

```sh
kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}'
kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o jsonpath='{.items[0].endpoints[0].addresses[0]}'
```

## Step 4: Check the Service from netcheck

A pod on the host network does not use cluster DNS by default, so use the cluster IP and not the name.

```sh
kubectl -n outpost exec netcheck -- curl -s -m 5 -o /dev/null -w '%{http_code}' http://<cluster-ip>:9898/healthz
```

Replace `<cluster-ip>` with the value from step 3. The expected status is 200.

## Step 5: Save the report

```sh
kubectl -n starfleet create configmap packet-report \
  --from-literal=drifter-ip="$(kubectl -n outpost exec drifter -- ip -4 -o addr show dev eth0 | awk '{print $4}' | cut -d/ -f1)" \
  --from-literal=drifter-mtu="$(kubectl -n outpost exec drifter -- cat /sys/class/net/eth0/mtu | tr -d '\r')" \
  --from-literal=probe-service-ip="$(kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}')" \
  --from-literal=probe-endpoint-ip="$(kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o jsonpath='{.items[0].endpoints[0].addresses[0]}')"
```

Submit with `astrona submit -c sections/section-030/capstone/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-030-cap`.

## Common pitfalls

> [!WARNING]
> The ConfigMap is named `packet-report`, not `cni-evidence`. If the pod `netcheck` shows a pod address and not a node address, the field `hostNetwork` is missing or is nested under `containers`: it belongs directly under `spec`. Read the values of `drifter` and not of `shuttle`.
