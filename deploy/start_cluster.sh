#!/usr/bin/env bash

set -eou pipefail

if [[ ! -z $(kubectl get pods | grep nginx | awk '{print $1}') ]]; then
    kubectl port-forward --address 0.0.0.0 service/nginx 80:80 -n ${1}
else
    kubectl port-forward service/pfo 8000:8000
fi
