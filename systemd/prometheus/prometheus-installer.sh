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

PROMETHEUS_VERSION="${1:?Select a prometheus version (2.22.0)}"
CHIP_ARCH="${2:?Select a chip architecture}"
PRODUCT="prometheus"
PROM_TEMP_DIR="/tmp/prometheus"
PROM_TEMP_FILE="${PROM_TEMP_DIR}/download.zip"

mkdir -p "${PROM_TEMP_DIR}"
curl -L "https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-${CHIP_ARCH}.tar.gz" -o "${PROM_TEMP_FILE}"
tar -xzvf "${PROM_TEMP_FILE}" -C "${PROM_TEMP_DIR}"

sudo cp "/tmp/prometheus/prometheus-${PROMETHEUS_VERSION}.linux-${CHIP_ARCH}/prometheus" /usr/local/bin
sudo cp "/tmp/prometheus/prometheus-${PROMETHEUS_VERSION}.linux-${CHIP_ARCH}/promtool" /usr/local/bin

sudo useradd "${PRODUCT}" -s /bin/bash
sudo mkdir "/etc/${PRODUCT}"
sudo chown -R "${PRODUCT}" "/etc/${PRODUCT}"
