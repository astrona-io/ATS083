---
draft: true
exam_objectives:
- Installing and Configuring CNI Plugins
---
# Summary

A node reports `NotReady` when the container runtime finds no valid CNI configuration. The kubelet reads the network state from the runtime and puts it in the `Ready` condition of the node. The control plane then adds a taint, and the scheduler keeps ordinary pods away from the node.

## What you learned

Without a network plugin, only pods that use the network of the node still run. These are the static pods of the control plane and DaemonSets that set `hostNetwork: true` and tolerate the taints. CoreDNS and every normal pod stay `Pending`, because they have no toleration for the taint and need a pod network.

A network plugin installer is usually a DaemonSet. Flannel runs one pod on each node. Two init containers copy the `flannel` binary into `/opt/cni/bin` and the configuration into `/etc/cni/net.d/10-flannel.conflist`, and the main container runs `flanneld`. The runtime then finds the configuration, the node becomes `Ready`, and pods get addresses. Flannel takes the range of each node from `spec.podCIDR` of the Node object, writes it to `/run/flannel/subnet.env` and carries traffic between nodes in a VXLAN overlay. VXLAN wraps a pod packet in a UDP packet so that it crosses the node network.

Verification has three levels. The nodes must be `Ready`, a new pod must get an address from the pod network, and a pod on one node must reach a pod on another node. Each level checks a different part of the setup.

- The `NotReady` message names the missing CNI configuration.
- `hostNetwork` pods run without a pod network.
- One `kubectl apply` of a pinned manifest installs flannel.
- The pod network of flannel must match the pod subnet of the cluster.
- A cross-node request proves the overlay works.

<!-- astrona:playground:destroy -->
