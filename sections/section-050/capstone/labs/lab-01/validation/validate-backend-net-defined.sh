#!/usr/bin/env bash
# The NetworkAttachmentDefinition backend-net in outpost describes a bridge network with the range 192.168.90.0/24
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
config="$(kubectl -n outpost get network-attachment-definitions backend-net -o jsonpath='{.spec.config}' 2>/dev/null)"
[ -n "$config" ] || fail "NetworkAttachmentDefinition backend-net not found in outpost"
printf '%s' "$config" | grep -Eq '"type": *"bridge"' || fail "the main plugin type is not bridge"
printf '%s' "$config" | grep -q '192.168.90.0/24' || fail "the subnet 192.168.90.0/24 is not in the configuration"
pass "backend-net describes a bridge network on 192.168.90.0/24"
