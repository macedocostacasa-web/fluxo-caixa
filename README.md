# Fluxo de Caixa — Arquitetura & Implementação (Azure)

> Controle de lançamentos (débitos/créditos) e saldo diário consolidado, com **alta disponibilidade**, **event-driven** e **observabilidade** completa.  
> Tecnologias-chave: **Azure API Management, App Service, Azure Functions, Service Bus, Cosmos DB (Core SQL), Redis, Blob, Key Vault, Monitor/App Insights**.

## 🔎 Visão Geral
- **Domínios**: `Lançamentos` (comando) e `Consolidado Diário` (consulta).
- **Padrão arquitetural**: *event-driven* (API → Topic → Function → Cosmos/Redis), **idempotência** ponta a ponta, **consistência eventual** controlada.
- **NFRs (SLOs)**: 50 rps no consolidado com **perda ≤ 5%** (janelas de 5 min), p95 leitura ≤ 300 ms (com cache), lag médio do tópico ≤ 10 s.

## 🧭 Arquitetura (diagramas)
- `docs/arch/01-motivation/motivation-overview.drawio`
- `docs/arch/02-business/business-services-process.drawio`
- `docs/arch/03-application/application-cooperation.drawio`
- `docs/arch/04-technology/technology-final-implementation.drawio`
- `docs/arch/04-technology/technology-scaled-observability-resilience.drawio`
- `docs/arch/05-implementation/implementation-migration.drawio`

> Legenda/cores em `docs/archimate/00-catalogo/legenda-e-convencoes.md`.  
> Decisões registradas em `docs/adrs/` (0001–0012 + TEMPLATE).

## 📁 Estrutura do Repositório (resumo)
```
docs/
  arch/…           # diagramas .drawio e notas (MD/YAML)
  adrs/…                # Architecture Decision Records
  api/
    openapi.yaml        # especificação da API (v1)
    postman_collection.json
  apim-policies/
    policy-global.xml   # validate-jwt, rate-limit, correlação
  FINOPS.md
infra/
  bicep/…               # IaC (módulos: cosmos, sb, redis, apim, kv, monitor…)
  terraform/…           # esqueleto
workbooks/finance-overview.json
tests/
  k6/50rps_consolidado.js
  loadtesting/k6-50rps.yaml
.github/workflows/
  ci.yml                # lint/contract
  deploy-infra.yml      # Bicep (OIDC)
  deploy-apps.yml       # API/Functions
  load-testing-k6.yml   # Azure Load Testing (k6)
SECURITY.md
SECURITY-THREAT-MODEL.md
RUNBOOK.md
RUNBOOK-DLQ-DRILL.md
CONTRIBUTING.md
```

## 🧪 Como rodar localmente (MVP)
Pré-requisitos: **Node 20+**, **Azure Functions Core Tools**, **Docker** (opcional), **k6** (opcional).

1. **Mock da API** (sem backend) com Prism:
   ```bash
   make spec:mock     # sobe :4010 a partir de docs/api/openapi.yaml
   ```
2. **Testes de contrato** (contra sua API real ou o mock):
   ```bash
   make test:contract # usa dredd.yml (BASE_URL padrão http://localhost:3000/api.fin/v1)
   ```
3. **Teste de carga (NFR)** — 50 rps por 5 min:
   ```bash
   make test:load     # k6 roda tests/k6/50rps_consolidado.js
   ```

> A API real (App Service) e Functions devem seguir os contratos do `openapi.yaml` (Idempotency-Key no POST /lancamentos).

## ☁️ Deploy de Infra & Apps (GitHub Actions)
### OIDC com Azure
Configure segredos do repositório:
- `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`
- (Load Testing) `AZURE_LOADTESTING_RESOURCE`, `AZURE_RESOURCE_GROUP`

### Infra (Bicep)
```bash
# Actions → deploy-infra → Run workflow
# Parâmetros: name=fin, env=dev, location=eastus
```
O workflow cria RG e aplica `infra/bicep/main.bicep` (cosmos, service bus, redis, storage, apim, key vault, monitor).

### Apps (API/Functions)
```bash
# Actions → deploy-apps → informar nomes dos apps (WebApp/Function)
```
Use `APIM` para importar o **OpenAPI**:
```bash
export APIM_RG=rg-fin-dev-core
export APIM_NAME=apim-fin-dev
export APIM_API_ID=fin-v1
export APIM_API_PATH=api.fin/v1
export APIM_DISPLAY_NAME="Fluxo de Caixa v1"
make apim:publish
```

## 📈 Observabilidade & SLOs
- **Workbook**: `workbooks/finance-overview.json` (DLQ/backlog SB, RU/s Cosmos, p95/p99, perda%).
- **Load testing** (pipeline): `load-testing-k6.yml` roda k6 no **Azure Load Testing**; falha se `http_req_failed > 5%` ou `p95 > 300ms`.
- **Evidências**: salve prints/resultados em `artifacts/monitoring/` (placeholders prontos).

## 🔐 Segurança
- **Entra ID (OAuth2/OIDC)** + **APIM** com `validate-jwt`, **rate-limit**, validação de schema.
- **Key Vault + Managed Identity** (zero secret em repositório).
- **Private Endpoints + DNS privado** para Cosmos/SB/Redis/Blob (ativáveis na IaC).
- Políticas e *threat model* em `SECURITY.md` e `SECURITY-THREAT-MODEL.md`.
- **Checklist de integração** (consumo seguro): `docs/security/consumo-servicos-checklist.md`.

## 💸 FinOps
- Estimativas em `docs/FINOPS.md` (Cosmos autoscale, SB tier, Redis, APIM, Monitor).
- **Budgets** prontos em `infra/bicep/modules/budgets.bicep` (dev/hml/prod) — configure e aplique.

## 🔄 Transição (Legado)
- Plano de **cutover** em `docs/migration/cutover.md`: backfill, dual-write opcional, flags, rollback e critérios de aceite.

## 🤝 Contribuição
- Leia `CONTRIBUTING.md` (branches `feat/`, `fix/`, ADRs, checklist de PR) e `.github/pull_request_template.md`.
- Revisores automáticos por pasta em `.github/CODEOWNERS`.

## 📜 Licença
MIT

---

### TL;DR operacional
- **Validar contratos**: `make spec:lint` → `make spec:mock` → Postman.  
- **Publicar no APIM**: `make apim:publish`.  
- **NFR**: `make test:load` local ou **Actions → load-testing-k6**.  
- **Operação**: ver `RUNBOOK.md` e o *drill* `RUNBOOK-DLQ-DRILL.md`.
