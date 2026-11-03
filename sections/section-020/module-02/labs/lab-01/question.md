---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# Trace A Pod Address To Its Node Range

Solve this question on: `terminal`

The `starfleet` namespace runs a Deployment `crew` with four pods, and the Pod `shuttle`. The cluster uses flannel. The platform team wants to know where these pods got their addresses. Read the values from the live cluster. Do not guess them.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-020-02-01)"
```

Create the ConfigMap `cni-evidence` in the namespace `starfleet` with these four keys:

1. `shuttle-ip`: the IP address of the Pod `shuttle`.
2. `shuttle-node-cidr`: the pod CIDR of the node that runs `shuttle`.
3. `crew-on-worker`: the number of `crew` pods whose address lies inside the pod CIDR of the node that does not have the control-plane role.
4. `crew-total`: the number of pods with the label `app=crew`.

The grader reads the same values from the live API and compares them with your ConfigMap. Do not change any other object.
