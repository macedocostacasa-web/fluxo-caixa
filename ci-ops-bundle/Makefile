
# === Tooling assumptions ===
# - Node 20+ (npx), Docker (optional), Azure CLI (az), k6
# - APIM publish requires environment variables:
#   APIM_RG, APIM_NAME, APIM_API_ID (ex: fin-v1), APIM_API_PATH (ex: api.fin/v1)
#   APIM_DISPLAY_NAME (ex: Fluxo de Caixa v1)

SHELL := /bin/bash

# Defaults
OPENAPI ?= docs/api/openapi.yaml
POSTMAN ?= docs/api/postman_collection.json
K6FILE ?= tests/k6/50rps_consolidado.js

# === Node tooling install (local, via npx) ===
.PHONY: install
install:
	@echo "No global install required. Using npx for spectral/prism/dredd."

# === OpenAPI quality ===
.PHONY: spec:lint
spec:lint:
	npx -y @stoplight/spectral-cli lint $(OPENAPI)

.PHONY: spec:mock
spec:mock:
	npx -y @stoplight/prism-cli mock -h 0.0.0.0 -p 4010 $(OPENAPI)

# === Contract testing (Dredd) ===
.PHONY: test:contract
test:contract:
	npx -y dredd --config dredd.yml

# === Load test (k6) ===
.PHONY: test:load
test:load:
	BASE_URL=$${BASE_URL:-http://localhost:3000/api.fin/v1} k6 run $(K6FILE)

# === Publish OpenAPI to APIM ===
.PHONY: apim:publish
apim:publish:
	./scripts/apim_publish.sh "$(OPENAPI)"

# === Validate all ===
.PHONY: ci
ci: spec:lint test:contract
	@echo "CI checks passed (lint + contract)."

