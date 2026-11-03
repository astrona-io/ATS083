---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# Record The Pod Ranges Of The Nodes: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-020-01-01)"
```

## Step 1: Read the cluster network

The flannel configuration is a JSON document in a ConfigMap. The jsonpath expression escapes the dot in the key name `net-conf.json`.

```sh
kubectl -n kube-flannel get configmap kube-flannel-cfg -o 'jsonpath={.data.net-conf\.json}'
```

Find the value of `Network` in the output. It is the cluster pod network.

## Step 2: Read the nodes

Count the nodes and read the range of the worker. The label selector `!node-role.kubernetes.io/control-plane` keeps only nodes that do not have the control-plane role label.

```sh
kubectl get nodes --no-headers | wc -l
kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}'
```

## Step 3: Find the node of shuttle

```sh
kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.nodeName}'
```

## Step 4: Save the report

This command reads the four values again and writes the ConfigMap in one step.

```sh
kubectl -n starfleet create configmap cni-evidence \
  --from-literal=cluster-cidr="$(kubectl -n kube-flannel get configmap kube-flannel-cfg -o 'jsonpath={.data.net-conf\.json}' | grep '"Network"' | sed -E 's/.*"Network": *"([^"]+)".*/\1/')" \
  --from-literal=node-count="$(kubectl get nodes --no-headers | wc -l | tr -d ' ')" \
  --from-literal=worker-pod-cidr="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}')" \
  --from-literal=shuttle-node="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.nodeName}')"
```

Submit with `astrona submit -c sections/section-020/module-01/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-020-01-01`.

## Common pitfalls

> [!WARNING]
> Do not type the values from memory: node names and ranges differ in every cluster. The value of `cluster-cidr` is only the block, for example `10.244.0.0/16`, and not the whole JSON line. If `worker-pod-cidr` is empty, the label selector was written without the quotes and the shell changed it.
