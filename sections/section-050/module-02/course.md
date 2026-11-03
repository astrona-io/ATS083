---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Troubleshooting Secondary Interfaces

An attachment is more fragile than the default network. It depends on one more object, one more plugin binary and one more annotation, and a fault in any of them stops the pod from starting. This module shows how to find out which part is wrong and how to repair it.

The module has two parts. The first part explains the failure points of the call path and how to read the pod events. The second part covers the repair of each fault and how to check that the pod got the interfaces that it asked for.

## Learning objectives

After this module you can:

- Recognise a pod that waits for a failed attachment.
- Read the events of a pod to find the failing step.
- Name the common causes: a missing definition, a wrong namespace, a wrong plugin type, invalid JSON and an exhausted range.
- Repair the definition or the pod and create the pod again.
- Check that the default network still works after the repair.

## Before you start

You need to know how Multus calls delegates and how a NetworkAttachmentDefinition and the networks annotation work.

Your playground is a two-node kind cluster running Kubernetes 1.35 with flannel v0.28.10 and Multus v4.3.1. Two pods in it cannot start because their attachments are broken.

| Namespace | Object | What it is |
| --- | --- | --- |
| `starfleet` | Deployment `probe` and Service `probe` | A small HTTP server on port 9898 |
| `starfleet` | Pod `shuttle` | A client pod with `curl` |
| `starfleet` | NetworkAttachmentDefinition `side-net` | A bridge network on 192.168.60.0/24 |
| `starfleet` | NetworkAttachmentDefinition `dock-net` | A network with a wrong plugin type |
| `starfleet` | Pod `cutter` | Uses `dock-net`, cannot start |
| `outpost` | Pod `ferry` | Uses `side-net`, cannot start |
| `outpost` | Pod `drifter` | A client pod with `curl` |

`kubectl` already points at the playground cluster. Launch the playground now and keep it running while you read the parts:

<!-- astrona:playground -->
