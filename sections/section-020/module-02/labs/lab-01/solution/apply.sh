#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
shuttle_ip="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.status.podIP}')"
shuttle_node="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.nodeName}')"
shuttle_cidr="$(kubectl get node "$shuttle_node" -o jsonpath='{.spec.podCIDR}')"
worker_cidr="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}')"
prefix="${worker_cidr%.*}."
crew_on_worker="$(kubectl -n starfleet get pods -l app=crew -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}' | awk -v p="$prefix" 'index($1, p) == 1 { n++ } END { print n + 0 }')"
crew_total="$(kubectl -n starfleet get pods -l app=crew --no-headers | wc -l | tr -d ' ')"
kubectl -n starfleet create configmap cni-evidence --from-literal=shuttle-ip="$shuttle_ip" --from-literal=shuttle-node-cidr="$shuttle_cidr" --from-literal=crew-on-worker="$crew_on_worker" --from-literal=crew-total="$crew_total" --dry-run=client -o yaml | kubectl apply -f -
