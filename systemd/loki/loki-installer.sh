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

PRODUCT="loki"
LOKI_VERSION="${1}"
CHIP_ARCH="${2}"
DOWNLOAD_LINK="https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-${CHIP_ARCH}.zip"

TEMP_DIR="/tmp/${PRODUCT}"
mkdir -p "${TEMP_DIR}"
curl -L "${DOWNLOAD_LINK}" -o "${TEMP_DIR}"/downloaded_file.zip
sudo unzip "${TEMP_DIR}"/downloaded_file.zip -d /tmp
rm -rf "${TEMP_DIR}"

sudo mv "/tmp/loki-linux-${CHIP_ARCH}" /usr/local/bin/loki
