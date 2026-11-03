#!/usr/bin/env bash
# The pod relay in starfleet runs and has net1 inside 192.168.80.0/24
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
phase="$(kubectl -n starfleet get pod relay -o jsonpath='{.status.phase}' 2>/dev/null)"
[ "$phase" = "Running" ] || fail "relay is not Running in starfleet"
net1="$(kubectl -n starfleet exec relay -- ip -4 -o addr show dev net1 2>/dev/null)"
case "$net1" in *" 192.168.80."*) ;; *) fail "net1 of relay has no address in 192.168.80.0/24";; esac
pass "relay runs with net1 in 192.168.80.0/24"
