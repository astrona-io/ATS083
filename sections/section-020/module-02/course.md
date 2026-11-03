---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# IPAM In The CNI Plugin

A node range is only a block of addresses. Someone must still pick one free address for each new pod, remember that it is taken and release it when the pod stops. This work is called IP address management (IPAM), and the CNI plugin does it on every node, without contacting the control plane. This module explains how the standard `host-local` IPAM plugin works, which files it keeps on the node and what happens when the range runs out.

You will read the IPAM settings that flannel passes down, find the allocation files, and calculate how many pods a node range can hold.

The module has two parts. The first part follows one pod start through flannel and `host-local` and shows the files that result. The second part covers the capacity of a range, the symptoms of exhaustion and the problems that overlapping networks cause.

## Learning objectives

After this module you can:

- Explain what an IPAM plugin does and how a network plugin calls it.
- Describe the fields of a `host-local` configuration: `subnet`, `rangeStart`, `rangeEnd` and `gateway`.
- Find the allocation files of `host-local` and say what each file contains.
- Calculate the capacity of a node range and compare it with the pod limit of the kubelet.
- Recognise an exhausted range and an overlap of address ranges.

## Before you start

You need to know that each node has a pod CIDR and that the CNI plugin is called when a pod starts.

Your playground is a two-node kind cluster running Kubernetes 1.35 with flannel v0.28.10. The example Deployment `crew` has four pods that spread over the nodes.

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server on port 9898 |
| `starfleet` | Deployment `crew` | Four pods with the same small HTTP server |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `outpost` | Pod `drifter` | A client pod with `curl` in another namespace |

`kubectl` already points at the playground cluster. Launch the playground now and keep it running while you read the parts:

<!-- astrona:playground -->
