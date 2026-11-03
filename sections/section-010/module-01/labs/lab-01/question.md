---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# Record The CNI Configuration Of The Nodes

Solve this question on: `terminal`

The platform team wants a short record of how the nodes of the cluster are set up for pod networking. The cluster uses flannel. Read the values from the live cluster. Do not guess them.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-010-01-01)"
```

Create the ConfigMap `cni-evidence` in the namespace `starfleet` with these three keys:

1. `conf-file-name`: the file name (without directory) that the init container `install-cni` of the DaemonSet `kube-flannel-ds` writes into the CNI configuration directory of each node.
2. `network-name`: the value of the field `name` in the CNI configuration that flannel installs. The configuration is the key `cni-conf.json` of the ConfigMap `kube-flannel-cfg` in `kube-flannel`.
3. `plugin-types`: the `type` of every plugin in the same configuration, in the order the runtime runs them, separated by commas and without spaces.

The grader reads the same values from the live API and compares them with your ConfigMap. Do not change any object in `kube-flannel`.
