#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
service_ip="$(kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}')"
endpoint_ip="$(kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o jsonpath='{.items[0].endpoints[0].addresses[0]}')"
probe_node="$(kubectl -n starfleet get pods -l app=probe -o jsonpath='{.items[0].spec.nodeName}')"
proxy_pods="$(kubectl -n kube-system get pods -l k8s-app=kube-proxy --no-headers | wc -l | tr -d ' ')"
kubectl -n starfleet create configmap cni-evidence --from-literal=service-ip="$service_ip" --from-literal=endpoint-ip="$endpoint_ip" --from-literal=probe-node="$probe_node" --from-literal=kube-proxy-pods="$proxy_pods" --dry-run=client -o yaml | kubectl apply -f -
