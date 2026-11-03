#!/usr/bin/env bash
# The report holds the backend type from the flannel network configuration
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
EVIDENCE_NAMESPACE=default
live="$(kubectl -n kube-flannel get configmap kube-flannel-cfg -o jsonpath='{.data.net-conf\.json}' 2>/dev/null | grep '"Type"' | sed 's/.*"Type": *"\([^"]*\)".*/\1/')"
expect_equal "backend-type" "$(evidence backend-type)" "$live"
pass "backend-type matches the live ConfigMap"
