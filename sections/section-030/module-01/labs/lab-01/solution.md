---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Record The Network Settings Of A Pod: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-030-01-01)"
```

## Step 1: Read the address

The option `-4` limits the output to IPv4, `-o` prints one line, and `dev eth0` selects the interface. The address is in the fourth field, followed by a slash and the prefix length.

```sh
kubectl -n starfleet exec shuttle -- ip -4 -o addr show dev eth0
```

## Step 2: Read the MAC address and the MTU

The values are also in `ip link show eth0`. The files under `/sys/class/net/eth0` hold the same values without other text.

```sh
kubectl -n starfleet exec shuttle -- cat /sys/class/net/eth0/address
kubectl -n starfleet exec shuttle -- cat /sys/class/net/eth0/mtu
```

## Step 3: Read the default gateway

The gateway is the word after `via` in the line that starts with `default`.

```sh
kubectl -n starfleet exec shuttle -- ip -4 route show default
```

## Step 4: Save the report

This command reads the four values again and writes the ConfigMap in one step.

```sh
kubectl -n starfleet create configmap cni-evidence \
  --from-literal=shuttle-ip="$(kubectl -n starfleet exec shuttle -- ip -4 -o addr show dev eth0 | awk '{print $4}' | cut -d/ -f1)" \
  --from-literal=shuttle-mac="$(kubectl -n starfleet exec shuttle -- cat /sys/class/net/eth0/address | tr -d '\r')" \
  --from-literal=shuttle-mtu="$(kubectl -n starfleet exec shuttle -- cat /sys/class/net/eth0/mtu | tr -d '\r')" \
  --from-literal=shuttle-gateway="$(kubectl -n starfleet exec shuttle -- ip -4 route show default | awk '{print $3}' | head -n 1)"
```

Submit with `astrona submit -c sections/section-030/module-01/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-030-01-01`.

## Common pitfalls

> [!WARNING]
> Do not run these commands on a node: the settings of the node differ from the settings of the pod. Do not keep the prefix length in `shuttle-ip`, because the grader compares only the address. A value read without `tr -d '\r'` can end with a carriage return that makes the comparison fail.
