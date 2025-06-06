#!/usr/bin/env bash
# Copyright (c) 2025, PyFlowOps

set -eou pipefail

GRAFANA_POD="$(kubectl get pods | grep grafana | awk '{print $1}')"

kubectl exec -it pod/${GRAFANA_POD} -- grafana-cli admin reset-admin-password admin
