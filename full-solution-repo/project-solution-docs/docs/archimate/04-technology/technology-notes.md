# Notes — Technology & Deployment

**Nós/Serviços**: Front Door, WAF, APIM, App Service, Functions, Service Bus, Cosmos DB, Redis, Blob Storage, Key Vault, Monitor

**Segurança**
- OAuth2/OIDC (Entra ID), APIM (validate-jwt, rate limit, validação de schema)
- Managed Identity + Key Vault
- Private Endpoints (Cosmos/SB/Redis/Blob) + VNET Integration (App/Func)

**Observabilidade**
- Azure Monitor/Logs; Workbooks com métricas de RU/s, backlog/DLQ, p95/p99, % perda, lag.

**FinOps**
- Cosmos autoscale (RU/s) como driver; tiers developer/serverless em dev; budgets/alerts.
