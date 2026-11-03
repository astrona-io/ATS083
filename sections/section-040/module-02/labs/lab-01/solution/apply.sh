#!/usr/bin/env bash
# Reference solution. Run only by `astrona test`.
set -euo pipefail
kubectl -n starfleet patch service probe --type merge -p '{"spec":{"selector":{"app":"probe"},"ports":[{"port":9898,"targetPort":9898}]}}'
