#!/usr/bin/env bash
# The pod gateway in outpost runs with the interface back0 inside 192.168.90.0/24 and keeps eth0
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
phase="$(kubectl -n outpost get pod gateway -o jsonpath='{.status.phase}' 2>/dev/null)"
[ "$phase" = "Running" ] || fail "gateway is not Running in outpost"
back0="$(kubectl -n outpost exec gateway -- ip -4 -o addr show dev back0 2>/dev/null)"
case "$back0" in *" 192.168.90."*) ;; *) fail "back0 has no address in 192.168.90.0/24";; esac
eth0="$(kubectl -n outpost exec gateway -- ip -4 -o addr show dev eth0 2>/dev/null)"
case "$eth0" in *" 10.244."*) ;; *) fail "eth0 has no address in 10.244.0.0/16";; esac
pass "gateway has eth0 in the pod network and back0 in 192.168.90.0/24"
