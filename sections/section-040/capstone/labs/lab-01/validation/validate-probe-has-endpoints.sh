#!/usr/bin/env bash
# The Service probe selects the probe pods and has endpoints
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
sel="$(kubectl -n starfleet get service probe -o jsonpath='{.spec.selector.app}' 2>/dev/null)"
[ "$sel" = "probe" ] || fail "selector app is '$sel', not 'probe'"
addr="$(kubectl -n starfleet get endpointslices -l kubernetes.io/service-name=probe -o jsonpath='{.items[*].endpoints[*].addresses[*]}' 2>/dev/null)"
[ -n "$addr" ] || fail "the Service has no endpoint addresses"
pass "the Service has endpoints: $addr"
