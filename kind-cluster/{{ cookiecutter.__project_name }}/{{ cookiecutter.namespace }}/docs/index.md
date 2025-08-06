# Manual Installation

Here are the steps to manually create the kind cluster, with the needed parameters:

This assumes that all of the required files are in the required location --> ~/.pfo/k8s

## Step 1: Create the Cluster

```bash
cd ~/.pfo/k8s || true && kind create cluster --config kind-config.yaml --name pyops
```

## Step 2: Install MetalLB

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml
```

### Step 2.1: Configure MetalLB

```bash
cd ~/.pfo/k8s/pyops/overlays/metallb || true && kustomize build . | kubectl apply -f -
```

## Step 3: Install Traefik

```bash
cd ~/.pfo/k8s/pyops/overlays/traefik || true \
    && helm install traefik traefik/traefik \
    --namespace traefik \
    --create-namespace \
    -f traefik-values.yaml
```

### Step 3.1: Install Traefik CRD's

```bash
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v2.11/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
```

## Step 4: Install ArgoCD

Follow the below steps to create the ArgoCD namespace, install ArgoCD prerequisites, and all subsequent manifests for configuration.

### Step 4.1: Create Namespace
```bash
kubectl create namespace argocd
```

### Step 4.2: Install ArgoCD
```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.10.3/manifests/install.yaml
```

### Step 4.3: Install ArgoCD Image Updater

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml
```

### Step 4.4: Configure ArgoCD

```bash
cd ~/.pfo/k8s/pyops/overlays/argocd || true \
    && kustomize build . | kubectl apply -f -
```
