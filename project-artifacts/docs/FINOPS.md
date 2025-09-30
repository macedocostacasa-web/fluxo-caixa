# FINOPS — Estimativa de Custos (Azure)

> **Hipóteses**: 10 lojas, 20k lançamentos/dia, picos de consulta 50 rps por 5 min, retenção curta no `saldosDiarios` (7d). Região: *East US*. Valores aproximados (ordem de grandeza). Data: 2025-09-30.

## Principais drivers
- **Cosmos DB (Core SQL, autoscale)** — RU/s em picos (leitura consolidado) e escrita de lançamentos.
- **Azure Service Bus (Standard)** — mensagens publicadas/consumidas e DLQ.
- **Redis (Basic/Standard)** — cache do consolidado.
- **APIM (Developer/Consumption)** — gateway e políticas.
- **Monitor/Logs** — retenção 30 dias.

## Estimativas (dev → prod)
| Serviço | Tier | Dev (≈/mês) | Prod (≈/mês) | Observações |
|---|---|---:|---:|---|
| Cosmos DB | Autoscale (base 400–1000 RU/s) | US$ 25–60 | US$ 150–600 | RU/s escala com pico e TTL curto ajuda |
| Service Bus | Standard | US$ 10–30 | US$ 30–120 | Mensagens + conexões + operações |
| Redis | Basic C0 | US$ 16–20 | US$ 25–60 (Std C1) | Latência p95 e alivio de RU/s |
| APIM | Developer | US$ 50–70 | US$ 100–300 (Std/Cons) | Considerar consumo vs dedicado |
| Storage (Blob) | LRS | US$ 1–5 | US$ 5–20 | Export de relatórios e artefatos |
| Monitor/Logs | LA + AppInsights | US$ 10–30 | US$ 50–200 | Depende de ingestão/ret. |
| Front Door/WAF | Std/Premium | US$ 0–50 | US$ 50–200 | Opcional conforme borda |

> **Ações de otimização**: TTL 7d em `saldosDiarios`, índices mínimos necessários, *cache-aside*, budgets/alertas, amostragem de logs/traços, *cold start* controlado em Functions.
