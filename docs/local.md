# Kubernetes local development

This section provides a method for developing workloads in a Kubernetes cluster similar
to how they would be deployed and running within a production Kubernetes cluster.

## Prerequisites

- `brew install kind` ([other install options](https://kind.sigs.k8s.io/docs/user/quick-start/))
- `brew install kustomize`
- Docker

## Usage

1. Setup a local Kubernetes development environment
    ```bash
    sh create_cluster.sh local
    ```
    
    or

    ```bash
    make kubernetes-unitytree-core-dev-create-cluster
    ```

    - This will:
        1. Create a new Kubernetes cluster in `kind`
        1. Build the project using `docker`, creating multiple images
        1. Deploy the project to the Kubernetes cluster using the built images

1. After making any changes to the repository, test your latest changes with
    ```bash
    sh update_local_cluster.sh local
    ```

    or

    ```bash
    make kubernetes-unitytree-core-dev-update-cluster
    ```

    - This will rebuild the workloads in with `docker` and deploy again to Kubernetes

1. Execute a port-forward to access the UI from a browser
    ```sh
    kubectl port-forward service/unitytree-core 8080:8080
    ```
