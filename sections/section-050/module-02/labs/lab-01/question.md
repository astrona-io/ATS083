---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Repair A Pod With A Failed Attachment

Solve this question on: `terminal`

A cluster uses flannel as its default network and has Multus installed. Two pods cannot start: the Pod `ferry` in the namespace `outpost` and the Pod `cutter` in the namespace `starfleet`. Both pods ask for a second interface. Find out why they stay in `ContainerCreating` and repair them.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-050-02-01)"
```

The result must be:

1. `ferry` runs in `outpost` and has the interface `net1` with an address from `192.168.60.0/24`.
2. The NetworkAttachmentDefinition `dock-net` in `starfleet` uses the `bridge` plugin.
3. `cutter` runs in `starfleet` and has the interface `net1` with an address from `192.168.70.0/24`.
4. The pod `shuttle` still reaches the Service `probe` over the default network.

You may delete and create the two pods again. Do not change flannel, Multus or the files on the nodes.
