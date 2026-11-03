# Overview: Installing A Network Plugin On A Cluster (Playground)

This is a playground, not a lab. It starts a fresh two-node kind cluster (Kubernetes v1.35.0) with the reference CNI plugins v1.9.1 installed on both nodes and no network plugin. There is no task, no `astrona submit` and no pass or fail.

Connect to it first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-playground-010-02)"
```

## What is in the cluster

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-system` | DaemonSet `cni-plugins` | Installs the reference CNI plugins into `/opt/cni/bin` on every node |
| `kube-system` | Deployment `coredns` | Stays `Pending` until a network plugin runs |

The cluster has no example workloads and no network plugin, so both nodes are `NotReady`. Create test pods with `kubectl run` when you need them.

## Practice tasks

- Run `kubectl get nodes` and read the `Ready` condition message of a node with `kubectl describe node`.
- List all pods with `kubectl get pods -A -o wide` and find which ones run and which ones are `Pending`.
- Install flannel with `kubectl apply -f https://github.com/flannel-io/flannel/releases/download/v0.28.10/kube-flannel.yml` and watch the nodes change to `Ready`.
- Start a pod and compare its address with the `spec.podCIDR` of its node.
- Start a pod on the control-plane node with `nodeName` and send a request to a pod on the worker node.
- Delete the pods that `kubectl debug` created when you finish.
