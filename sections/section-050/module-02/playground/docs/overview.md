# Overview: Troubleshooting Secondary Interfaces (Playground)

This is a playground, not a lab. It starts a fresh two-node kind cluster (Kubernetes v1.35.0) with flannel v0.28.10 as the default network and Multus v4.3.1, creates the example workloads and two broken pods, and waits. There is no task, no `astrona submit` and no pass or fail.

Connect to it first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-playground-050-02)"
```

## What is in the cluster

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server (podinfo) on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `starfleet` | NetworkAttachmentDefinition `side-net` | A bridge network on 192.168.60.0/24 |
| `starfleet` | NetworkAttachmentDefinition `dock-net` | A network with a wrong plugin type, range 192.168.70.0/24 |
| `starfleet` | Pod `cutter` | Uses `dock-net`, stuck in ContainerCreating |
| `outpost` | Pod `ferry` | Uses `side-net`, stuck in ContainerCreating |
| `outpost` | Pod `drifter` | A client pod with `curl` |

## Practice tasks

- Run `kubectl get pods -A` and find the two pods that do not start.
- Read the events with `kubectl -n outpost describe pod ferry` and `kubectl -n starfleet describe pod cutter`.
- Compare `kubectl -n outpost get net-attach-def` with `kubectl -n starfleet get net-attach-def`.
- Repair both pods and check them with `kubectl exec <pod> -- ip -4 addr`.
- Break a working attachment on purpose with a wrong name in the annotation and read the event.
