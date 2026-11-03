---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Summary

In a default cluster, kube-proxy turns a Service into iptables rules in the `nat` table. The chain `KUBE-SERVICES` matches the cluster IP and port, a `KUBE-SVC-` chain chooses an endpoint, and a `KUBE-SEP-` chain performs the `DNAT` to the pod address. The rules exist on every node, so a Service works from any pod, and a fault in kube-proxy on one node affects only that node.

## What you learned

You read the rules with `iptables-save -t nat` from a debug pod on the node, with the profile for system administration. You found the chain of one Service by the comment with its namespace and name, and compared the addresses in the rules with the Service, the EndpointSlice and the pod. The counters of a rule show whether packets reach it.

You captured traffic with `tcpdump` inside a pod, using an ephemeral debug container, and on a node. A filter keeps the output readable. The TCP flags show the stage of the connection: SYN, SYN-ACK, data, reset and close. Captures on both sides of a hop show where a packet was lost, and the destination address shows whether the `DNAT` happened.

- Service addresses are virtual. The node rewrites the destination before the packet leaves.
- `iptables` explains what should happen, and `tcpdump` proves what happened.
- Read the rules and the captures. Do not flush chains of kube-proxy.
- Remove debug containers and debug pods when you are finished.

<!-- astrona:playground:destroy -->
