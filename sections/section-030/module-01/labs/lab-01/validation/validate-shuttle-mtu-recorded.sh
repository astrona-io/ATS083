#!/usr/bin/env bash
# The report holds the live MTU of eth0 in the shuttle pod
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
live="$(kubectl -n starfleet exec shuttle -- cat /sys/class/net/eth0/mtu 2>/dev/null | tr -d '\r')"
expect_equal "shuttle-mtu" "$(evidence shuttle-mtu)" "$live"
pass "shuttle-mtu matches eth0 of the pod"
