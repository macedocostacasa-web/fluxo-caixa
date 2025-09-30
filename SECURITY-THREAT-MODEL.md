# SECURITY-THREAT-MODEL.md — STRIDE (Resumo)

Este documento modela ameaças usando **STRIDE** para o sistema de Fluxo de Caixa em Azure.
Escopo: Front Door/WAF → APIM → API Lançamentos (App Service) → Service Bus → Functions (Consolidador) → Cosmos → Redis → Blob/Monitor/Key Vault.

## 1) Spoofing (Falsificação de identidade)
- **Risco**: cliente sem identidade válida chama APIs; identidade de serviço falsificada para acessar dados.
- **Mitigações**
  - OAuth2/OIDC (Entra ID) + `validate-jwt` (APIM) com `aud/iss` e *clock skew* limitado.
  - **Managed Identity** em App/Functions; negar *connection strings* estáticas.
  - Private Endpoints + restrições de rede para evitar acesso anônimo a Cosmos/SB/Redis.

## 2) Tampering (Alteração de dados)
- **Risco**: manipulação de payload de lançamento; alteração indevida de saldos.
- **Mitigações**
  - TLS 1.2+ fim a fim; WAF na borda; validação de schema (OpenAPI) no APIM.
  - **Idempotency-Key** e duplicate detection (SB) + upsert por `(merchantId,lancamentoId)`.
  - Versionamento de eventos; *immutability* lógica (estorno em vez de edição).

## 3) Repudiation (Negação de autoria)
- **Risco**: usuário nega ter enviado/alterado lançamento.
- **Mitigações**
  - Logs estruturados com `x-correlation-id`, `sub` do token e *signed headers* no gateway.
  - Retenção de telemetria e export de trilhas para armazenamento imutável (opcional).

## 4) Information Disclosure (Exposição de informação)
- **Risco**: vazamento de saldos/lançamentos ou metadados sensíveis.
- **Mitigações**
  - Escopos/OAuth por papel; mascaramento de PII em logs.
  - Key Vault para segredos; RBAC mínimo necessário.
  - Private Endpoints; desabilitar endpoints públicos quando possível.

## 5) Denial of Service (Negação de serviço)
- **Risco**: overload em API/Consolidador/Cosmos; picos de tráfego ou ataques.
- **Mitigações**
  - WAF/Rate-limit no APIM; *backpressure*; fila (SB) para desacoplar.
  - Autoscale RU/s (Cosmos); cache Redis para aliviar leituras.
  - *Circuit breakers* e *retry* com jitter; *dead-letter* e reprocesos.

## 6) Elevation of Privilege (Elevação de privilégio)
- **Risco**: função com privilégios excessivos altera dados ou parâmetros de infra.
- **Mitigações**
  - Princípio do menor privilégio (RBAC), segregar `api.read`/`readwrite`/`admin`.
  - Revisão de permissão via **CODEOWNERS** + PRs obrigatórios.
  - Scans de IaC e aprovações antes de aplicar mudanças.

## Suposições e Dependências
- Confiança no provedor de identidade (Entra ID) e nos serviços gerenciados (Cosmos/SB/Redis).
- DNS privado corretamente configurado; relógios sincronizados (NTP).

## Riscos Residuais & Ações
- Cold start/limites de concorrência podem gerar filas → mitigar com aquecimento em horários de pico.
- Hot partitions em Cosmos → observar distribuição por `merchantId`, particionar por região/tenant se necessário.
- Custos de logs/monitoramento → aplicar amostragem e budgets.

## Verificações Periódicas
- Pentest/DAST anual; revisões trimestrais de perfis RBAC e segredos.
- *Chaos drills* (falha do consolidador, DLQ, throttling 429) semestrais.
