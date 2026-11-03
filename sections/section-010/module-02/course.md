---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# Installing A Network Plugin On A Cluster

A new Kubernetes cluster can run its control plane before it has a pod network, but it cannot run ordinary pods. The nodes report `NotReady`, and the pods that need a network wait. A network plugin fixes this. This module explains why a node needs a plugin, what still works without one, and how to install and verify flannel, a small network plugin that is installed from one manifest.

Keep one sentence in mind: **a node becomes Ready when the container runtime finds a valid CNI configuration, and a plugin installer puts that configuration on every node.** You will see the problem first and then solve it with one `kubectl apply`.

The module has two parts. The first part reads the symptoms of a cluster without a network plugin and explains each one. The second part installs flannel, explains each object of the manifest and verifies the result, including traffic between pods on different nodes.

## Learning objectives

After this module you can:

- Explain why a node reports `NotReady` when no CNI configuration exists.
- Say which pods still run without a network plugin, and why.
- Install flannel from a pinned manifest and explain the objects it creates.
- Verify that the nodes are `Ready`, that pods receive addresses from the pod network and that pods on different nodes reach each other.

## Before you start

You need Kubernetes basics: pods, DaemonSets, taints and tolerations, namespaces and the commands `kubectl get` and `kubectl describe`. A taint is a mark on a node that keeps pods away unless they have a matching toleration.

Your playground is a two-node kind cluster running Kubernetes 1.35. The reference CNI plugins, such as `bridge` and `host-local`, are installed in `/opt/cni/bin` on both nodes. No network plugin is installed, so no CNI configuration file exists. The cluster has no example workloads: create test pods with `kubectl run` when a step needs them.

| Node | Role |
| --- | --- |
| The `control-plane` node | Runs the API server and the other control plane components |
| The `worker` node | Runs ordinary pods |

`kubectl` already points at the playground cluster. Launch the playground now and keep it running while you read the parts:

<!-- astrona:playground -->
