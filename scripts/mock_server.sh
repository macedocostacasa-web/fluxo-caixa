#!/usr/bin/env bash
set -euo pipefail
OPENAPI_FILE="${1:-docs/api/openapi.yaml}"
PORT="${PORT:-4010}"
npx -y @stoplight/prism-cli mock -h 0.0.0.0 -p "${PORT}" "${OPENAPI_FILE}"
