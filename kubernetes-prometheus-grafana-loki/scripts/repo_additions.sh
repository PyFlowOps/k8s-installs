#!/usr/bin/env bash
# Copyright (c) 2025, PyFlowOps
set -eou pipefail

if [[ -z $(helm repo list | grep prometheus-community) ]]; then helm repo add prometheus-community https://prometheus-community.github.io/helm-charts; fi
if [[ -z $(helm repo list | grep grafana) ]]; then helm repo add grafana https://grafana.github.io/helm-charts; fi

helm repo update
