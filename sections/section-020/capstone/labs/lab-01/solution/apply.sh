#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
worker="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}')"
cp_cidr="$(kubectl get nodes -l 'node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}')"
wk_cidr="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}')"
kubectl apply -f - <<POD
apiVersion: v1
kind: Pod
metadata:
  name: latecomer
  namespace: outpost
spec:
  nodeSelector:
    kubernetes.io/hostname: $worker
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
POD
kubectl -n outpost wait --for=condition=Ready pod/latecomer --timeout=120s
node_ranges="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.spec.podCIDR}{"\n"}{end}')"
pods="$(kubectl get pods -A -o jsonpath='{range .items[*]}{.status.podIP}{"|"}{.spec.nodeName}{"|"}{.spec.hostNetwork}{"\n"}{end}')"
outside="$(printf '%s\n---\n%s\n' "$node_ranges" "$pods" | awk -F'|' '
  $0 == "---" { mode = 1; next }
  mode == 0 { split($0, f, " "); c = f[2]; sub(/\.[0-9]+\/[0-9]+$/, ".", c); prefix[f[1]] = c; next }
  $1 != "" && $3 != "true" { if (index($1, prefix[$2]) != 1) n++ }
  END { print n + 0 }')"
kubectl -n starfleet create configmap ipam-report --from-literal=control-plane-cidr="$cp_cidr" --from-literal=worker-cidr="$wk_cidr" --from-literal=pods-outside-ranges="$outside" --dry-run=client -o yaml | kubectl apply -f -
