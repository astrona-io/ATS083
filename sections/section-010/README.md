---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# Installing and Configuring CNI Plugins

This section explains how a Kubernetes node gets its pod network. It covers the files and programs the container runtime uses to call a Container Network Interface (CNI) plugin, the operations the plugin must implement, the reason a node stays `NotReady` until a plugin is present, and the steps that install and verify a network plugin on a cluster.

Each module has a landing page, two reading parts and a summary. The readings use a private playground for hands-on steps. Each module has one graded lab, and the section ends with a capstone lab and a knowledge check.

## Modules

**How The Runtime Finds And Calls A CNI Plugin**

- Name the two directories where a node keeps CNI configuration files and CNI plugin binaries.
- Explain how the runtime chooses a configuration file and how a plugin chain is built.
- List the CNI operations and the environment variables the runtime sets for each call.
- Read the configuration that flannel installs on every node.

**Installing A Network Plugin On A Cluster**

- Explain why a node reports `NotReady` when no CNI configuration exists.
- Say which pods still run on a node that has no network plugin.
- Install flannel from a pinned manifest and explain what each object in it does.
- Verify that the nodes are `Ready`, that pods receive addresses from the pod network and that pods on different nodes reach each other.

## Labs and quiz

The labs are marked UNTESTED: they passed static checks and have not been run. The capstone lab combines the skills of the section. The quiz has single-choice questions and a pass score of 70 percent.
