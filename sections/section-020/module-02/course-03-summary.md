---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# Summary

The CNI plugin hands out single pod addresses from the range of its node. With flannel, the main plugin is `bridge` and the IPAM plugin is `host-local`. The range comes from `subnet.env`, which flannel writes from `spec.podCIDR` of the node. The plugin keeps one file per allocated address in `/var/lib/cni/networks/cbr0` and takes the lowest free address, so state lives on the node and no other node is asked.

## What you learned

A `/24` node range has 254 usable addresses. One goes to the gateway, so 253 remain for pods, which is above the kubelet default of 110 pods per node. A smaller node mask can run out of addresses before the kubelet limit applies.

When a range is full, the pod stays in `ContainerCreating` and the event `FailedCreatePodSandBox` shows that no addresses are available in the range set. Only that node is affected. Finished pods that are not removed can still hold addresses.

The pod network, the node network and the Service network must not overlap with each other or with networks that pods must reach. The field `spec.podCIDR` of a node cannot be changed in place, so a new range needs new nodes.

- `host-local` allocates from the node range and records each address in a file.
- Capacity is the prefix size minus network, broadcast and gateway addresses.
- Exhaustion shows as `FailedCreatePodSandBox` on one node only.
- Overlapping ranges cause wrong routing that looks random.
- Replace nodes to change a range; do not edit files on the node.

<!-- astrona:playground:destroy -->
