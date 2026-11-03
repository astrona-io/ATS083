---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Summary

Every pod has its own network namespace with its own interfaces, addresses, routes and neighbour table. The runtime creates the namespace and the CNI plugin fills it. A veth pair connects the pod interface `eth0` to the node, where the other end is attached to a bridge. The command `ip` shows the state of whatever namespace it runs in.

## What you learned

You can run `ip` in a pod with `kubectl exec`, in a running pod with an ephemeral debug container, and in the host namespace with `kubectl debug node`. The result depends on the namespace, so always check where the command runs.

The object `link` shows state, MTU and MAC address. The object `addr` shows addresses and prefix lengths. The object `route` shows the default gateway and `route get` shows the choice of the kernel for one destination. The object `neigh` shows which neighbours answered ARP requests.

An MTU that is too high for the vxlan overlay lets small packets pass and drops large ones. A missing default route or a `FAILED` gateway entry stops all traffic that leaves the node.

- A pod namespace is shared by all containers of the pod.
- The `eth0@if` suffix names the interface index of the veth peer.
- `ip -4 -o addr show dev eth0` is a compact form for scripts.
- Read first, change nothing by hand in a running pod.

<!-- astrona:playground:destroy -->
