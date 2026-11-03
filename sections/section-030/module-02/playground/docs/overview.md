# Overview: Packet-level Tools: iptables And tcpdump (Playground)

This is a playground, not a lab. It starts a fresh two-node kind cluster (Kubernetes v1.35.0) with flannel v0.28.10 as the network plugin, creates the example workloads, and waits. There is no task, no `astrona submit` and no pass or fail.

Connect to it first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-playground-030-02)"
```

## What is in the cluster

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server (podinfo) on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `outpost` | Pod `drifter` | A client pod with `curl`, in another namespace |
| `kube-system` | DaemonSet `kube-proxy` | Writes the Service rules on every node |
| `kube-flannel` | DaemonSet `kube-flannel-ds` and ConfigMap `kube-flannel-cfg` | The network plugin and its configuration |

## Practice tasks

- Print the NAT rules of a node with `kubectl debug node/<node> -it --profile=sysadmin --image=busybox:1.37.0 -- chroot /host iptables-save -t nat` and find the chain for `starfleet/probe`.
- Compare the cluster IP and the pod address in the rules with `kubectl -n starfleet get service,endpointslices -o wide`.
- Scale `probe` to three replicas and look at the new `KUBE-SEP-` chains and the probabilities in the `KUBE-SVC-` chain.
- Send a request from `shuttle` with `curl` and compare the packet counter of the rule before and after.
- Capture traffic of the `probe` pod with an ephemeral debug container that has `tcpdump`, and read the SYN and SYN-ACK packets.
