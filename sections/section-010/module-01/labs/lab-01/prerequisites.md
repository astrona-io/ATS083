# Prerequisites

- The `astrona` command-line tool, installed and working.
- A container engine that kind can use (Podman or Docker) with about 4 GiB of free memory, because the cluster has two nodes.
- `kubectl`.
- Basic knowledge of Pods, Deployments, Services and namespaces.

The lab starts a two-node kind cluster (Kubernetes v1.35.0) without a default network plugin, installs the reference CNI plugins v1.9.1 and flannel v0.28.10, and creates the example workloads in `starfleet` and `outpost`.
