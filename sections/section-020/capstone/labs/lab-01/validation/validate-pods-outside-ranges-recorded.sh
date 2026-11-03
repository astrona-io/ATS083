#!/usr/bin/env bash
# The report holds the live number of pods outside the range of their node
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
EVIDENCE_NAME=ipam-report
node_ranges="$(kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.spec.podCIDR}{"\n"}{end}' 2>/dev/null)"
[ -n "$node_ranges" ] || fail "could not read the nodes"
pods="$(kubectl get pods -A -o jsonpath='{range .items[*]}{.status.podIP}{"|"}{.spec.nodeName}{"|"}{.spec.hostNetwork}{"\n"}{end}' 2>/dev/null)"
live="$(printf '%s\n---\n%s\n' "$node_ranges" "$pods" | awk -F'|' '
  $0 == "---" { mode = 1; next }
  mode == 0 { split($0, f, " "); c = f[2]; sub(/\.[0-9]+\/[0-9]+$/, ".", c); prefix[f[1]] = c; next }
  $1 != "" && $3 != "true" { if (index($1, prefix[$2]) != 1) n++ }
  END { print n + 0 }')"
expect_equal "pods-outside-ranges" "$(evidence pods-outside-ranges)" "$live"
[ "$live" = "0" ] || fail "pods-outside-ranges: $live pods have an address outside the range of their node"
pass "no pod is outside the range of its node and the report says so"
