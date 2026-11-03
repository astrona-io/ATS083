#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl -n starfleet delete pod relay --wait=true
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
  name: relay
  namespace: starfleet
  annotations:
    k8s.v1.cni.cncf.io/networks: uplink-net
spec:
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
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
