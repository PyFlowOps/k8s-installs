# kubernetes-prometheus-grafana

The code to get a Kubernetes Prometheus/Grafana/Loki system running...

- [Prometheus](https://prometheus.io/){target="_blank"}
- [Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/){target="_blank"}
- [Loki](https://grafana.com/docs/loki/latest/){target="_blank"}

# Accessing Prometheus/Grafana

When you create your cluster:

```bash
pfo k8s --create
```

The messaging will display the URLs of both Prometheus/Grafana -- If you do not have the information,
you can access information about cluster by running:

```bash
pfo k8s --info
```
