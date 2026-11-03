#!/usr/bin/env bash
# The probe pods keep the label app=probe and are ready
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
label="$(kubectl -n starfleet get deployment probe -o jsonpath='{.spec.template.metadata.labels.app}' 2>/dev/null)"
ready="$(kubectl -n starfleet get deployment probe -o jsonpath='{.status.readyReplicas}' 2>/dev/null)"
[ "$label" = "probe" ] || fail "the Deployment label was changed to '$label'"
[ "${ready:-0}" -ge 1 ] || fail "no probe pod is ready"
pass "the Deployment is unchanged and ready"
