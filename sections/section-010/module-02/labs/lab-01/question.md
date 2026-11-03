---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# Install Flannel On A Cluster Without A Network Plugin

Solve this question on: `terminal`

The `outpost` team received a new two-node cluster. Both nodes are `NotReady` because no network plugin is installed. The reference CNI plugins are already on the nodes. Install flannel and prove that pods get addresses from the pod network.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-010-02-01)"
```

1. Install flannel by applying the manifest of release v0.28.10 from `https://github.com/flannel-io/flannel/releases/download/v0.28.10/kube-flannel.yml`. Do not edit the manifest.
2. Wait until both nodes are `Ready` and the Deployment `coredns` in `kube-system` is available.
3. Create a pod named `check-a` in the namespace `default` with the image `curlimages/curl:8.22.0` that runs `sleep 3600`. Wait until it runs.

The grader checks that both nodes are `Ready`, that the flannel DaemonSet is ready on every node with its original image, that CoreDNS is available and that `check-a` has an address in `10.244.0.0/16`.
