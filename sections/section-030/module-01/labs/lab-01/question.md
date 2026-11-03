---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Record The Network Settings Of A Pod

Solve this question on: `terminal`

The Pod `shuttle` in the namespace `starfleet` cannot reach a service on another network, and the platform team wants to see its network settings. Read the values from inside the pod. Do not guess them.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-030-01-01)"
```

Create the ConfigMap `cni-evidence` in the namespace `starfleet` with these four keys:

1. `shuttle-ip`: the IPv4 address of the interface `eth0` in the pod, without the prefix length.
2. `shuttle-mac`: the MAC address of `eth0`.
3. `shuttle-mtu`: the MTU of `eth0`.
4. `shuttle-gateway`: the address of the default gateway in the routing table of the pod.

The grader reads the same values from the running pod and compares them with your ConfigMap. Do not change any other object.
