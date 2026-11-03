# Overview: IPAM In The CNI Plugin (Playground)

This is a playground, not a lab. It starts a fresh two-node kind cluster (Kubernetes v1.35.0) with flannel v0.28.10 as the network plugin, creates the example workloads, and waits. There is no task, no `astrona submit` and no pass or fail.

Connect to it first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-playground-020-02)"
```

## What is in the cluster

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server (podinfo) on port 9898 |
| `starfleet` | Deployment `crew` | Four pods of the same server, spread over the nodes |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `outpost` | Pod `drifter` | A client pod with `curl`, in another namespace |
| `kube-flannel` | DaemonSet `kube-flannel-ds` and ConfigMap `kube-flannel-cfg` | The network plugin and its configuration |

## Practice tasks

- Print the plugin chain with `kubectl debug node/<node> -it --image=busybox:1.37.0 -- cat /host/etc/cni/net.d/10-flannel.conflist` and find the `ipam` block.
- List the allocated addresses with `kubectl debug node/<node> -it --image=busybox:1.37.0 -- ls /host/var/lib/cni/networks/cbr0` and compare them with `kubectl get pods -A -o wide`.
- Scale `crew` to 10 replicas with `kubectl -n starfleet scale deployment crew --replicas=10` and see how the allocated files change.
- Print the maximum pods per node with `kubectl get nodes -o custom-columns=NAME:.metadata.name,MAX_PODS:.status.capacity.pods`.
