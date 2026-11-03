#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
conf_file="$(kubectl -n kube-flannel get daemonset kube-flannel-ds -o jsonpath='{.spec.template.spec.initContainers[?(@.name=="install-cni")].args[2]}')"
conf_file="${conf_file##*/}"
cni_conf="$(kubectl -n kube-flannel get configmap kube-flannel-cfg -o jsonpath='{.data.cni-conf\.json}')"
network_name="$(printf '%s\n' "$cni_conf" | grep -m1 '"name"' | sed 's/.*"name": *"\([^"]*\)".*/\1/')"
plugin_types="$(printf '%s\n' "$cni_conf" | grep '"type"' | sed 's/.*"type": *"\([^"]*\)".*/\1/' | paste -sd, -)"
kubectl -n starfleet create configmap cni-evidence --from-literal=conf-file-name="$conf_file" --from-literal=network-name="$network_name" --from-literal=plugin-types="$plugin_types" --dry-run=client -o yaml | kubectl apply -f -
