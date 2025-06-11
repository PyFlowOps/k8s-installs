#!/usr/bin/env bash

set -eou pipefail

# Let's import the public key
gpg --import "${HOME}/.pfo/public.key"

# Let's import the private key
gpg --import "${HOME}/.pfo/private.key"
