# kubernetes-prometheus-grafana

The code to get a Kubernetes Prometheus/Grafana/Loki system running...

- [Prometheus](https://prometheus.io/){target="_blank"}
- [Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/){target="_blank"}
- [Loki](https://grafana.com/docs/loki/latest/){target="_blank"}

# Forward Port to Localhost

To access the external service, you will need to forward the port in the cluster to
your local machine:

```bash
kubectl port-forward svc/grafana 3000:80
```

You should then be able to access your Grafana instance, deployed in your Minikube
Kubernetes cluster at `http://localhost:3000`.
