#!/usr/bin/env bash
set -eou pipefail

# PATH DATA
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BASE="${SCRIPTPATH}/.."

# Let's get a list of our repos in PyFlowOps org
pfo_repos=($(gh repo list PyFlowOps --json name -q '.[].name'))
echo "Repos in PyFlowOps org: ${pfo_repos[*]}"

[[ ! -d "/tmp/.pfo" ]] && mkdir -p /tmp/.pfo # Temp folder for cloning repos

# Examples of other repos we may want to pull
GITHUBORG=PyFlowOps
EPOCH_DATE=$(date +%s)

#PFO_UIUX=${BASE}/ui-ux
#PFO_DEVTOOLS=${BASE}/ut_devtools
#PFO_QA=${BASE}/qa

PFO_DOCS=$(realpath ${BASE}/pfo-docs)
PFO_DOCS_REPO="https://github.com/PyFlowOps/documentation.git"

### Image data ###
PFO_DOCS_LOCAL_IMAGE=pfo-docs:k8s-local
PFO_DOCS_LOCAL_VERSIONED_IMAGE=pfo-docs:k8s-local-${EPOCH_DATE}
PFO_DOCS_REPO="${GITHUB}/${GITHUBORG}/documentation.git"

#PFO_UIUX_LOCAL_IMAGE=pfo-uiux:k8s-local
#PFO_UIUX_LOCAL_VERSIONED_IMAGE=pfo-uiux:k8s-local-${EPOCH_DATE}

# Developer tools image
#PFO_DEVTOOLS_LOCAL_IMAGE=pfo-dev-tools:k8s-local

# PFO QA Image
#PFO_QA_LOCAL_IMAGE=pfo-qa:k8s-local

# RabbitMQ
#PFO_RABBITMQ_LOCAL_IMAGE=pfo-rabbitmq:k8s-local
#PFO_RABBITMQ_LOCAL_VERSIONS_IMAGE=pfo-rabbitmq:k8s-local-${EPOCH_DATE}

# shellcheck disable=SC2034
K8S_STATIC_FILES_IMAGE=kind

config_file() {
    # This function takes a variable as an argument and will add it to the .env file within the ~/.pfo folder.
    # The config file will be used to set the variable passed into the script
    # The config file will be sourced in the script, after all the variables have been set
    date=$(date '+%Y-%m-%d %H:%M:%S') # This will be used to add a timestamp to the config file comment
    if [[ -f "${HOME}/.pfo/.env" ]]; then
        # Let's add some values to the config file for sourcing
        if grep -q "${1}=" "${HOME}/.pfo/.env"; then
            echo "Updating variable ${1} in the config file..."
            sed -i '' "s/${1}=.*/${1}=${!1}/g" "${HOME}/.pfo/.env"
        else
            echo "Adding variable ${1} to the config file..."
            {
                printf '\n'
                printf '# Kubernetes Variable added from %s on %s' "${0}" "${date}"
                printf '\n'
                printf '%s=%s' "${1}" "${!1}"
                printf '\n'
            } >> "${HOME}/.pfo/.env"
        fi
    else
        # Create the config file
        echo "Creating config file"
        touch "${HOME}/.pfo/.env"
        {
            printf '##### PyFlowOps Kubernetes Config File #####'
            printf '\n'
            printf '# Kubernetes Variable added from %s on %s' "${0}" "${date}"
            printf '\n'
            printf '%s=%s' "${1}" "${!1}"
            printf '\n'
        } >> "${HOME}/.pfo/.env"
    fi
}

# Build config file/or add to existing config file
config_file PFO_DOCS_LOCAL_IMAGE
config_file PFO_DOCS_LOCAL_VERSIONED_IMAGE
#config_file K8S_UIUX_LOCAL_IMAGE
#config_file K8S_UIUX_LOCAL_VERSIONED_IMAGE
#config_file K8S_DEVTOOLS_LOCAL_IMAGE
#config_file K8S_QA_LOCAL_IMAGE
#config_file K8S_RABBITMQ_LOCAL_IMAGE
#config_file K8S_RABBITMQ_LOCAL_VERSIONS_IMAGE
config_file K8S_STATIC_FILES_IMAGE

repo_pulls() {
    ##### Clone Documentation repo #####
    echo "Rulling 'documentation' from Github.com"
    if [[ -d "${PFO_DOCS}" ]]; then
        echo "pfo-docs folder found...removing and pulling from Github.com"
        rm -rf "${PFO_DOCS}"
        git clone "${PFO_DOCS_REPO}" "${PFO_DOCS}" # Clone docs repo
    else
        echo "ui-ux folder not found...pulling from Github.com"
        git clone "${PFO_DOCS_REPO}" "${PFO_DOCS_REPO}" # Clone docs repo
    fi
}

