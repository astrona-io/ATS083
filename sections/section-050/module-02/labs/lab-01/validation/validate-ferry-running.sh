#!/usr/bin/env bash
# The pod ferry in outpost runs and has net1 inside 192.168.60.0/24
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
phase="$(kubectl -n outpost get pod ferry -o jsonpath='{.status.phase}' 2>/dev/null)"
[ "$phase" = "Running" ] || fail "ferry is not Running in outpost"
net1="$(kubectl -n outpost exec ferry -- ip -4 -o addr show dev net1 2>/dev/null)"
case "$net1" in *" 192.168.60."*) ;; *) fail "net1 of ferry has no address in 192.168.60.0/24";; esac
pass "ferry runs with net1 in 192.168.60.0/24"
