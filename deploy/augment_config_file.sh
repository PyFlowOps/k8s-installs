#!/usr/bin/env bash

BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
_STRING="${1}=${2}"

grep -Fxq "${_STRING}" ~/.pfo/.env || echo "\n\n" ~/.pfo/.env && echo "${_STRING}" ~/.pfo/.env
