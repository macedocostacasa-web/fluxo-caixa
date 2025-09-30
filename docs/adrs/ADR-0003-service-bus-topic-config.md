# ADR-0003 — Mensageria: Azure Service Bus (Topic/Subscriptions)

**Status**: Aceita — 2025-09-30  
**Decisão**  
Usar **Namespace Standard**, **Topic** `lancamentos`, assinaturas com **DLQ**, **duplicateDetection** (`PT24H`), *retry/backoff* e *dead-lettering on message expiration*.

**Alternativas**  
- Queue simples (rejeitada: sem *fan-out* e regras de assinatura)  
- Event Grid (rejeitada aqui pelo requisito de DLQ robusto)

**Consequências**  
- ✅ Roteamento flexível para novos consumidores  
- ✅ Operabilidade com DLQ e métricas de backlog  
- ⚠️ Custo/tier maior que fila básica

**Notas**  
- Monitorar `ActiveMessages`, `DeadLetteredMessages`; runbook de **DLQ drain**.
