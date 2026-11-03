---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Summary

Multus is a meta plugin. The container runtime calls Multus, and Multus calls other CNI plugins in order. The first delegate is the default network of the cluster, here flannel, which creates `eth0`. The next delegates are the additional networks that the pod names in the annotation `k8s.v1.cni.cncf.io/networks`, which create `net1`, `net2` and so on, or a name that the annotation chooses.

## What you learned

A NetworkAttachmentDefinition holds a CNI configuration as a JSON string in `spec.config`. The `type` field names the main plugin, which must exist in `/opt/cni/bin` on the node. The `ipam` block selects how addresses are given out. A definition belongs to a namespace, and a pod looks for it in its own namespace unless the annotation writes `namespace/name`.

The annotation exists in a text form and a JSON form. It is read only when the pod sandbox is created, so you must create the pod again to change its networks. After the pod starts, Multus writes the annotation `k8s.v1.cni.cncf.io/network-status` with the interfaces and addresses.

A bridge attachment connects only pods on the same node. Kubernetes Services and DNS do not use the additional interfaces, and the default route stays on `eth0`.

- Multus calls the default network first and the additional networks after it.
- `spec.config` is a JSON string inside a YAML object.
- The annotation takes `name`, `namespace/name` and `name@interface`.
- Changing the annotation of a running pod has no effect.
- Check a result with `ip addr` in the pod and the status annotation.

<!-- astrona:playground:destroy -->
