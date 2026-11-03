---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Multus And Network Attachment Definitions

A normal pod has one network interface, `eth0`, which connects it to the cluster pod network. Some workloads need more than one network: a separate network for storage traffic, a separate network for a router function, or a network that reaches a different address range. Kubernetes itself has no field for a second pod interface. The CNI plugin Multus adds this ability.

In this module you learn how Multus works together with the main network plugin, how an extra network is described in a NetworkAttachmentDefinition object, and how a pod asks for the extra network with an annotation.

The module has two parts. The first part explains the call path: how Multus sits between the container runtime and the other CNI plugins and why the first interface is still created by the cluster network plugin. The second part covers the NetworkAttachmentDefinition object, the annotation syntax and the network status that Multus writes back.

## Learning objectives

After this module you can:

- Explain why a pod normally has one interface and how Multus adds more.
- Name the roles of the default network and of the additional networks.
- Write a NetworkAttachmentDefinition with the `bridge` plugin and the `host-local` IPAM plugin.
- Attach a pod to one or more networks with the annotation `k8s.v1.cni.cncf.io/networks`.
- Choose the namespace and the interface name of an attachment.
- Read the interfaces of a pod and the status annotation that Multus writes.

## Before you start

You need to know pods, annotations and namespaces, and to know that the container runtime calls a CNI plugin when a pod starts.

Your playground is a two-node kind cluster running Kubernetes 1.35 with flannel v0.28.10 as the default network and Multus v4.3.1.

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `starfleet` | NetworkAttachmentDefinition `side-net` | A bridge network on 192.168.50.0/24 |
| `starfleet` | Pod `tender` | A client pod with a second interface on `side-net` |
| `outpost` | Pod `drifter` | A client pod with `curl` in another namespace |

`kubectl` already points at the playground cluster. Launch the playground now and keep it running while you read the parts:

<!-- astrona:playground -->
