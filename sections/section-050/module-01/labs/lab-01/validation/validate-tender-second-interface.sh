#!/usr/bin/env bash
# The pod tender has net1 inside 192.168.50.0/24 and keeps eth0 in the pod network
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
net1="$(kubectl -n starfleet exec tender -- ip -4 -o addr show dev net1 2>/dev/null)"
case "$net1" in *" 192.168.50."*) ;; *) fail "net1 has no address in 192.168.50.0/24";; esac
eth0="$(kubectl -n starfleet exec tender -- ip -4 -o addr show dev eth0 2>/dev/null)"
case "$eth0" in *" 10.244."*) ;; *) fail "eth0 has no address in 10.244.0.0/16";; esac
pass "tender has eth0 in the pod network and net1 in 192.168.50.0/24"
