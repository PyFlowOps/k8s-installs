# kubernetes-prometheus-grafana

The code to get a Kubernetes Prometheus/Grafana/Loki system running...

- [Prometheus](https://prometheus.io/)
- [Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/)
- [Loki](https://grafana.com/docs/loki/latest/)

## IMPORTANT

All commands are run from the context of the `kubernetes-prometheus-grafana-loki` directory.

`${REPO_ROOT}/poc/kubernetes-prometheus-grafana-loki`

## Install Kubernetes Cluster

The purpose of this repo is to build a Prometheus/Grafana Kubernetes instance for POC purposes and testing.
This POC utilizes Helm, Kubernetes and Minikube. Please ensure that the prerequisites are installed:

```bash
make pre-install
```

To install the server instances, run the following:

```bash
make install
```

## Remove Kubernetes Cluster

Simply run the command:

```bash
make delete
```

_NOTE_: Sometimes, the Grafana password changes and locating the default admin password can be 
difficult. There is a script provided that will engage the Kubernetes pod and reset
the admin password. 

```bash
bash scripts/password_change.sh
```

There is also a small BASH script to retrieve the current admin password for Grafana:

```bash
bash scripts/get_grafana_admin_password.sh
```

# Forward Port to Localhost

To access the external service, you will need to forward the port in the cluster to
your local machine:

```bash
kubectl port-forward svc/grafana 3000:80
```

You should then be able to access your Grafana instance, deployed in your Minikube
Kubernetes cluster at `http://localhost:3000`.
