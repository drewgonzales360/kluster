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

YAML_DATASOURCE="$(mktemp -d /tmp/prometheusXXXX)"
YAML_DATASOURCE_FILE="${YAML_DATASOURCE}/data.yaml"
cat > "${YAML_DATASOURCE_FILE}" << EOF
bind_addr: "$(ifconfig | grep 'inet 192' | awk '{print $2}')"
EOF

gomplate -d "data=file://${YAML_DATASOURCE_FILE}" -f /etc/prometheus/prometheus.yaml.template -o /etc/prometheus/prometheus.yaml
