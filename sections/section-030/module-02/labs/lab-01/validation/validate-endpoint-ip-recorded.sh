#!/usr/bin/env bash
# The report holds the live pod address behind the Service
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
live="$(kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o jsonpath='{.items[0].endpoints[0].addresses[0]}' 2>/dev/null)"
expect_equal "endpoint-ip" "$(evidence endpoint-ip)" "$live"
pass "endpoint-ip matches the EndpointSlice"
