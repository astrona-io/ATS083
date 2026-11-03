#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl apply -f - <<'YAML'
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  name: side-net
  namespace: starfleet
spec:
  config: '{"cniVersion": "1.0.0", "type": "bridge", "bridge": "side0", "ipam": {"type": "host-local", "subnet": "192.168.50.0/24"}}'
---
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
