#!/usr/bin/env bash
# The pod netcheck reaches the probe Service by its cluster IP
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
svc="$(kubectl -n starfleet get service probe -o jsonpath='{.spec.clusterIP}' 2>/dev/null)"
[ -n "$svc" ] || fail "could not read the Service probe"
code="$(http_code outpost netcheck "http://$svc:9898/healthz")"
[ "$code" = "200" ] || fail "netcheck got HTTP '$code' from $svc, expected 200"
pass "netcheck reaches probe through the cluster IP"
