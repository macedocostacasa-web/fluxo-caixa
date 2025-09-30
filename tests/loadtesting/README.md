# Azure Load Testing — Execução via GitHub Actions

Este repositório inclui um workflow `load-testing-k6.yml` que roda o script k6 `tests/k6/50rps_consolidado.js` no **Azure Load Testing**.

## Pré-requisitos
- Recurso **Azure Load Testing** criado (`AZURE_LOADTESTING_RESOURCE`) no **resource group** (`AZURE_RESOURCE_GROUP`).
- Segredos no GitHub:
  - `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID` (OIDC)
  - `AZURE_LOADTESTING_RESOURCE`, `AZURE_RESOURCE_GROUP`

## Disparo manual
1. Vá em *Actions* → **load-testing-k6** → **Run workflow**.
2. Informe `base_url`, `merchant_id` e `date` (opcional; defaults fornecidos).
3. O job executa o teste e publica artefatos (logs, resultados, gráficos).

O arquivo de configuração do teste fica em `tests/loadtesting/k6-50rps.yaml`. Ajuste `engineInstances` ou `failureCriteria` conforme necessário.
