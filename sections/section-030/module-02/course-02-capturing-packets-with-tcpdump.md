---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Capturing Packets With tcpdump

`iptables` tells you what the node should do with a packet. `tcpdump` shows what crosses an interface. When a connection fails, a capture answers questions that no Kubernetes object can answer: did the request leave the client, did it arrive, did the server answer, and did the answer come back. This part explains where to capture, how to write a filter and how to read the result.

## What tcpdump does

`tcpdump` opens a network interface in the namespace where it runs, receives a copy of the packets and prints one line for each packet. It does not change traffic. It needs the privilege to open a raw socket, so it normally runs as root with the capability `NET_RAW`.

Two facts decide where you can see traffic. First, `tcpdump` sees only the interfaces of its own network namespace. A capture in the host namespace does not show the loopback traffic of a pod. Second, a capture sees packets in the form they have on that interface. Before the Service `DNAT` the destination is the Service address, and after it the destination is the pod address. The same request looks different at different points of the path.

## Where to capture

Choose the point of capture by the question you want to answer.

- Inside the client pod. It shows the packet as the application sent it, with the Service address as the destination. Use it to see whether the client sends anything and whether replies arrive.
- Inside the server pod. It shows the packet after the `DNAT`, with the pod address as the destination. Use it to see whether the request reaches the server at all.
- On the node, on the veth interface of a pod or on the bridge. It shows traffic of all pods of the node.
- On the node, on the flannel interface or on the node interface. It shows traffic between nodes. On the node interface the overlay traffic is wrapped in UDP packets. For the vxlan backend the outer port is UDP 8472 in the default flannel setup, so a filter for that port shows the tunnel.

Capture on both sides of one hop and compare. A packet that appears on the sender side and is missing on the receiver side was dropped between them.

## Getting tcpdump into a pod or onto a node

Most application images do not contain `tcpdump`. Add it without changing the pod, with an ephemeral debug container that shares the network namespace of the target container. The image must contain `tcpdump`. Network troubleshooting images do, such as netshoot, so check the tag you use.

<!-- astrona:playground:renew -->

```sh
kubectl -n starfleet debug -it pod/<probe-pod-name> --image=<image-with-tcpdump> --target=probe -- tcpdump -n -i eth0
```

Replace `<probe-pod-name>` with the name from `kubectl -n starfleet get pods` and `<image-with-tcpdump>` with the image you chose. The debug container shares the namespace of the pod, so `eth0` is the interface of the pod. For a capture on the node, use the node form with the profile for system administration:

```sh
kubectl debug node/<node-name> -it --profile=sysadmin --image=<image-with-tcpdump> -- tcpdump -n -i any host <pod-address>
```

On the node the debug pod uses the host network, so the interface list is the list of the node. The interface name `any` captures on all interfaces at once, which is useful when you do not know the path.

## Writing a filter

Without a filter, a capture on a busy node is unreadable. A filter uses the pcap expression language. These options and primitives cover most cases:

- `-n` prints addresses and ports as numbers. It stops name lookups that would slow down the output and add their own DNS traffic.
- `-i <interface>` selects the interface.
- `-c <count>` stops after that many packets.
- `host <address>`, `src host <address>` and `dst host <address>` select packets by address.
- `port <number>`, `tcp`, `udp` and `icmp` select by protocol and port.
- `and`, `or` and `not` combine primitives, and parentheses group them.
- `-w <file>` writes raw packets to a file, and `-r <file>` reads a file back.
- `-e` prints the link layer header with the MAC addresses.

An example that selects the requests of one client to the `probe` Service port:

```sh
tcpdump -n -i eth0 host <client-address> and tcp port 9898
```

Replace `<client-address>` with the address of `shuttle`. While the capture runs, start `curl` from `shuttle` against the Service in a second terminal.

## Reading a TCP capture

Each line has a time stamp, the protocol, the source and destination with ports, and the TCP flags. The flags tell the stage of the connection.

- `[S]` is a SYN, the first packet of a new connection.
- `[S.]` is a SYN-ACK, the answer of the server.
- `[.]` is an ACK. `[P.]` is data with ACK. `[F.]` closes the connection.
- `[R]` or `[R.]` is a reset. It means the receiver refused the connection or does not know it.

Four patterns cover most faults:

| What you see | What it means |
| --- | --- |
| SYN repeats, no SYN-ACK | The packet is lost on the way, or the server host does not answer |
| SYN answered with a reset | The packet reached the host, but no process listens on the port |
| Handshake completes, data stops | A size problem on the path, often the MTU, or an application that does not answer |
| SYN seen on the client but not on the server | A rule or route dropped it between the two captures |

Compare the client capture and the server capture. Check also the source and destination addresses in both: the destination in the client capture should be the Service address, and in the server capture it should be the pod address. If both show the Service address, the `DNAT` did not happen.

## Capturing UDP and DNS

The same method works for UDP. A DNS query is a UDP packet to port 53, and the capture shows the query and the answer as two lines with the same transaction number. A query without an answer points to a lost packet or a DNS server that does not run. Use the filter `udp port 53` to see only DNS traffic.

## Common pitfalls

> [!WARNING]
> A capture can expose passwords and tokens in unencrypted traffic, so capture only what you need, use a filter, and delete the files when you are done. Do not leave ephemeral containers or node debug pods running, because a debug pod on a node holds a privileged view of the node. Remember that a capture shows a copy of the traffic: the packet counters of the interface and the lines of the capture can differ if the capture buffer overflows on a busy node.
