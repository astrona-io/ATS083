#!/usr/bin/env bash
# The report holds the live pod CIDR of the node that runs shuttle
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
node="$(kubectl -n starfleet get pod shuttle -o jsonpath='{.spec.nodeName}' 2>/dev/null)"
live="$(kubectl get node "$node" -o jsonpath='{.spec.podCIDR}' 2>/dev/null)"
expect_equal "shuttle-node-cidr" "$(evidence shuttle-node-cidr)" "$live"
pass "shuttle-node-cidr matches the live node"
