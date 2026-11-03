#!/usr/bin/env bash
# The pod latecomer runs on the worker node with an address inside its range
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
worker="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)"
cidr="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}' 2>/dev/null)"
[ -n "$worker" ] && [ -n "$cidr" ] || fail "could not read the worker node"
phase="$(kubectl -n outpost get pod latecomer -o jsonpath='{.status.phase}' 2>/dev/null)"
[ "$phase" = "Running" ] || fail "latecomer is not Running in outpost"
node="$(kubectl -n outpost get pod latecomer -o jsonpath='{.spec.nodeName}')"
[ "$node" = "$worker" ] || fail "latecomer runs on '$node', not on '$worker'"
ip="$(kubectl -n outpost get pod latecomer -o jsonpath='{.status.podIP}')"
prefix="${cidr%.*}."
case "$ip" in "$prefix"*) ;; *) fail "latecomer address '$ip' is outside '$cidr'";; esac
pass "latecomer runs on the worker with address $ip"
