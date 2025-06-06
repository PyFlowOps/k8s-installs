#!/usr/bin/env bash
# Copyright (c) 2025, PyFlowOps

set -eou pipefail

echo "The service(s) for Prometheus and Grafana are detailed below..."
echo ""

kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext
sleep 3

kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext
sleep 3

minikube service prometheus-server-ext grafana-ext --url
sleep 3
