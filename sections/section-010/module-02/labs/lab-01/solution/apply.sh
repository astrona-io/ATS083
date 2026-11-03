#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl apply -f https://github.com/flannel-io/flannel/releases/download/v0.28.10/kube-flannel.yml
kubectl -n kube-flannel rollout status daemonset/kube-flannel-ds --timeout=300s
kubectl wait --for=condition=Ready nodes --all --timeout=180s
kubectl -n kube-system rollout status deployment/coredns --timeout=300s
kubectl -n default run check-a --image=curlimages/curl:8.22.0 --restart=Never --command -- sleep 3600
kubectl -n default wait --for=condition=Ready pod/check-a --timeout=120s
