#!/usr/bin/env bash
# Copyright (c) 2025, PyFlowOps

set -eou pipefail

# This will start us a minikube cluster to install our Prometheus/Grafana services to
minikube start

helm install prometheus prometheus-community/prometheus
sleep 3

helm install grafana grafana/grafana
sleep 10
