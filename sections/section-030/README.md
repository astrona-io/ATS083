---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues

This section teaches how to look below the Kubernetes API when a connection fails. The command `ip` shows the interfaces, addresses and routes of a pod. The command `iptables` shows the rules that kube-proxy writes for Services. The command `tcpdump` shows the packets that cross an interface.

Each module has a landing page, two reading parts and a summary. The readings use a private playground for hands-on steps. Each module has one graded lab, and the section ends with a capstone lab and a knowledge check.

## Modules

**Inspecting Pod Network Interfaces With ip**

- Explain what a network namespace is and how a veth pair connects a pod to its node.
- Run `ip` in a pod, in an ephemeral debug container and on a node.
- Read the address, MAC address, MTU and default gateway of a pod.
- Read routes and neighbour entries and link them to faults.

**Packet-level Tools: iptables And tcpdump**

- Follow a packet to a Service address through the kube-proxy chains.
- Read the NAT rules and counters of a node.
- Capture traffic in a pod and on a node with a filter.
- Read TCP flags to find where a connection fails.

## Labs and quiz

The labs are marked UNTESTED: they passed static checks and have not been run. The capstone lab combines the skills of the section. The quiz has single-choice questions and a pass score of 70 percent.
