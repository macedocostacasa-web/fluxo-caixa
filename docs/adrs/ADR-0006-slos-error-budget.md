# ADR-0006 — SLOs & Error Budget (Perda ≤ 5% e 50 rps)

**Status**: Aceita — 2025-09-30  
**Contexto**  
O case exige 50 rps no consolidado com até 5% de perda em picos e independência entre serviços.

**Decisão**  
Formalizar SLOs:  
- Throughput **≥ 50 rps** por 5 min (leitura consolidado p95 ≤ 300 ms)  
- **Perda ≤ 5%** em pico (janelas de 5 min)  
- **Lag médio ≤ 10s** no consumo do tópico

**Consequências**  
- ✅ Alertas objetivos e operação baseada em SLO  
- ⚠️ Telemetria e *replays* aumentam complexidade

**Notas**  
- Relatórios de perda/lag; *replays* fora do pico; orçamento de erro documentado.
