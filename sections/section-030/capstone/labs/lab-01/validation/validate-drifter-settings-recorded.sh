#!/usr/bin/env bash
# The report holds the live address and MTU of eth0 in the drifter pod
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
EVIDENCE_NAME=packet-report
ip_live="$(kubectl -n outpost exec drifter -- ip -4 -o addr show dev eth0 2>/dev/null | awk '{print $4}' | cut -d/ -f1)"
mtu_live="$(kubectl -n outpost exec drifter -- cat /sys/class/net/eth0/mtu 2>/dev/null | tr -d '\r')"
expect_equal "drifter-ip" "$(evidence drifter-ip)" "$ip_live"
expect_equal "drifter-mtu" "$(evidence drifter-mtu)" "$mtu_live"
pass "drifter-ip and drifter-mtu match the live pod"
