#!/usr/bin/env bash

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
R_SCRIPT="${SCRIPT_DIR}/scripts/setup-r-env.R"

if ! command -v Rscript >/dev/null 2>&1; then
    echo "Rscript is not installed. Install the 'r' package first."
    exit 1
fi

if [ ! -f "${R_SCRIPT}" ]; then
    echo "Could not find ${R_SCRIPT}"
    exit 1
fi

exec Rscript "${R_SCRIPT}" "$@"
