---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# IPAM Capstone

Solve this question on: `terminal`

A two-node cluster uses flannel. The platform team wants an audit of pod address allocation and one new pod on the worker node. Read all values from the live cluster. Do not guess them.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-020-cap)"
```

1. Create the Pod `latecomer` in the namespace `outpost`. Use the image `curlimages/curl:8.22.0` with the command `sh -c "while true; do sleep 30; done"`. It must run on the node that does not have the control-plane role. Use a `nodeSelector` on the label `kubernetes.io/hostname`.
2. Create the ConfigMap `ipam-report` in the namespace `starfleet` with these keys:
   - `control-plane-cidr`: the pod CIDR of the control-plane node.
   - `worker-cidr`: the pod CIDR of the worker node.
   - `pods-outside-ranges`: the number of pods that have an address outside the pod CIDR of their node. Do not count pods that use the host network. Count after `latecomer` is running.

The grader reads the same values from the live API. Do not change any other object.
