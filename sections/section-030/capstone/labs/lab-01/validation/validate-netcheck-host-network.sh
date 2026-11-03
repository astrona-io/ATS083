#!/usr/bin/env bash
# The pod netcheck uses the host network and has the address of its node
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
phase="$(kubectl -n outpost get pod netcheck -o jsonpath='{.status.phase}' 2>/dev/null)"
[ "$phase" = "Running" ] || fail "netcheck is not Running in outpost"
hostnet="$(kubectl -n outpost get pod netcheck -o jsonpath='{.spec.hostNetwork}')"
[ "$hostnet" = "true" ] || fail "netcheck does not use hostNetwork"
node="$(kubectl -n outpost get pod netcheck -o jsonpath='{.spec.nodeName}')"
node_ip="$(kubectl get node "$node" -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')"
pod_ip="$(kubectl -n outpost get pod netcheck -o jsonpath='{.status.podIP}')"
[ -n "$node_ip" ] && [ "$pod_ip" = "$node_ip" ] || fail "netcheck address '$pod_ip' is not the node address '$node_ip'"
pass "netcheck uses the address $pod_ip of node $node"
