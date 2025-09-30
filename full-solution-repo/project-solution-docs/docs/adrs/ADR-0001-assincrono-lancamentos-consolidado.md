# ADR-0001 — Assíncrono entre Lançamentos e Consolidado

**Status**: Aceita — 2025-09-30  
**Contexto**  
O serviço de controle de lançamentos **não pode** ficar indisponível se o consolidador cair. É necessário desacoplar gravação (comando) de cálculo (consulta/relatório) e suportar crescimento de demanda.

**Decisão**  
Publicar eventos `EventoLancamento` em **Azure Service Bus (Topic)**; o **Consolidador (Azure Functions)** consome assíncrono via assinatura com DLQ e *retry/backoff*.

**Alternativas consideradas**  
- Chamada síncrona API→Consolidador (rejeitada: acoplamento e impacto na disponibilidade)  
- Fila simples sem tópico (rejeitada: limita múltiplos consumidores e roteamento)  
- Event Grid (aceitável, mas Service Bus tem DLQ/sessions/filters mais adequados ao padrão command→processing)

**Consequências**  
- ✅ Lançamentos continuam mesmo se o consolidador estiver fora (backlog cresce)  
- ✅ Suporte nativo a DLQ/replay; múltiplos assinantes futuros (analytics)  
- ⚠️ Eventual consistency e mais componentes operacionais

**Alinhamento ao case**: requisito de isolamento de falhas; 50 rps no consolidado.

**Notas de implementação**  
- Topic `lancamentos` com **duplicateDetection** 24h; **MaxDeliveryCount**=10; políticas de retry exponencial.  
- Correlacionar `correlationId` entre API/evento/Functions.
