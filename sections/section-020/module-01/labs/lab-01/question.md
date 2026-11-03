---
draft: true
exam_objectives:
- Managing IPAM and Pod CIDR Allocation
---
# Record The Pod Ranges Of The Nodes

Solve this question on: `terminal`

The `starfleet` namespace and the `outpost` namespace run on a cluster that uses flannel as its network plugin. The platform team wants a short report of the pod network of the cluster. Read the values from the live cluster. Do not guess them.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-020-01-01)"
```

Create the ConfigMap `cni-evidence` in the namespace `starfleet` with these four keys:

1. `cluster-cidr`: the pod network that flannel routes, taken from the field `Network` in `net-conf.json` of the ConfigMap `kube-flannel-cfg` in `kube-flannel`.
2. `node-count`: the number of nodes in the cluster.
3. `worker-pod-cidr`: the pod CIDR of the node that does not have the control-plane role.
4. `shuttle-node`: the name of the node that runs the Pod `shuttle` in `starfleet`.

The grader reads the same values from the live API and compares them with your ConfigMap. Do not change any other object.
