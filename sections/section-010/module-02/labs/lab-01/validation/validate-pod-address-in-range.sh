#!/usr/bin/env bash
# The pod check-a in default runs and has an address from the pod network
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
phase="$(kubectl -n default get pod check-a -o jsonpath='{.status.phase}' 2>/dev/null)"
ip="$(kubectl -n default get pod check-a -o jsonpath='{.status.podIP}' 2>/dev/null)"
image="$(kubectl -n default get pod check-a -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)"
[ "$phase" = "Running" ] || fail "pod check-a is in phase '${phase:-missing}'"
[ "$image" = "curlimages/curl:8.22.0" ] || fail "unexpected image '$image'"
case "$ip" in 10.244.*) pass "check-a has the address $ip" ;; *) fail "address '$ip' is not in 10.244.0.0/16" ;; esac
