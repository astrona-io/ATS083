# Overview: Pod CIDR Allocation To Nodes (Playground)

This is a playground, not a lab. It starts a fresh two-node kind cluster (Kubernetes v1.35.0) with flannel v0.28.10 as the network plugin, creates the example workloads, and waits. There is no task, no `astrona submit` and no pass or fail.

Connect to it first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-playground-020-01)"
```

## What is in the cluster

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server (podinfo) on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl`, in the same namespace as `probe` |
| `outpost` | Pod `drifter` | A client pod with `curl`, in another namespace |
| `kube-flannel` | DaemonSet `kube-flannel-ds` and ConfigMap `kube-flannel-cfg` | The network plugin and its configuration |

## Practice tasks

- List the nodes with `kubectl get nodes -o custom-columns=NAME:.metadata.name,POD_CIDR:.spec.podCIDR` and check that the ranges do not overlap.
- Run `kubectl get pods -A -o wide` and match the address of each pod to the range of its node.
- Read `net-conf.json` in the ConfigMap `kube-flannel-cfg` and compare `Network` with the `--cluster-cidr` argument of the kube-controller-manager pod.
- Start a debug pod on a node with `kubectl debug node/<node> -it --image=busybox:1.37.0 -- cat /host/run/flannel/subnet.env` and compare `FLANNEL_SUBNET` with the node range.
