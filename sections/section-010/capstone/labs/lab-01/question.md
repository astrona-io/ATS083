---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# CNI Installation Capstone

Solve this question on: `terminal`

A new two-node cluster has no network plugin: both nodes are `NotReady` and no workload runs. The platform team needs flannel installed, a record of how it is set up and one pod that proves the pod network works.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-010-cap)"
```

1. Install flannel by applying the manifest of release v0.28.10 from `https://github.com/flannel-io/flannel/releases/download/v0.28.10/kube-flannel.yml`. Do not edit it. Wait until both nodes are `Ready`.
2. Create the ConfigMap `cni-evidence` in the namespace `default` with these keys: `conf-file-name`, the file name that the init container `install-cni` writes into the CNI configuration directory; `backend-type`, the value of `Backend.Type` in the key `net-conf.json` of the ConfigMap `kube-flannel-cfg`; `ready-nodes`, the number of nodes whose `Ready` condition is `True`.
3. Create a pod named `probe-a` in the namespace `default` that runs the image `ghcr.io/stefanprodan/podinfo:6.15.0`. Wait until it is `Ready`.

The grader reads live values and compares them with your ConfigMap. It also checks that flannel runs with its original image, that all nodes are `Ready`, and that `probe-a` has an address in `10.244.0.0/16`.
