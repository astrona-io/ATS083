---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Summary

A pod with a failed attachment stays in `ContainerCreating` and shows `FailedCreatePodSandBox` events. The default network runs first, then Multus reads the annotation, finds each definition, parses `spec.config`, runs the plugin named by `type` and asks the IPAM plugin for an address. A fault in any step fails the whole call, and only pods with the annotation are affected.

## What you learned

Read the events of the pod first. Then check the causes in order: the definition exists in the namespace of the pod, the name in the annotation is exact, the JSON is valid and names a real plugin, the plugin binary is on the node, and the range is correct and large enough.

Repair the definition when it is wrong, or the pod when its annotation is wrong. The annotation is read when the sandbox is created, so the reliable repair is to delete the pod and create it again. A repair is finished when the pod runs, the extra interface has an address from its range, the status annotation lists both networks and the default network still works.

- Pods without the annotation are not affected by an attachment fault.
- A definition is looked up in the namespace of the pod unless `namespace/name` is used.
- A wrong `type` names a plugin that is missing in `/opt/cni/bin`.
- Do not edit the node files or flannel to fix an attachment.
- Check `ip -4 addr` in the pod, not only the pod status.

<!-- astrona:playground:destroy -->
