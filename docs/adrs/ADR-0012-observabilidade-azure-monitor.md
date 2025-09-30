# ADR-0012 — Observabilidade (Azure Monitor/Logs + Workbooks)

**Status**: Aceita — 2025-09-30  
**Decisão**  
Centralizar logs/métricas/traços no **Azure Monitor/Log Analytics** com **Workbooks** por domínio; correlação por `correlationId`.

**Consequências**  
- ✅ Telemetria unificada e SLOs mensuráveis  
- ⚠️ Custo de retenção/logs; necessidade de filtros e amostragem

**Notas**  
- Alertas: backlog>0, DLQ>0, 429>0, p95>alvo, perda>5%, lag>10s.
