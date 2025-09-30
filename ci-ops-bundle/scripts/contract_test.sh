#!/usr/bin/env bash
set -euo pipefail
export DREDD_CONFIGURATION=dredd.yml
npx -y dredd --config "${DREDD_CONFIGURATION}"
