#!/usr/bin/env bash
# The pod probe-a in default is Ready and has an address from the pod network
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
ready="$(kubectl -n default get pod probe-a -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null)"
ip="$(kubectl -n default get pod probe-a -o jsonpath='{.status.podIP}' 2>/dev/null)"
image="$(kubectl -n default get pod probe-a -o jsonpath='{.spec.containers[0].image}' 2>/dev/null)"
[ "$ready" = "True" ] || fail "pod probe-a is not Ready"
[ "$image" = "ghcr.io/stefanprodan/podinfo:6.15.0" ] || fail "unexpected image '$image'"
case "$ip" in 10.244.*) pass "probe-a has the address $ip" ;; *) fail "address '$ip' is not in 10.244.0.0/16" ;; esac
