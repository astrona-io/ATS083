#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl apply -f - <<POD
apiVersion: v1
kind: Pod
metadata:
  name: netcheck
  namespace: outpost
spec:
  hostNetwork: true
  containers:
  - name: client
    image: curlimages/curl:8.22.0
    command: ["sh", "-c", "while true; do sleep 30; done"]
POD
kubectl -n outpost wait --for=condition=Ready pod/netcheck --timeout=120s
drifter_ip="$(kubectl -n outpost exec drifter -- ip -4 -o addr show dev eth0 | awk '{print $4}' | cut -d/ -f1)"
drifter_mtu="$(kubectl -n outpost exec drifter -- cat /sys/class/net/eth0/mtu | tr -d '\r')"
service_ip="$(kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}')"
endpoint_ip="$(kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o jsonpath='{.items[0].endpoints[0].addresses[0]}')"
kubectl -n starfleet create configmap packet-report --from-literal=drifter-ip="$drifter_ip" --from-literal=drifter-mtu="$drifter_mtu" --from-literal=probe-service-ip="$service_ip" --from-literal=probe-endpoint-ip="$endpoint_ip" --dry-run=client -o yaml | kubectl apply -f -
