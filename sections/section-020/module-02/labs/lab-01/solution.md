---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# Trace A Pod Address To Its Node Range: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-020-02-01)"
```

## Step 1: Read the address and node of shuttle

```sh
kubectl -n starfleet get pod shuttle -o jsonpath='{.status.podIP}'
kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.nodeName}'
```

## Step 2: Read the range of that node

Replace `NODE` with the name from step 1.

```sh
kubectl get node NODE -o jsonpath='{.spec.podCIDR}'
```

## Step 3: Count the crew pods

The node ranges are `/24` blocks, so a pod belongs to a range when its address starts with the same three octets. List the addresses and compare them with the worker range.

```sh
kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}'
kubectl -n starfleet get pods -l app=crew -o wide
kubectl -n starfleet get pods -l app=crew --no-headers | wc -l
```

## Step 4: Save the report

```sh
SHUTTLE_NODE="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.nodeName}')"
WORKER_CIDR="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}')"
PREFIX="${WORKER_CIDR%.*}."
kubectl -n starfleet create configmap cni-evidence \
  --from-literal=shuttle-ip="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.status.podIP}')" \
  --from-literal=shuttle-node-cidr="$(kubectl get node "$SHUTTLE_NODE" -o jsonpath='{.spec.podCIDR}')" \
  --from-literal=crew-on-worker="$(kubectl -n starfleet get pods -l app=crew -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}' | awk -v p="$PREFIX" 'index($1, p) == 1 { n++ } END { print n + 0 }')" \
  --from-literal=crew-total="$(kubectl -n starfleet get pods -l app=crew --no-headers | wc -l | tr -d ' ')"
```

Submit with `astrona submit -c sections/section-020/module-02/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-020-02-01`.

## Common pitfalls

> [!WARNING]
> The worker range and the control-plane range are different blocks. Count only pods inside the worker range, and do not take the count from the control-plane node. A pod that is still starting has no address yet, so wait until all four `crew` pods are `Running`.
