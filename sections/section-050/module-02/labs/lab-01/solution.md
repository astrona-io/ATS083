---
draft: true
exam_objectives:
- Configuring Multi-interface Pods
---
# Repair A Pod With A Failed Attachment: Solution

Connect to the cluster first. A kubeconfig is the file that tells `kubectl` which cluster and credentials to use.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-083-lab-050-02-01)"
```

## Step 1: Read the events

```sh
kubectl -n outpost describe pod ferry
kubectl -n starfleet describe pod cutter
```

Both pods show `FailedCreatePodSandBox` events. The message of `ferry` names the definition `side-net`. The message of `cutter` points at the plugin that it could not run.

## Step 2: Find the faults

```sh
kubectl -n outpost get net-attach-def
kubectl -n starfleet get net-attach-def
kubectl -n starfleet get net-attach-def dock-net -o jsonpath='{.spec.config}'
```

The definition `side-net` exists only in `starfleet`, and `ferry` runs in `outpost`. The definition `dock-net` has the plugin type `bridg`, which is not a plugin.

## Step 3: Repair the definitions

Create `side-net` in `outpost` with the range that the lab expects, and correct `dock-net`.

```sh
kubectl apply -f - <<'YAML'
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: side-net
  namespace: outpost
spec:
  config: '{"cniVersion": "1.0.0", "type": "bridge", "bridge": "side0", "ipam": {"type": "host-local", "subnet": "192.168.60.0/24"}}'
---
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: dock-net
  namespace: starfleet
spec:
  config: '{"cniVersion": "1.0.0", "type": "bridge", "bridge": "dock0", "ipam": {"type": "host-local", "subnet": "192.168.70.0/24"}}'
YAML
```

## Step 4: Create the pods again

The kubelet may retry the old pods on its own after a pause. Creating them again is faster and reliable.

```sh
kubectl -n outpost delete pod ferry
kubectl -n starfleet delete pod cutter
kubectl apply -f - <<'YAML'
apiVersion: v1
kind: Pod
metadata:
  name: ferry
  namespace: outpost
  annotations:
    k8s.v1.cni.cncf.io/networks: side-net
spec:
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
---
apiVersion: v1
kind: Pod
metadata:
  name: cutter
  namespace: starfleet
  annotations:
    k8s.v1.cni.cncf.io/networks: dock-net
spec:
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
YAML
kubectl -n outpost wait --for=condition=Ready pod/ferry --timeout=180s
kubectl -n starfleet wait --for=condition=Ready pod/cutter --timeout=180s
```

## Step 5: Check

```sh
kubectl -n outpost exec ferry -- ip -4 addr
kubectl -n starfleet exec cutter -- ip -4 addr
```

Submit with `astrona submit -c sections/section-050/module-02/labs/lab-01`. When you finish, remove the environment with `astrona destroy ats-083-lab-050-02-01`.

## Common pitfalls

> [!WARNING]
> The range of `side-net` in `outpost` must be `192.168.60.0/24`, the same as the definition in `starfleet`, or the check of `ferry` fails. Do not edit the files of Multus or flannel on the nodes. If `ip` fails inside a pod that is not Ready, wait until the pod runs.
