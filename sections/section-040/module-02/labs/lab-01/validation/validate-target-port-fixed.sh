#!/usr/bin/env bash
# The Service probe forwards to port 9898
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
tp="$(kubectl -n starfleet get service probe -o jsonpath='{.spec.ports[0].targetPort}' 2>/dev/null)"
[ "$tp" = "9898" ] || fail "targetPort is '$tp', not 9898"
pass "targetPort is 9898"
