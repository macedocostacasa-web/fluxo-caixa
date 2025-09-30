# ADR-0007 — Idempotência & Deduplicação

**Status**: Aceita — 2025-09-30  
**Decisão**  
- `Idempotency-Key` obrigatório em `POST /lancamentos`  
- `correlationId` no evento  
- **duplicateDetection** no Service Bus (24h)  
- *Upsert* no Cosmos por `(merchantId, lancamentoId)`

**Consequências**  
- ✅ Evita lançamentos duplicados e recomputo indevido  
- ⚠️ Gestão de chaves idempotentes e janela de detecção
