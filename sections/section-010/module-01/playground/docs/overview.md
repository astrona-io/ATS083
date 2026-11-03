# Overview: How The Runtime Finds And Calls A CNI Plugin (Playground)

This is a playground, not a lab. It starts a fresh two-node kind cluster (Kubernetes v1.35.0), installs the reference CNI plugins v1.9.1 and flannel v0.28.10, creates the example workloads, and waits. There is no task, no `astrona submit` and no pass or fail.

Connect to it first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-playground-010-01)"
```

## What is in the cluster

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-flannel` | DaemonSet `kube-flannel-ds` and ConfigMap `kube-flannel-cfg` | The network plugin and its configuration |
| `kube-system` | DaemonSet `cni-plugins` | Installs the reference CNI plugins into `/opt/cni/bin` on every node |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server (podinfo) on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl`, in the same namespace as `probe` |
| `outpost` | Pod `drifter` | A client pod with `curl`, in another namespace |

## Practice tasks

- Print the key `cni-conf.json` of the ConfigMap `kube-flannel-cfg` and name the network and the two plugins.
- Print the init containers of the DaemonSet `kube-flannel-ds` and find the path of the file that `install-cni` writes.
- Open a debug shell on a node with `kubectl debug node/<node> -it --image=busybox:1.37` and list `/host/etc/cni/net.d` and `/host/opt/cni/bin`.
- Read `/host/run/flannel/subnet.env` on both nodes and compare the `FLANNEL_SUBNET` values.
- Run `ip addr show eth0` and `ip route` in the `shuttle` pod and match the address to the range of its node.
- Delete the pods that `kubectl debug` created when you finish.
