---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Packet-level Tools: iptables And tcpdump

Some faults cannot be found by reading Kubernetes objects. The Service exists, the endpoints are listed, and the pod is Running, but the connection still fails. To find the fault you must look at what the node does with the packet. Two tools answer this. `iptables` shows the rules that rewrite and filter packets, and `tcpdump` shows the packets that really cross an interface. This module explains how kube-proxy uses iptables to implement a Service, and how to capture and read traffic.

Keep one sentence in mind: **iptables explains what should happen to a packet, and tcpdump proves what did happen.** Use the first to form a theory and the second to test it.

The module has two parts. The first part follows a packet to a Service address through the chains that kube-proxy creates. The second part captures traffic in a pod and on a node, and shows how to read the result.

## Learning objectives

After this module you can:

- Explain what kube-proxy writes into the `nat` table for a Service and for its endpoints.
- Name the main chains and follow a packet from a Service address to a pod address.
- Run `iptables` against the rules of a node and read the packet counters.
- Capture traffic with `tcpdump` in a pod and on a node with a filter.
- Decide from a capture whether a packet was sent, answered, dropped or rewritten.

## Before you start

You need Kubernetes basics: Services, Endpoints, DaemonSets and the commands `kubectl exec` and `kubectl debug`. You should know what TCP and UDP are, and what a three-way handshake is.

Your playground is a two-node kind cluster running Kubernetes 1.35 with flannel v0.28.10. kube-proxy runs on each node.

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `outpost` | Pod `drifter` | A client pod with `curl` in another namespace |

`kubectl` already points at the playground cluster. Launch the playground now and keep it running while you read the parts:

<!-- astrona:playground -->
