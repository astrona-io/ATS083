---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# How The Runtime Finds And Calls A CNI Plugin

Kubernetes does not connect pods to a network. The container runtime on each node does it, and the runtime delegates the work to a program called a CNI plugin. The Container Network Interface (CNI) is the specification that describes how the runtime finds that program, what it passes to it and what the program must return. This module explains the files and the calls, so that you can read a node and say which plugin runs, in which order and with which settings.

Keep one sentence in mind: **the runtime reads a configuration file to learn which plugin to run, and it runs the plugin binary once for every pod network change.** You will read the real configuration that flannel installs, and you will follow the fields the runtime sends to a plugin and the fields the plugin sends back.

The module has two parts. The first part covers where the configuration files and the plugin binaries live and how the runtime chooses between several files. The second part covers the operations the runtime calls, the environment variables and the result a plugin returns.

## Learning objectives

After this module you can:

- Name the directories `/etc/cni/net.d` and `/opt/cni/bin` and say what each holds.
- Explain the difference between a `.conf` file and a `.conflist` file.
- Explain how the runtime orders configuration files and how a chain of plugins passes a result along.
- Name the CNI operations `ADD`, `DEL`, `CHECK` and `VERSION`, and the environment variables of a call.
- Read the plugin chain, the network name and the installed file name of flannel from a live cluster.

## Before you start

You need Kubernetes basics: pods, DaemonSets, ConfigMaps, namespaces and the commands `kubectl get` and `kubectl describe`.

Your playground is a two-node kind cluster running Kubernetes 1.35. A cluster node is a machine that runs pods. The cluster has no default network plugin from kind. The playground installs the reference CNI plugins and flannel, and it creates the example workloads.

| Namespace | Object | What it is |
| --- | --- | --- |
| `kube-flannel` | DaemonSet `kube-flannel-ds` | The flannel pods, one per node |
| `kube-flannel` | ConfigMap `kube-flannel-cfg` | The CNI configuration and the network configuration of flannel |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `outpost` | Pod `drifter` | A client pod with `curl` in another namespace |

`kubectl` already points at the playground cluster. Launch the playground now and keep it running while you read the parts:

<!-- astrona:playground -->
