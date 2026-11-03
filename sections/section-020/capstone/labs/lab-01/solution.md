---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# IPAM Capstone: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-020-cap)"
```

## Step 1: Read the nodes

```sh
kubectl get nodes -o custom-columns=NAME:.metadata.name,POD_CIDR:.spec.podCIDR
```

Note the name of the worker node, the node without the control-plane role.

## Step 2: Create latecomer on the worker

Replace `WORKER` with the node name from step 1.

```sh
kubectl apply -f - <<'POD'
apiVersion: v1
kind: Pod
metadata:
  name: latecomer
  namespace: outpost
spec:
  nodeSelector:
    kubernetes.io/hostname: WORKER
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
POD
kubectl -n outpost wait --for=condition=Ready pod/latecomer --timeout=120s
```

## Step 3: Check every pod address

List all pods with their node and address, and compare the first three octets of each address with the range of its node. Skip pods that use the host network.

```sh
kubectl get pods -A -o wide
```

In a healthy cluster the count of pods outside their range is 0.

## Step 4: Save the report

```sh
kubectl -n starfleet create configmap ipam-report \
  --from-literal=control-plane-cidr="$(kubectl get nodes -l 'node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}')" \
  --from-literal=worker-cidr="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}')" \
  --from-literal=pods-outside-ranges=0
```

Submit with `astrona submit -c sections/section-020/capstone/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-020-cap`.

## Common pitfalls

> [!WARNING]
> Create `latecomer` before you count addresses, because the grader counts after it runs. Pods in `kube-system` and `kube-flannel` that use the host network show the node address and must not be counted. If `latecomer` stays `Pending`, the value of the `nodeSelector` does not match the node name.
