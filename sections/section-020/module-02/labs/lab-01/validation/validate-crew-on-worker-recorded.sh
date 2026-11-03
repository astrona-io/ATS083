#!/usr/bin/env bash
# The report holds the live number of crew pods inside the worker range
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
cidr="$(kubectl get nodes -l '!node-role.kubernetes.io/control-plane' -o jsonpath='{.items[0].spec.podCIDR}' 2>/dev/null)"
[ -n "$cidr" ] || fail "could not read the worker pod CIDR"
prefix="${cidr%.*}."
live="$(kubectl -n starfleet get pods -l app=crew -o jsonpath='{range .items[*]}{.status.podIP}{"\n"}{end}' 2>/dev/null | awk -v p="$prefix" 'index($1, p) == 1 { n++ } END { print n + 0 }')"
expect_equal "crew-on-worker" "$(evidence crew-on-worker)" "$live"
pass "crew-on-worker matches the live pods"
