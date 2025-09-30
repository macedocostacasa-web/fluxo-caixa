# ADR-0004 — Cache de Leitura do Consolidado (Redis)

**Status**: Aceita — 2025-09-30  
**Decisão**  
Usar **Azure Cache for Redis** com padrão *cache-aside*, TTL 5–15 min para `saldosDiarios`; invalidação por evento de recálculo.

**Alternativas**  
- Sem cache (rejeitada: custo/latência maiores em pico)  
- Cache na aplicação (rejeitada: menos robusto em escala/distribuição)

**Consequências**  
- ✅ p95 baixo na leitura; menor RU/s do Cosmos em picos  
- ⚠️ Consistência eventual do snapshot; precisa `lastRecalcAt` no payload
