#!/usr/bin/env bash
# Creates the starting state of this environment on the empty kind cluster.
set -euo pipefail
if [[ "$(kubectl config current-context)" != "kind-astro-ats-083-playground-010-01" ]]; then
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
download_checked "https://github.com/flannel-io/flannel/releases/download/v0.28.10/kube-flannel.yml" "393bdbce53eb50c8eb97dd513b218518b7d6e7985dc7b889be956e112a711084" "$work_directory/kube-flannel.yml"
kubectl apply -f "$work_directory/kube-flannel.yml"
kubectl -n kube-flannel rollout status daemonset/kube-flannel-ds --timeout=300s
kubectl wait --for=condition=Ready nodes --all --timeout=180s
kubectl -n kube-system rollout status deployment/coredns --timeout=300s
kubectl apply -f "$bootstrap_directory/manifests/start.yaml"
kubectl -n starfleet rollout status deployment/probe --timeout=180s
kubectl -n starfleet wait --for=condition=Ready pod/shuttle --timeout=120s
kubectl -n outpost wait --for=condition=Ready pod/drifter --timeout=120s
