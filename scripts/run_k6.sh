#!/usr/bin/env bash
set -euo pipefail
FILE="${1:-tests/k6/50rps_consolidado.js}"
BASE_URL="${BASE_URL:-http://localhost:3000/api.fin/v1}" MERCHANT_ID="${MERCHANT_ID:-b7b3c39e-1234-4f7c-8a55-1d2f3a4b5c6d}" DATE="${DATE:-2025-09-30}" k6 run "${FILE}"
