#!/usr/bin/env bash
# The pod shuttle runs with the default cluster DNS policy
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
phase="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.status.phase}' 2>/dev/null)"
[ "$phase" = "Running" ] || fail "shuttle is not Running"
policy="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.dnsPolicy}' 2>/dev/null)"
[ "$policy" = "ClusterFirst" ] || fail "dnsPolicy is '$policy', not ClusterFirst"
pass "shuttle uses dnsPolicy ClusterFirst"
