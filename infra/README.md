# Infra — Bicep/Terraform + Workflows

**Bicep** (`infra/bicep`): módulos para Cosmos, Service Bus, Redis, Storage, APIM, Key Vault, Monitor e rede.  
**Terraform** (`infra/terraform`): esqueleto pronto para evoluir.  
**Workflows** (`.github/workflows`): `deploy-infra.yml` (Bicep via OIDC) e `deploy-apps.yml` (API/Functions).

### Deploy rápido (Bicep)
1) Configure OIDC no Azure e adicione os segredos `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID` no GitHub.  
2) Crie o RG e rode o workflow **deploy-infra** com `name=fin`, `env=dev`, `location=eastus`.

> **Private Endpoints/DNS** estão preparados no módulo de rede; para ativar, passe `enablePrivateNetwork=true` e complete as seções *placeholder* nos módulos de cada recurso.
