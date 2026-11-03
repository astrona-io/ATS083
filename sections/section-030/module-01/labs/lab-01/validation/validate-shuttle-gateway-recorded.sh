#!/usr/bin/env bash
# The report holds the live default gateway of the shuttle pod
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
live="$(kubectl -n starfleet exec shuttle -- ip -4 route show default 2>/dev/null | awk '{print $3}' | head -n 1)"
expect_equal "shuttle-gateway" "$(evidence shuttle-gateway)" "$live"
pass "shuttle-gateway matches the routing table of the pod"
