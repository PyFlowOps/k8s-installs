#!/usr/bin/env bash
# Copyright (c) 2025, PyFlowOps

set -eou pipefail

PASS=$(kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
echo "Current Grafana admin password --> User: admin, Password: ${PASS}"
