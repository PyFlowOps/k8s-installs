#!/usr/bin/env bash

set -eou pipefail

BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
IFS= read -p "Enter the name of the key: [Example] dev.pfo.com - " KEY_NAME
KEY_NAME=${KEY_NAME:-"dev.pfo.com"}
IFS= read -p "Enter a comment for the key: [Example] Kubernetes cluster for the dev environment - " KEY_COMMENT
KEY_COMMENT=${KEY_COMMENT:-"Kubernetes cluster for the dev environment"}

gpg --batch --full-generate-key <<EOF
%no-protection
Key-Type: 1
Key-Length: 4096
Subkey-Type: 1
Subkey-Length: 4096
Expire-Date: 0
Name-Comment: ${KEY_COMMENT}
Name-Real: ${KEY_NAME}
EOF

FINGERPRINT="$(gpg --list-secret-key "${KEY_NAME}" | sed -n 2,2p | tr -d '[:space:]')"

# We need to add this variable to the config file ~> ~/.pfo/.env
bash ${BASE}/augment_config_file.sh FINGERPRINT "${FINGERPRINT}"

if [ -f "${HOME}/.sops.yaml" ]; then
    if [[ $(wc -l < "${HOME}/.sops.yaml") == 3 ]]; then
        echo "Rebuilding .sops.yaml file..."
        rm -rf "${HOME}/.sops.yaml"
    fi
    echo "Moving .sops.yaml file..."
    if [[ ! -d "${HOME}/.pfo" ]]; then
        mkdir "${HOME}/.pfo"
    fi
fi

if [ ! -f "${HOME}/.sops.yaml" ]; then
    echo "Creating .sops.yaml file"
    touch "${HOME}/.sops.yaml"
    {
        printf 'creation_rules:'
        printf '  - pgp: >-'
        printf '      %s' "${FINGERPRINT}"
    } >> "${HOME}/.sops.yaml"
fi

# Let's export the public key
gpg --export -a \""${KEY_NAME}"\" > "${HOME}/.pfo/keys/pfo.pub"
gpg --export-secret-key -a \""${KEY_NAME}"\" > "${HOME}/.pfo./keys/pfo"

# Let's encrypt a file
# sops -e secrets.yaml > secrets.yaml.enc

# Let's decrypt a file
# sops -d secrets.yaml.enc > secrets.yaml

# Let's encrypt a file with a specific key
# sops -e --pgp 0x1234567890ABCDEF secrets.yaml > secrets.yaml.enc

# Let's decrypt a file with a specific key
# sops -d --pgp 0x1234567890ABCDEF secrets.yaml.enc > secrets.yaml  
