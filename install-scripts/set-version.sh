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

GIT_BRANCH="${1:?Git branch}"
GIT_HASH="${2:?Git hash}"
DATE="$(date)"

mkdir /etc/booboo

cat > "/etc/booboo/version.yaml" << EOF
git_branch: ${GIT_BRANCH}
git_hash: ${GIT_HASH}
build_date: ${DATE}
EOF
