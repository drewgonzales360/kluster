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

PRODUCT="${1:?Specify a product}"
VERSION="${2:?Specify a version}"
CHIP_ARCH="${3:?Specify a chip architecture}"

DOWNLOAD_LINK="https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_linux_${CHIP_ARCH}.zip"

TEMP_DIR="/tmp/${PRODUCT}"
mkdir -p "${TEMP_DIR}"
curl -L "${DOWNLOAD_LINK}" -o "${TEMP_DIR}"/downloaded_file.zip
sudo unzip "${TEMP_DIR}"/downloaded_file.zip -d /usr/local/bin
rm -rf "${TEMP_DIR}"

sudo useradd "${PRODUCT}" -s /bin/bash
sudo mkdir "/etc/${PRODUCT}"
sudo chown -R "${PRODUCT}":${PRODUCT} "/etc/${PRODUCT}"
