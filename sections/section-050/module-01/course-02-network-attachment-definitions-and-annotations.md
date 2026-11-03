---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Network Attachment Definitions And Annotations

An additional network is described by a NetworkAttachmentDefinition, and a pod chooses it with an annotation. This part shows both objects in detail, the annotation forms you can use and the status that Multus writes back after the pod starts.

## The NetworkAttachmentDefinition object

The Multus installation adds a custom resource definition named `network-attachment-definitions.k8s.cni.cncf.io`. The kind is `NetworkAttachmentDefinition`, the API version is `k8s.cni.cncf.io/v1`, and the short name is `net-attach-def`. The object is namespaced.

The object has one important field: `spec.config`. It is a string, and the string holds a CNI configuration in JSON. The object adds nothing else that Multus needs. This is the example from the playground:

```yaml
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: side-net
  namespace: starfleet
spec:
  config: '{"cniVersion": "1.0.0", "type": "bridge", "bridge": "side0", "ipam": {"type": "host-local", "subnet": "192.168.50.0/24"}}'
```

Read the JSON as a normal CNI configuration:

- `cniVersion` is the version of the CNI specification that the configuration follows.
- `type` is the name of the main plugin. It must match a binary in `/opt/cni/bin` on every node that can run the pod.
- `bridge` is the name of the Linux bridge that the `bridge` plugin creates or reuses on the node.
- `ipam` selects the IPAM plugin and its settings. Here `host-local` hands out addresses from `192.168.50.0/24`.

The JSON sits inside a YAML string, so the single quotes around it matter. A missing quote or a trailing comma makes the JSON invalid, and the pod cannot start.

## Where the plugin looks for the definition

A definition belongs to a namespace. When a pod names an attachment without a namespace, Multus looks for the object in the namespace of the pod. A pod in `outpost` that names `side-net` does not find the object in `starfleet`.

To use a definition from another namespace, write the namespace in front of the name, for example `starfleet/side-net`. Cluster administrators can switch off this cross-namespace use in the Multus configuration, so the form works only where the cluster allows it.

## The networks annotation

The annotation key is `k8s.v1.cni.cncf.io/networks`. It is read when the pod sandbox is created. There are two forms.

The text form is a comma-separated list. Each item is a definition name with two optional parts:

- `side-net` selects the definition `side-net` in the namespace of the pod.
- `starfleet/side-net` adds the namespace in front of the name.
- `side-net@storage0` adds `@` and the name of the interface inside the pod.
- Items are separated by commas, so `side-net,other-net` attaches two networks.

The JSON form is a list of objects:

```yaml
k8s.v1.cni.cncf.io/networks: '[{"name": "side-net", "namespace": "starfleet", "interface": "storage0"}]'
```

Each object has a `name`, and optional `namespace` and `interface` fields. The JSON form also has a `default-route` field, which asks Multus to send the default route over that attachment instead of `eth0`. Use that field only when you want to change the route of the pod on purpose.

Without a chosen interface name, Multus names the interfaces `net1`, `net2` and so on, in the order of the list. The name `eth0` belongs to the default network. Naming the interface makes scripts inside the pod easier to read.

## The status that Multus writes back

After the pod starts, Multus writes a second annotation on the pod: `k8s.v1.cni.cncf.io/network-status`. Its value is a JSON list with one entry for each network, including the default one. Each entry has the name of the network, the interface name in the pod and the list of addresses. The default network entry also has `"default": true`. The status helps you to check from outside the pod which network got which address.

## Try it on the playground

<!-- astrona:playground:renew -->

Read the definition and the annotation of the pod `tender`:

```sh
kubectl -n starfleet get net-attach-def side-net -o yaml
kubectl -n starfleet get pod tender -o jsonpath='{.metadata.annotations}'
```

Print the interfaces inside the pod. The `ip` command comes from the busybox tools in the image:

```sh
kubectl -n starfleet exec tender -- ip -4 addr
```

Find `eth0` with an address from `10.244.0.0/16` and `net1` with an address from `192.168.50.0/24`. Then read the status annotation:

```sh
kubectl -n starfleet get pod tender -o jsonpath="{.metadata.annotations['k8s\.v1\.cni\.cncf\.io/network-status']}"
```

Create your own definition and a pod. This example uses a second bridge named `lab0` and the range `192.168.55.0/24`:

```sh
kubectl apply -f - <<'YAML'
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: lab-net
  namespace: starfleet
spec:
  config: '{"cniVersion": "1.0.0", "type": "bridge", "bridge": "lab0", "ipam": {"type": "host-local", "subnet": "192.168.55.0/24"}}'
---
apiVersion: v1
kind: Pod
metadata:
  name: tender-two
  namespace: starfleet
  annotations:
    k8s.v1.cni.cncf.io/networks: lab-net@storage0
spec:
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
YAML
kubectl -n starfleet exec tender-two -- ip -4 addr show dev storage0
```

The interface is named `storage0` because the annotation asked for that name.

## A limit of host-local on extra networks

The `host-local` plugin keeps its state in files on each node. Two nodes that use the same range do not know about each other, so they can give the same address to two pods. This is harmless for a bridge that never leaves the node. If pods on different nodes must share one additional range, choose an IPAM plugin that stores its state in the cluster, or give each node its own range.

## Common pitfalls

> [!WARNING]
> The annotation is read only when the pod sandbox is created. Changing the annotation on a running pod does not add or remove an interface. Delete the pod and create it again. Also remember that the definition must exist before the pod is created in the namespace that the annotation selects.
