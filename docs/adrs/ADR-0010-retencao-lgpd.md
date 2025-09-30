# ADR-0010 — Retenção & LGPD

**Status**: Aceita — 2025-09-30  
**Decisão**  
- `saldosDiarios` com TTL 7 dias; export para Blob para histórico longo  
- `lancamentos` com *soft delete* (`isDeleted`) e *purge* por política

**Consequências**  
- ✅ Minimização de dados e custo  
- ⚠️ Processos de export/auditoria devem ser testados
