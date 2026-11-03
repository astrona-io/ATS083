---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Attach A Second Interface To A Pod: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-050-01-01)"
```

## Step 1: Check that Multus is installed

```sh
kubectl get crd network-attachment-definitions.k8s.cni.cncf.io
kubectl -n kube-system get daemonset kube-multus-ds
```

## Step 2: Create the definition

The CNI configuration is a JSON string in `spec.config`.

```sh
kubectl apply -f - <<'YAML'
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: side-net
  namespace: starfleet
spec:
  config: '{"cniVersion": "1.0.0", "type": "bridge", "bridge": "side0", "ipam": {"type": "host-local", "subnet": "192.168.50.0/24"}}'
YAML
```

## Step 3: Create the pod

The annotation names the definition. It is read when the pod starts.

```sh
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: tender
  namespace: starfleet
  annotations:
    k8s.v1.cni.cncf.io/networks: side-net
spec:
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
YAML
kubectl -n starfleet wait --for=condition=Ready pod/tender --timeout=180s
```

## Step 4: Check the interfaces

```sh
kubectl -n starfleet exec tender -- ip -4 addr
```

Find `eth0` with an address from `10.244.0.0/16` and `net1` with an address from `192.168.50.0/24`.

Submit with `astrona submit -c sections/section-050/module-01/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-050-01-01`.

## Common pitfalls

> [!WARNING]
> If you create the pod before the definition exists, the pod stays in `ContainerCreating`. Create the definition first, or delete the pod and create it again. A mistake in the JSON string, such as a missing quote, also keeps the pod from starting, so read the events with `kubectl -n starfleet describe pod tender` if it does not become Ready.
