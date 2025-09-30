#!/usr/bin/env bash
set -euo pipefail

OPENAPI_FILE="${1:-docs/api/openapi.yaml}"

: "${APIM_RG:?Missing APIM_RG}"
: "${APIM_NAME:?Missing APIM_NAME}"
: "${APIM_API_ID:?Missing APIM_API_ID}"
: "${APIM_API_PATH:?Missing APIM_API_PATH}"
: "${APIM_DISPLAY_NAME:?Missing APIM_DISPLAY_NAME}"

echo "Importando OpenAPI para APIM ${APIM_NAME}/${APIM_API_ID}..."
az apim api import \
  --resource-group "${APIM_RG}" \
  --service-name "${APIM_NAME}" \
  --api-id "${APIM_API_ID}" \
  --path "${APIM_API_PATH}" \
  --specification-format OpenApi \
  --specification-path "${OPENAPI_FILE}" \
  --display-name "${APIM_DISPLAY_NAME}" \
  --protocols https

echo "Concluído."
