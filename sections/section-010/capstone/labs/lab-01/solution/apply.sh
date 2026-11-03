#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl apply -f https://github.com/flannel-io/flannel/releases/download/v0.28.10/kube-flannel.yml
kubectl -n kube-flannel rollout status daemonset/kube-flannel-ds --timeout=300s
kubectl wait --for=condition=Ready nodes --all --timeout=180s
kubectl -n kube-system rollout status deployment/coredns --timeout=300s
conf_file="$(kubectl -n kube-flannel get daemonset kube-flannel-ds -o jsonpath='{.spec.template.spec.initContainers[?(@.name=="install-cni")].args[2]}')"
conf_file="${conf_file##*/}"
backend_type="$(kubectl -n kube-flannel get configmap kube-flannel-cfg -o jsonpath='{.data.net-conf\.json}' | grep '"Type"' | sed 's/.*"Type": *"\([^"]*\)".*/\1/')"
ready_nodes="$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.conditions[?(@.type=="Ready")].status}{"\n"}{end}' | grep -c '^True$')"
kubectl -n default create configmap cni-evidence --from-literal=conf-file-name="$conf_file" --from-literal=backend-type="$backend_type" --from-literal=ready-nodes="$ready_nodes" --dry-run=client -o yaml | kubectl apply -f -
kubectl -n default run probe-a --image=ghcr.io/stefanprodan/podinfo:6.15.0 --restart=Never
kubectl -n default wait --for=condition=Ready pod/probe-a --timeout=120s
