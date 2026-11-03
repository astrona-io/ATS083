# Overview: Inspecting Pod Network Interfaces With ip (Playground)

This is a playground, not a lab. It starts a fresh two-node kind cluster (Kubernetes v1.35.0) with flannel v0.28.10 as the network plugin, creates the example workloads, and waits. There is no task, no `astrona submit` and no pass or fail.

Connect to it first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-playground-030-01)"
```

## What is in the cluster

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server (podinfo) on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` and the busybox tools |
| `outpost` | Pod `drifter` | A client pod with `curl`, in another namespace |
| `kube-flannel` | DaemonSet `kube-flannel-ds` and ConfigMap `kube-flannel-cfg` | The network plugin and its configuration |

## Practice tasks

- Run `kubectl -n starfleet exec shuttle -- ip addr show` and compare the address of `eth0` with `kubectl -n starfleet get pod shuttle -o wide`.
- Run `kubectl -n starfleet exec shuttle -- ip route show` and find the default gateway. Compare it with the pod CIDR of the node that runs the pod.
- Read the MTU with `kubectl -n starfleet exec shuttle -- cat /sys/class/net/eth0/mtu`, then run `ip link` on the node with `kubectl debug node/<node> -it --image=busybox:1.37.0 -- ip link` and compare it with the MTU of the node interface.
- Match the `eth0@if` number in the pod to a veth interface on the node.
- Run `ip neigh show` in the pod after a `curl` to the Service `probe` and read the state of the gateway entry.
