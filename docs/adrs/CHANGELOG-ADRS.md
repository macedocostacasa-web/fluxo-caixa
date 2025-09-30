# CHANGELOG — Decisões de Arquitetura (ADRs)

Data do pacote: 2025-09-30

| ADR | Tema | Requisitos/NFRs relacionados | Observações |
|---|---|---|---|
| ADR-0001 | Assíncrono (SB Topic) | NFR-01 (isolamento), RF-ARQ-01 | Mantém Lançamentos on-line com consolidador fora |
| ADR-0002 | Cosmos DB Core SQL | RF-ARQ-02, NFR-04/05/08 | Particionamento `/merchantId`, autoscale RU/s |
| ADR-0003 | Service Bus config | NFR-02/03, RF-ARQ-01 | DLQ, retry, duplicate detection |
| ADR-0004 | Redis cache-aside | NFR-02/04 | p95 leitura do consolidado e custo RU/s |
| ADR-0005 | Segurança (WAF/APIM/ID/KV) | NFR-06 | Zero Trust e governança de APIs |
| ADR-0006 | SLOs & error budget | NFR-02/03/01 | “50 rps, ≤5% perda, lag ≤10s” mensuráveis |
| ADR-0007 | Idempotência/dedup | RN-01, RF-ARQ-03 | Idempotency-Key, correlationId, upsert/duplicateDetection |
| ADR-0008 | Private Endpoints/VNET | NFR-06 | Menor superfície de ataque, LGPD |
| ADR-0009 | RU/s & índices (Cosmos) | NFR-02/08 | Hot partitions e custos monitorados |
| ADR-0010 | Retenção & LGPD | NFR-06/08 | TTL + export a Blob; soft delete/purge |
| ADR-0011 | Versão & contrato API | RF-ARQ-05/06 | OpenAPI v1, compatibilidade, testes de contrato |
| ADR-0012 | Observabilidade (Monitor) | NFR-09 | Workbooks, alertas e correlação |
