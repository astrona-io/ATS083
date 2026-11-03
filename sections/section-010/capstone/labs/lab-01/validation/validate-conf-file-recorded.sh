#!/usr/bin/env bash
# The report names the file that flannel writes into the CNI configuration directory
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
EVIDENCE_NAMESPACE=default
live="$(kubectl -n kube-flannel get daemonset kube-flannel-ds -o jsonpath='{.spec.template.spec.initContainers[?(@.name=="install-cni")].args[2]}' 2>/dev/null)"
live="${live##*/}"
expect_equal "conf-file-name" "$(evidence conf-file-name)" "$live"
pass "conf-file-name matches the live DaemonSet"
