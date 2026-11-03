#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
corefile="$(kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}')"
fixed="$(printf '%s\n' "$corefile" | sed 's/kubernetes clusterx\.local/kubernetes cluster.local/')"
kubectl -n kube-system create configmap coredns --from-literal=Corefile="$fixed" --dry-run=client -o yaml | kubectl apply -f -
kubectl -n kube-system rollout restart deployment/coredns
kubectl -n kube-system rollout status deployment/coredns --timeout=180s
kubectl -n starfleet patch service probe --type merge -p '{"spec":{"selector":{"app":"probe"}}}'
kubectl -n starfleet delete pod shuttle --wait=true
kubectl apply -f - <<'POD'
apiVersion: v1
kind: Pod
metadata:
  name: shuttle
  namespace: starfleet
  labels:
    app: shuttle
spec:
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
POD
kubectl -n starfleet wait --for=condition=Ready pod/shuttle --timeout=120s
