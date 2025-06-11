#!/usr/bin/env bash

set -eou pipefail

if [[ -z ${1+x} ]]; then
    echo "Usage: $0 <cluster-name: --Example: dev>"
    exit 1
fi
# shellcheck disable=SC2034
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Remove the cluster
kind get clusters | xargs -t -n1 kind delete cluster --name
