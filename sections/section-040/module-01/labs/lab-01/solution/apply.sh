#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
corefile="$(kubectl -n kube-system get configmap coredns -o jsonpath='{.data.Corefile}')"
fixed="$(printf '%s\n' "$corefile" | sed 's/kubernetes clusterx\.local/kubernetes cluster.local/')"
kubectl -n kube-system create configmap coredns --from-literal=Corefile="$fixed" --dry-run=client -o yaml | kubectl apply -f -
kubectl -n kube-system rollout restart deployment/coredns
kubectl -n kube-system rollout status deployment/coredns --timeout=180s
