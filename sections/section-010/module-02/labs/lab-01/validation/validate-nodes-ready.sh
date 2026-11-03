#!/usr/bin/env bash
# Both nodes report the Ready condition
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
statuses="$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.conditions[?(@.type=="Ready")].status}{"\n"}{end}' 2>/dev/null)"
total="$(printf '%s\n' "$statuses" | grep -c .)"
ready="$(printf '%s\n' "$statuses" | grep -c '^True$')"
[ "$total" -ge 2 ] || fail "expected at least two nodes but found $total"
[ "$ready" = "$total" ] || fail "$ready of $total nodes are Ready"
pass "all $total nodes are Ready"
