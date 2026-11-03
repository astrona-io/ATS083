#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
cluster_cidr="$(kubectl -n kube-flannel get configmap kube-flannel-cfg -o 'jsonpath={.data.net-conf\.json}' | grep '"Network"' | sed -E 's/.*"Network": *"([^"]+)".*/\1/')"
node_count="$(kubectl get nodes --no-headers | wc -l | tr -d ' ')"
worker_cidr="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}')"
shuttle_node="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.nodeName}')"
kubectl -n starfleet create configmap cni-evidence --from-literal=cluster-cidr="$cluster_cidr" --from-literal=node-count="$node_count" --from-literal=worker-pod-cidr="$worker_cidr" --from-literal=shuttle-node="$shuttle_node" --dry-run=client -o yaml | kubectl apply -f -
