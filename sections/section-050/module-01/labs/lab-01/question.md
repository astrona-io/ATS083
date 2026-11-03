---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Attach A Second Interface To A Pod

Solve this question on: `terminal`

A cluster uses flannel as its default network and has Multus installed. The platform team wants a pod with a second interface on a separate network. The network does not exist yet.

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-050-01-01)"
```

1. In the namespace `starfleet`, create a NetworkAttachmentDefinition named `side-net`. It must use the `bridge` plugin with a bridge named `side0` and the `host-local` IPAM plugin with the range `192.168.50.0/24`.
2. In the namespace `starfleet`, create the Pod `tender` with the image `curlimages/curl:8.22.0` and the command `sh -c "while true; do sleep 30; done"`. Attach it to `side-net` with the networks annotation.
3. Wait until `tender` is Running.

The grader reads the live definition and runs `ip` inside the pod. Do not change any other object.
