---
draft: true
exam_objectives:
- Using Linux Tools (iptables, ip, tcpdump) for Packet-level Issues
---
# Packet-level Capstone

Solve this question on: `terminal`

A two-node cluster uses flannel. The platform team needs a report of the network settings of one pod and of the Service `probe`, and a pod that runs in the network namespace of its node. Read all values from the live cluster. Do not guess them.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-030-cap)"
```

1. Create the Pod `netcheck` in the namespace `outpost`. Use the image `curlimages/curl:8.22.0` with the command `sh -c "while true; do sleep 30; done"`. It must use the network of its node (`hostNetwork: true`).
2. Create the ConfigMap `packet-report` in the namespace `starfleet` with these keys:
   - `drifter-ip`: the IPv4 address of `eth0` in the Pod `drifter` in `outpost`, without the prefix length.
   - `drifter-mtu`: the MTU of `eth0` in the same pod.
   - `probe-service-ip`: the cluster IP of the Service `probe`.
   - `probe-endpoint-ip`: the pod address that the EndpointSlice of `probe` lists.

The grader also checks that `netcheck` can reach the Service `probe` by its cluster IP. Do not change any other object.
