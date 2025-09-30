# ADR-0002 — Banco de Dados: Azure Cosmos DB (Core SQL)

**Status**: Aceita — 2025-09-30  
**Contexto**  
Modelo orientado a acesso por `(merchantId, data)` e necessidade de latência baixa, escalabilidade elástica e operação gerenciada.

**Decisão**  
Usar **Cosmos DB (Core SQL)** com containers:
- `lancamentos` (PK `/merchantId`)  
- `saldosDiarios` (PK `/merchantId`, `id=YYYY-MM-DD`)

**Alternativas**  
- Azure SQL (bom para relacionais fortes; maior esforço de particionamento/elast.)  
- Cosmos (escolhida) — latência preditiva, RU/s autoscale, particionamento simples

**Consequências**  
- ✅ Escala por partição; custo elástico via RU/s  
- ✅ Leitura pós-escrita coerente com **consistência Session** por partição  
- ⚠️ Joins limitados; necessidade de modelagem por acesso

**Notas**  
- Índice composto `(createdAt, amount)` em `lancamentos`.  
- `saldosDiarios` com TTL 7 dias (export para Blob).