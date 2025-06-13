#!/usr/bin/env bash
set -eou pipefail

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
KIND_CONFIG=$(realpath "${SCRIPTPATH}/kind-config.yaml")

if ! command -v kind > /dev/null 2>&1; then
    echo "Command 'kind' not found"
    exit 0
fi

if [ -z "${1+x}" ]; then
    echo "Usage: $0 <cluster-type: local|dev|stg|prd>"
    exit 0
else
    if [[ ! ${1} =~ ^(local|dev|prod|uat)$ ]]; then
        echo "Invalid cluster type: ${1}"
        exit 0
    fi
fi

# Create the cluster
kind create cluster --config ${KIND_CONFIG} --name ${1}

# Set the cluster context so that we can talk to it
kubectl cluster-info --context kind-${1}

# Update cluster with manifests/specs
bash -l ${SCRIPTPATH}/update_cluster.sh ${1}

# Port-forward service so we can visit it in a browser
#kubectl port-forward service/pfo-web 8000:80 --context kind-${1} &

# We need to set the context for kubectl to talk to the cluster
kubectl config set-context --current --namespace=${1}
