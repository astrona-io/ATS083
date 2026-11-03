#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
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
kubectl -n outpost delete pod ferry --wait=true
kubectl -n starfleet delete pod cutter --wait=true
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
