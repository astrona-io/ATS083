---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Multi-interface Capstone: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-050-cap)"
```

## Step 1: Find the fault of relay

```sh
kubectl -n starfleet describe pod relay
kubectl -n starfleet get net-attach-def
kubectl -n starfleet get pod relay -o jsonpath="{.metadata.annotations['k8s\.v1\.cni\.cncf\.io/networks']}"
```

The annotation names `uplink`, but the definition is called `uplink-net`.

## Step 2: Create relay again with the right name

```sh
kubectl -n starfleet delete pod relay
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: relay
  namespace: starfleet
  annotations:
    k8s.v1.cni.cncf.io/networks: uplink-net
spec:
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
YAML
```

## Step 3: Create the new network and the gateway pod

The text `backend-net@back0` in the annotation names the definition and the interface.

```sh
kubectl apply -f - <<'YAML'
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: backend-net
  namespace: outpost
spec:
  config: '{"cniVersion": "1.0.0", "type": "bridge", "bridge": "back0br", "ipam": {"type": "host-local", "subnet": "192.168.90.0/24"}}'
---
apiVersion: v1
kind: Pod
metadata:
  name: gateway
  namespace: outpost
  annotations:
    k8s.v1.cni.cncf.io/networks: backend-net@back0
spec:
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
YAML
kubectl -n starfleet wait --for=condition=Ready pod/relay --timeout=180s
kubectl -n outpost wait --for=condition=Ready pod/gateway --timeout=180s
```

## Step 4: Check

```sh
kubectl -n starfleet exec relay -- ip -4 addr
kubectl -n outpost exec gateway -- ip -4 addr
kubectl -n starfleet exec shuttle -- curl -s -m 5 -o /dev/null -w '%{http_code}\n' http://probe:9898/healthz
```

Submit with `astrona submit -c sections/section-050/capstone/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-050-cap`.

## Common pitfalls

> [!WARNING]
> The interface name `back0` and the bridge name are different things. The bridge belongs to the node and is set in the definition, and the interface belongs to the pod and is set in the annotation. Do not give the bridge and the interface the same name by accident in a way that hides which one you changed.
