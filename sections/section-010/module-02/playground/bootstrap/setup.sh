#!/usr/bin/env bash
# Creates the starting state of this environment on the empty kind cluster.
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-083-playground-010-02" ]]; then
  printf 'Refusing to operate on another Kubernetes context\n' >&2
  exit 1
fi
bootstrap_directory="$(cd "$(dirname "$0")" && pwd)"
download_checked() {
  local url="$1" checksum="$2" target="$3"
  curl --fail --silent --show-error --location --max-time 120 "$url" -o "$target"
  python3 - "$target" "$checksum" <<'CHECKSUM'
import hashlib, sys
assert hashlib.sha256(open(sys.argv[1], 'rb').read()).hexdigest() == sys.argv[2], 'Checksum differs'
CHECKSUM
}
work_directory="$(mktemp -d)"
trap 'rm -rf "$work_directory"' EXIT
kubectl apply -f "$bootstrap_directory/manifests/cni-plugins.yaml"
kubectl -n kube-system rollout status daemonset/cni-plugins --timeout=300s
