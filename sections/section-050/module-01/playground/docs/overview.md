# Overview: Multus And Network Attachment Definitions (Playground)

This is a playground, not a lab. It starts a fresh two-node kind cluster (Kubernetes v1.35.0) with flannel v0.28.10 as the default network and Multus v4.3.1, creates the example workloads, and waits. There is no task, no `astrona submit` and no pass or fail.

Connect to it first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-playground-050-01)"
```

## What is in the cluster

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server (podinfo) on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `starfleet` | NetworkAttachmentDefinition `side-net` | A bridge network on 192.168.50.0/24 |
| `starfleet` | Pod `tender` | A client pod with a second interface on `side-net` |
| `outpost` | Pod `drifter` | A client pod with `curl`, in another namespace |
| `kube-system` | DaemonSet `kube-multus-ds` | Installs Multus on every node |

## Practice tasks

- Run `kubectl -n starfleet get net-attach-def side-net -o yaml` and read `spec.config`.
- Run `kubectl -n starfleet exec tender -- ip -4 addr` and find `eth0` and `net1`.
- Read the annotation `k8s.v1.cni.cncf.io/network-status` of `tender`.
- Create a second definition with a different bridge and range, and a pod that names the interface with `@`.
- Create a pod in `outpost` that uses `starfleet/side-net` and see which address it gets.
- List the files in `/etc/cni/net.d` on a node with `kubectl debug node/<node> -it --image=busybox:1.37.0 -- ls /host/etc/cni/net.d`.
