---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Multi-interface Capstone

Solve this question on: `terminal`

A cluster uses flannel as its default network and has Multus installed. One pod already asks for a second interface and cannot start. A second network and a second pod are still missing.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-050-cap)"
```

1. The Pod `relay` in `starfleet` stays in `ContainerCreating`. It must use the existing NetworkAttachmentDefinition in `starfleet`. Repair it so that it runs and has `net1` with an address from `192.168.80.0/24`.
2. In the namespace `outpost`, create a NetworkAttachmentDefinition named `backend-net`. It must use the `bridge` plugin with the `host-local` range `192.168.90.0/24`. Choose any bridge name.
3. In the namespace `outpost`, create the Pod `gateway` with the image `curlimages/curl:8.22.0` and the command `sh -c "while true; do sleep 30; done"`. It must use `backend-net` and the extra interface must be named `back0`.
4. The pod `shuttle` must still reach the Service `probe` over the default network.

You may delete and create `relay` again. Do not change flannel, Multus or the files on the nodes.
