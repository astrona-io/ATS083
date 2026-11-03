#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
ip_addr="$(kubectl -n starfleet exec shuttle -- ip -4 -o addr show dev eth0 | awk '{print $4}' | cut -d/ -f1)"
mac="$(kubectl -n starfleet exec shuttle -- cat /sys/class/net/eth0/address | tr -d '\r')"
mtu="$(kubectl -n starfleet exec shuttle -- cat /sys/class/net/eth0/mtu | tr -d '\r')"
gateway="$(kubectl -n starfleet exec shuttle -- ip -4 route show default | awk '{print $3}' | head -n 1)"
kubectl -n starfleet create configmap cni-evidence --from-literal=shuttle-ip="$ip_addr" --from-literal=shuttle-mac="$mac" --from-literal=shuttle-mtu="$mtu" --from-literal=shuttle-gateway="$gateway" --dry-run=client -o yaml | kubectl apply -f -
