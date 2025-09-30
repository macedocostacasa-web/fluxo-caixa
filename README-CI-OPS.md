# CI/Ops — OpenAPI, Contratos e Publicação APIM

## Requisitos
- Node 20+, Azure CLI, k6

## Comandos
```bash
make spec:lint            # valida OpenAPI com Spectral
make spec:mock            # mock server local (Prism) em :4010
make test:contract        # Dredd contra BASE_URL (default localhost:3000/api.fin/v1)
make test:load            # k6 (50 rps por 5 min) com thresholds de perda e p95
make apim:publish         # importa OpenAPI no APIM (usa AZURE_* envs)
```

### Publicar no APIM
```bash
export APIM_RG=rg-fin-dev-core
export APIM_NAME=apim-fin-dev
export APIM_API_ID=fin-v1
export APIM_API_PATH=api.fin/v1
export APIM_DISPLAY_NAME="Fluxo de Caixa v1"
make apim:publish
```