##### LOCAL VERSIONED IMAGES #####
build() {
    ##### PFO Core #####
    cd ${BASE} || exit 1 && docker build -t "${PFO_DOCS_LOCAL_IMAGE}" -f "${PFO_DOCS}/Dockerfile" .
    if "${OPT_V}" '==' "true"; then
        docker tag "${PFO_DOCS_LOCAL_IMAGE}" "${PFO_DOCS_LOCAL_VERSIONED_IMAGE}" # Additional versioned tag
    fi

    # Examples of other repos we may want to pull
    ##### PFO UI-UX #####
    # cd ${BASE} || exit 1 && docker build -t ${K8S_UIUX_LOCAL_IMAGE} -f "${UNITYTREE_UIUX}/Dockerfile" .
    # if "${OPT_V}" '==' "true"; then
    #     docker tag "${K8S_UIUX_LOCAL_IMAGE}" "${K8S_UIUX_LOCAL_VERSIONED_IMAGE}" # Additional versioned tag
    # fi

    ##### PFO Developer Tools #####
    # cd ${BASE} || exit 1 && docker build -t ${K8S_DEVTOOLS_LOCAL_IMAGE} -f "${UNITYTREE_DEVTOOLS}/Dockerfile" "${UNITYTREE_DEVTOOLS}"

    ##### PFO QA Image #####
    # Context -- "${UNITYTREE_QA}"
    # cd ${BASE} || exit 1 && docker build -t ${K8S_QA_LOCAL_IMAGE} -f "${UNITYTREE_QA}/Dockerfile" .

}

kind_deploy() {
    if [ "${e}" '==' "local" ]; then
        BUILD_PATH="${SCRIPTPATH}/${e}"
    fi
    if [[ ${e} =~ ^prod|dev|uat$ ]]; then
        BUILD_PATH="${SCRIPTPATH}/base/overlays/${e}/manifests"
    fi

    echo "Deploying to ${e}"

    cd "${BUILD_PATH}" || exit 1 # We want to run KusoMize from the uat folder
    if "${OPT_V}" '==' "true"; then
        :
        #kustomize edit set image unitytree-core:k8s-local="${K8S_CORE_LOCAL_VERSIONED_IMAGE}"
        #kustomize edit set image unitytree-uiux:k8s-local="${K8S_UIUX_LOCAL_VERSIONED_IMAGE}"
        #kustomize edit set image unitytree-uiux:k8s-local="${K8S_DEVTOOLS_LOCAL_IMAGE}"
        #kustomize edit set image unitytree-qa:k8s-local="${K8S_QA_LOCAL_IMAGE}"
    else
        :
        #kustomize edit set image unitytree-core:k8s-local="${K8S_CORE_LOCAL_IMAGE}"
        #kustomize edit set image unitytree-uiux:k8s-local="${K8S_UIUX_LOCAL_IMAGE}"
        #kustomize edit set image unitytree-uiux:k8s-local="${K8S_DEVTOOLS_LOCAL_IMAGE}"
        #kustomize edit set image unitytree-qa:k8s-local="${K8S_QA_LOCAL_IMAGE}"
    fi

    kustomize build . | kubectl apply -f - # Apply the kustomize build to the cluster
    kubectl cluster-info --context kind-${e}
    #kind load docker-image "${K8S_CORE_LOCAL_IMAGE}" --name ${e} --nodes ${e}-worker,${e}-worker2,${e}-worker3 -v 10
    #kind load docker-image "${K8S_DEVTOOLS_LOCAL_IMAGE}" --name ${e} --nodes ${e}-worker,${e}-worker2,${e}-worker3 -v 10
    #kind load docker-image "${K8S_QA_LOCAL_IMAGE}" --name ${e} --nodes ${e}-worker,${e}-worker2,${e}-worker3 -v 10

    cd "${SCRIPTPATH}" || exit 1  # Return to the script folder
}

# Usage
usage() { echo "Usage: $0 [-e <dev|stg|prd|local>] [-v Build versioned kubernetes images] [-h help]" 1>&2; exit 1; }

# Use getopts to parse command line arguments
# https://stackoverflow.com/questions/16483119/an-example-of-how-to-use-getopts-in-bash
OPT_V='false'
PASSED_ARGS=$*

if [ -z ${1} ]; then
    if [[ ${#PASSED_ARGS} -ne 0 ]]; then 
        while getopts "e:hv" "OPTARG"; do
            case "${OPTARG}" in
                e)
                    if [[ ! ${e} =~ ^(dev|prod|uat|local)$ ]]; then
                        echo "Invalid environment: ${e}"
                        usage
                    fi

                    echo "Building Dev Kubernetes Cluster..."
                    repo_pulls
                    build
                    kind_deploy
                    ;;
                v)
                    # Update the value of the option x flag we defined above
                    OPT_V="true"
                    if [ "${OPT_V}" == "true" ]; then
                        echo "Building Versioned Kubernetes Docker Images..."
                        exit 0
                    fi
                    ;;
                h)
                    usage
                    ;;
                "?")
                    echo "INVALID OPTION -- ${OPTARG}" >&2
                    usage
                    ;;
                ":")
                    echo "MISSING ARGUMENT for option -- ${OPTARG}" >&2
                    usage
                    ;;
                *)
                    usage
                    ;;
            esac
        done
    else
        usage
    fi
else
    if [[ ! ${1} =~ ^(dev|prod|uat|local)$ ]]; then
        echo "Invalid environment: ${1}"
        usage
    else
        e=${1}
        echo "Building ${e} Kubernetes Cluster..."
        repo_pulls
        build
        kind_deploy
    fi
fi

# shellcheck source=/dev/null
source "${HOME}/.unitytree/.env"
echo "Done!"
