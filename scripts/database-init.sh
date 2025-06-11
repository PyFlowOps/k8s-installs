#!/usr/bin/env bash

set -euo pipefail

if [[ ! -z $(kubectl get jobs | grep db-init) ]]; then kubectl delete job pfo-db-init; fi
kubectl apply -f deploy/local/pfo/pfo-db-init.yaml
kubectl wait --for=condition=complete --timeout=60s -n local job/pfo-db-init
