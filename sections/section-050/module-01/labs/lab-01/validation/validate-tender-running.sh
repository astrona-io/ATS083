#!/usr/bin/env bash
# The pod tender in starfleet runs and names side-net in its networks annotation
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
phase="$(kubectl -n starfleet get pod tender -o jsonpath='{.status.phase}' 2>/dev/null)"
[ "$phase" = "Running" ] || fail "tender is not Running in starfleet"
ann="$(kubectl -n starfleet get pod tender -o jsonpath="{.metadata.annotations['k8s\.v1\.cni\.cncf\.io/networks']}" 2>/dev/null)"
case "$ann" in *side-net*) ;; *) fail "the networks annotation does not name side-net";; esac
pass "tender runs and asks for side-net"
