#!/usr/bin/env bash

set -eou pipefail

# Let's import the public key
gpg --import "${HOME}/.pfo/keys/pfo.pub"

# Let's import the private key
gpg --import "${HOME}/.pfo/keys.pfo"
