#!/usr/bin/env bash
# The NetworkAttachmentDefinition dock-net uses the bridge plugin
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
config="$(kubectl -n starfleet get network-attachment-definitions dock-net -o jsonpath='{.spec.config}' 2>/dev/null)"
[ -n "$config" ] || fail "NetworkAttachmentDefinition dock-net not found in starfleet"
printf '%s' "$config" | grep -Eq '"type": *"bridge"' || fail "dock-net does not use the bridge plugin"
pass "dock-net uses the bridge plugin"
