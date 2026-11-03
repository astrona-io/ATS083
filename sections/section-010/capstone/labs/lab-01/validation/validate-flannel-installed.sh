#!/usr/bin/env bash
# flannel runs on every node with the pinned image and the nodes are Ready
set -uo pipefail
fail() { echo "FAIL: $*"; exit 1; }
pass() { echo "PASS: $*"; exit 0; }
http_code() { kubectl -n "$1" exec "$2" -- curl -s -m 5 -o /dev/null -w '%{http_code}' "$3" 2>/dev/null || true; }
evidence() { kubectl -n "${EVIDENCE_NAMESPACE:-starfleet}" get configmap "${EVIDENCE_NAME:-cni-evidence}" -o "jsonpath={.data['$1']}" 2>/dev/null; }
expect_equal() { [ -n "$3" ] || fail "$1: could not read the live value"; [ "$2" = "$3" ] || fail "$1: expected '$3' but found '$2'"; }
desired="$(kubectl -n kube-flannel get daemonset kube-flannel-ds -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null)"
ready="$(kubectl -n kube-flannel get daemonset kube-flannel-ds -o jsonpath='{.status.numberReady}' 2>/dev/null)"
image="$(kubectl -n kube-flannel get daemonset kube-flannel-ds -o jsonpath='{.spec.template.spec.containers[?(@.name=="kube-flannel")].image}' 2>/dev/null)"
[ -n "$desired" ] && [ "$desired" -ge 2 ] || fail "the DaemonSet kube-flannel-ds does not cover both nodes"
[ "$ready" = "$desired" ] || fail "$ready of $desired flannel pods are ready"
[ "$image" = "ghcr.io/flannel-io/flannel:v0.28.10" ] || fail "unexpected flannel image '$image'"
statuses="$(kubectl get nodes -o jsonpath='{range .items[*]}{.status.conditions[?(@.type=="Ready")].status}{"\n"}{end}' 2>/dev/null)"
[ "$(printf '%s\n' "$statuses" | grep -c '^True$')" = "$(printf '%s\n' "$statuses" | grep -c .)" ] || fail "not every node is Ready"
pass "flannel runs and the nodes are Ready"
