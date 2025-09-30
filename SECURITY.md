# SECURITY.md — Padrões de Segurança

## Escopo
Solução de Fluxo de Caixa (Azure): APIs de Lançamentos, Consolidador, relatórios e dados em Cosmos.

## Autenticação & Autorização
- **OAuth2/OIDC (Azure Entra ID)** com client-credentials para integrações server-to-server.
- **APIM** aplica `validate-jwt` (aud, issuer), *rate-limit* e validação de schema.
- Escopos: `api.read`, `api.readwrite`, `api.admin`.
- Tokens enviados apenas via `Authorization: Bearer` (HTTPS).

## Segredos & Identidade de Máquina
- **Managed Identity (MI)** para API/Functions acessar **Key Vault** (sem secrets no repo).
- Rotação automática de segredos; chaves armazenadas com tags de expiração.
- Proibido credencial estática em variáveis de ambiente sem KV.

## Proteção de Dados (LGPD)
- **Cosmos (Core SQL)**: dados minimizados; `saldosDiarios` com **TTL 7d** e export para Blob.
- *Soft delete* de lançamentos (`isDeleted`) e *purge* por política.
- PII no payload? Evitar; se necessário, criptografia em repouso (padrão Azure) + mascaramento nos logs.

## Rede e Borda
- **Front Door + WAF** com regras gerenciadas e custom rules.
- **Private Endpoints** para Cosmos, Service Bus, Redis, Blob; **VNET Integration** para App/Functions.
- Desabilitar endpoints públicos quando aplicável; DNS privado configurado.

## Criptografia
- Em trânsito: TLS 1.2+ em todas as superfícies.
- Em repouso: criptografia padrão de cada serviço (Cosmos/Redis/SB/Blob/Key Vault).
- Chaves gerenciadas (CMK) opcionais conforme compliance.

## Logging & Telemetria
- Logs **estruturados** e correlação via `x-correlation-id` (propagado pelo APIM).
- **Azure Monitor/Log Analytics** centralizado; retenção 30 dias (ajustável).
- Remover/mascarar PII de logs; usar IDs/UUIDs.

## Dependências & SCA
- Scans de dependências (`npm audit`, `trivy`/`syft`) e IaC (`tfsec`/`checkov`).
- Renovar libs vulneráveis em até 30 dias (ou antes se CVSS alto).

## Vulnerabilidades & Resposta a Incidentes
- Canal de reporte: abrir `SECURITY` issue privada ou e-mail do time de segurança.
- SLA: triagem em 24h úteis; mitigação em até 7 dias (CVSS ≥ 7) ou 30 dias (CVSS < 7).
- Postmortem com causa raiz e ações corretivas (sem blame).

## Backup & DR
- Export assíncrono de relatórios (Blob).
- RTO 30 min; RPO 15 min (escalando Cosmos/Functions e processando backlog).
