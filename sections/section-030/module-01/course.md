---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Inspecting Pod Network Interfaces With ip

When a pod cannot reach another pod, the cause is often on the network layer: a missing address, a wrong route, a wrong MTU or a missing interface. The Kubernetes API shows the address of a pod, but it does not show the interfaces, routes and neighbours that Linux uses to send packets. The command `ip` from the iproute2 package shows them. This module explains what a pod network namespace is and how to read it with `ip`.

Keep one sentence in mind: **a pod has its own network namespace, and `ip` shows the interfaces, addresses and routes of the namespace that it runs in.** You will run the same commands in a pod and on a node and compare the results.

The module has two parts. The first part explains the network namespace of a pod, the virtual interface pair that connects it to the node, and the ways to enter the namespace. The second part reads links, addresses, routes and neighbours and explains the fields that matter during troubleshooting.

## Learning objectives

After this module you can:

- Explain what a network namespace is and why every pod has its own.
- Explain how a veth pair connects the pod namespace to the node.
- Run `ip` inside a pod with `kubectl exec` and on a node with `kubectl debug`.
- Read the address, MAC address, MTU, state and default gateway of a pod interface.
- Read the routes and neighbour entries of a pod and explain what they say.

## Before you start

You need Kubernetes basics: pods, nodes, namespaces and the commands `kubectl get`, `kubectl exec` and `kubectl describe`. You should know what an IP address, a subnet mask and a default gateway are.

Your playground is a two-node kind cluster running Kubernetes 1.35 with flannel v0.28.10. The pod network is `10.244.0.0/16`.

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` and the busybox tools |
| `outpost` | Pod `drifter` | A client pod with `curl` in another namespace |

`kubectl` already points at the playground cluster. Launch the playground now and keep it running while you read the parts:

<!-- astrona:playground -->
