---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Reading Links, Routes And Neighbours

The command `ip` has one object per kind of information: `link` for interfaces, `addr` for addresses, `route` for the routing table and `neigh` for the neighbour table. This part shows how to read each object, which fields matter for troubleshooting, and which results point to which fault.

The output format of `ip` is stable, but the exact numbers depend on your cluster. This text therefore describes fields and does not show sample output. Run the commands in the playground and read your own values.

<!-- astrona:playground:renew -->

## Links: ip link

The command lists the interfaces and their layer 2 properties.

```sh
kubectl -n starfleet exec shuttle -- ip link show
```

For each interface, read these fields:

- The state flags in angle brackets. `UP` means the administrator enabled the interface. `LOWER_UP` means the cable end is connected. An interface that is `UP` but without `LOWER_UP` has no link.
- `mtu` is the largest packet, in bytes, that the interface sends without splitting it.
- `state` is the operational state. `UP` is normal. `DOWN` means no traffic passes.
- `link/ether` is the MAC address of the interface.
- The suffix after the name, as in `eth0@if` and a number, is the interface index of the veth peer on the node.

The MTU needs attention. Flannel with the vxlan backend wraps each packet in a UDP packet, which adds a header of 50 bytes. The pod MTU must therefore be lower than the MTU of the node interface by that amount. If the pod MTU equals the node MTU, small packets pass and large packets are dropped. The typical symptom is that a ping works and an HTTP response with a large body hangs.

## Addresses: ip addr

The command lists the addresses of each interface.

```sh
kubectl -n starfleet exec shuttle -- ip -4 addr show dev eth0
```

Read the line that starts with `inet`. It has the address and the prefix length in one field, for example the form `A.B.C.D/N`. The prefix length tells which addresses are on the same link. In a flannel cluster the pod address is inside the range of its node. The option `-4` prints only IPv4, `-o` prints one line for each address, which is useful for scripts, and `dev eth0` limits the output to one interface.

If the pod has no `inet` address on `eth0`, the CNI plugin did not finish its work. Check the events of the pod and the log of the network plugin pod on that node.

## Routes: ip route

The routing table tells the kernel where to send a packet. Read it with:

```sh
kubectl -n starfleet exec shuttle -- ip route show
```

A pod usually has two kinds of entries. A default route has the form `default via <gateway> dev eth0` and covers all destinations. A connected route names the pod subnet and the device and covers addresses on the same link. The gateway of the default route is the address of the bridge on the node, which is the first address of the node range in a default flannel setup.

To ask what the kernel would do for one destination, use `ip route get`. It prints the chosen route, the source address and the device:

```sh
kubectl -n starfleet exec shuttle -- ip route get 10.96.0.1
```

Use an address that you want to test. For a Service address, a pod has no specific route, so the default route is chosen. The packet then goes to the node, and the Service rules on the node change the destination.

On the node, the table is larger. There is one route for the range of each other node, pointing to the flannel interface, and one route for the local range, pointing to the bridge. A missing route for another node range is the reason why pods on that node are unreachable.

## Neighbours: ip neigh

The neighbour table maps IP addresses on the same link to MAC addresses. Before a pod sends the first packet to its gateway, it sends an ARP request and stores the answer.

```sh
kubectl -n starfleet exec shuttle -- ip neigh show
```

The table can be empty if the pod has not sent traffic recently. Send a request first, for example with `curl`, and look again. Read the state at the end of each line:

- `REACHABLE` means the entry was confirmed recently.
- `STALE` means the entry is known but not confirmed for a while. It is not an error.
- `FAILED` means the neighbour did not answer to ARP requests. The gateway or the veth link is broken.
- `INCOMPLETE` means a request is out and no answer has come yet.

## From symptom to cause

| Symptom | What to check with ip |
| --- | --- |
| Pod has no address | `ip addr show dev eth0` has no `inet` line |
| Pod cannot leave the node | `ip route show` has no default route, or `ip neigh` shows `FAILED` for the gateway |
| Large responses hang | `ip link` shows an MTU that is too high for the path |
| Traffic goes to the wrong subnet | `ip route get` chooses another device than expected |

## Common pitfalls

> [!WARNING]
> Do not change interfaces or routes by hand inside a running pod to fix a fault. The change is lost when the pod restarts, and it hides the real cause in the network plugin. Use `ip` to read, find the cause, and correct the configuration of the plugin or the node. Also take care with the output of a pod that has several interfaces: read the device name at the end of each route, because `eth0` and a secondary interface can both carry routes.
