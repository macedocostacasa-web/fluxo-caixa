# ADR-0009 — Particionamento & RU/s (Cosmos)

**Status**: Aceita — 2025-09-30  
**Decisão**  
- PK `/merchantId` em ambos containers  
- `lancamentos`: TTL `-1`, índice em `createdAt` (composto com `amount`)  
- `saldosDiarios`: TTL 7 dias, `id=YYYY-MM-DD`  
- **Autoscale** (ex.: base 1k RU/s, até 4k)

**Consequências**  
- ✅ Distribuição uniforme e consultas eficientes  
- ⚠️ Planejamento de custos RU/s e hot partitions se concentração por merchant
