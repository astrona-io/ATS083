---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# Managing IPAM and Pod CIDR Allocation

This section explains how a Kubernetes cluster decides which IP address each pod receives. The work happens at two levels. The cluster gives each node a range of addresses, called the pod CIDR. The CNI plugin on the node then hands out single addresses from that range.

Each module has a landing page, two reading parts and a summary. The readings use a private playground for hands-on steps. Each module has one graded lab, and the section ends with a capstone lab and a knowledge check.

## Modules

**Pod CIDR Allocation To Nodes**

- Explain what the cluster CIDR is and which component splits it into node ranges.
- Name the flags of the kube-controller-manager that control node range allocation.
- Read the pod CIDR of a node from the Node object.
- Explain how flannel learns the range of its node.

**IPAM In The CNI Plugin**

- Describe how the host-local IPAM plugin chooses and records a pod address.
- Find the files in which host-local keeps its state.
- Calculate how many pods a node range can hold.
- Recognise the symptoms of an exhausted range and of overlapping networks.

## Labs and quiz

The labs are marked UNTESTED: they passed static checks and have not been run. The capstone lab combines the skills of the section. The quiz has single-choice questions and a pass score of 70 percent.
