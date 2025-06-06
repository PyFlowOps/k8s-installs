#!/usr/bin/env bash
# Copyright (c) 2025, PyFlowOps

set -eou pipefail

kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-ext

kubectl port-forward service/grafana-ext 3000:80 2>&1 &
kubectl port-forward service/prometheus-server-ext 9090:80 2>&1 &

echo "Please access your servers below:"
echo ""
echo ""
echo "Grafana ~> http://localhost:3000/"
echo "Prometheus ~> http://localhost:9090/"
echo ""
echo "Build complete!"
