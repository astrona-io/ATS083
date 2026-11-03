#!/usr/bin/env bash
# The report holds the live pod CIDR of each node
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
EVIDENCE_NAME=ipam-report
cp="$(kubectl get nodes -l 'node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}' 2>/dev/null)"
wk="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}' 2>/dev/null)"
expect_equal "control-plane-cidr" "$(evidence control-plane-cidr)" "$cp"
expect_equal "worker-cidr" "$(evidence worker-cidr)" "$wk"
pass "both node ranges match the live nodes"
