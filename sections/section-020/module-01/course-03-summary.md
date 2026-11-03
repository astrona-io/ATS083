---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# Summary

A Kubernetes cluster gives every pod a unique IP address by splitting the work into two levels. The cluster CIDR is one large block, for example `10.244.0.0/16`. The node IPAM controller in the kube-controller-manager cuts it into smaller blocks and writes one block into `spec.podCIDR` of each new Node object. The flags `--allocate-node-cidrs`, `--cluster-cidr` and `--node-cidr-mask-size` control this work.

## What you learned

With a `/16` cluster CIDR and a `/24` node mask, the cluster can hold 256 node ranges, and each range has 254 host addresses. A node keeps its range for its whole life, and the field cannot be changed on an existing node. The pod network, the node network and the Service network are three separate ranges that must not overlap.

The network plugin does not choose the range. flannel runs with `--kube-subnet-mgr`, reads `spec.podCIDR` of its own node and writes the result to `/run/flannel/subnet.env` on the node. The plugin reads that file when a pod starts. The value `Network` in the ConfigMap `kube-flannel-cfg` must name the same block as the cluster CIDR.

To check an address problem you read three objects: the Node for its range, the Pod for its node and its address, and the flannel configuration for the routed network. Pods with `hostNetwork: true` use the address of the node and do not take an address from the node range.

- The node IPAM controller cuts node ranges from the cluster CIDR.
- `spec.podCIDR` of a Node is set once and does not change.
- flannel reads the range from the Node object and keeps it in `/run/flannel/subnet.env`.
- A pod address should lie inside the range of the node that runs the pod.
- `hostNetwork` pods are the exception: they show the node address.

<!-- astrona:playground:destroy -->
