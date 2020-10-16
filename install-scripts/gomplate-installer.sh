#!/bin/bash

# Exit on error. Append "|| true" if you expect an error.
set -o errexit
# Exit on error inside any functions or subshells.
set -o errtrace
# Do not allow use of undefined vars. Use ${VAR:-} to use an undefined VAR
set -o nounset
# Catch the error in case mysqldump fails (but gzip succeeds) in `mysqldump | gzip`
set -o pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
CLEAR_COLOR='\033[0m'

function fail {
    echo -e "${RED}[error] $1${CLEAR_COLOR}"
    exit 1
}

VERSION="${1:?Specify a version}"
CHIP_ARCH="${2:?Specify a chip architecture}"

DOWNLOAD_LINK="https://github.com/hairyhenderson/gomplate/releases/download/v${VERSION}/gomplate_linux-${CHIP_ARCH}"

sudo curl -L "${DOWNLOAD_LINK}" -o /usr/local/bin/gomplate
sudo chmod 755 /usr/local/bin/gomplate
