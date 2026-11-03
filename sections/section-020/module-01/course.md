---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# Pod CIDR Allocation To Nodes

Every pod in a Kubernetes cluster needs its own IP address, and no two pods may share one. Someone must keep track of which addresses are in use. Kubernetes solves this in two steps. First it gives each node a block of addresses that belongs only to that node. Then the network plugin on the node gives out addresses from that block, without asking any other node. This module covers the first step: how the blocks are made and where you can read them.

You will read the cluster-wide address range, see which range each node received, and see how a network plugin such as flannel learns the range of its own node.

The module has two parts. The first part explains the cluster CIDR, the controller that splits it and the flags that control the split. The second part shows where the ranges appear in Kubernetes objects and how a pod address relates to the range of its node.

## Learning objectives

After this module you can:

- Explain what a CIDR block is and how many addresses a `/24` block holds.
- Explain what the node IPAM controller does and which flags control it.
- Read `spec.podCIDR` from a node and the pod network from the cluster configuration.
- Explain how flannel learns the range of its node and where it stores it.
- Tell which pods use a node range and which pods do not.

## Before you start

You need Kubernetes basics: pods, nodes, namespaces and the commands `kubectl get` and `kubectl describe`.

Your playground is a two-node kind cluster running Kubernetes 1.35. flannel v0.28.10 is the network plugin. The cluster pod network is `10.244.0.0/16`.

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `outpost` | Pod `drifter` | A client pod with `curl` in another namespace |

`kubectl` already points at the playground cluster. Launch the playground now and keep it running while you read the parts:

<!-- astrona:playground -->
