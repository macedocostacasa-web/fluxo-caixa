# Plano de Transição & Cutover — Fluxo de Caixa

**Data**: 2025-09-30  
**Escopo**: migrar do legado para a arquitetura event-driven (API Lançamentos → SB → Functions → Cosmos/Redis) sem interromper operação.

## 1. Pré-requisitos
- OpenAPI v1 publicado no APIM (rota `api.fin/v1`).
- Conectores do legado validados (se houver export).
- Backlog e DLQ do Service Bus **vazios**.
- SLOs de base coletados (p95 leitura consolidado, RU/s Cosmos).

## 2. Estratégia
- **Dual-write opcional**: durante piloto, legado e nova API recebem escrita. Comparar saldos por amostragem.
- **Backfill**: importar lançamentos do último `N` dias do legado → publicar no **topic** (`lancamentos`). Functions recalculam `saldosDiarios`.
- **Feature flags**: rota de leitura `/consolidado` com *flag* para ativar cache/novo cálculo gradualmente.
- **Rollback**: desativar consumidores, apontar leitura para fonte anterior e reverter DNS/APIM route.

## 3. Passo-a-passo (Linha do tempo)
1) **T–7 dias**: provisionar infra (Bicep), configurar APIM/Entra ID, validar tokens.  
2) **T–5**: executar **backfill** por merchant em janela controlada; monitorar RU/s/lag.  
3) **T–3**: habilitar **dual-write** (se aplicável) e **comparação de saldos** (amostra de 5%).  
4) **T–1**: congelar mudanças no legado e pipeline de dados; SRE em *stand by*.  
5) **T0**: *cutover* de leitura: ativar rota nova `/consolidado` via APIM.  
6) **T+1**: drenar divergências e *replay* pontuais (endpoint `/admin/replay`).  
7) **T+7**: desativar caminho legado, encerrar dual-write.

## 4. Critérios de Aceite
- p95 leitura consolidado ≤ 300 ms; perda ≤ 5% sob pico (5 min).  
- Divergência de saldo ≤ 0.1% nas amostras do período.  
- DLQ estável (=0) após 24h e sem regressão de RU/s anormais.

## 5. Riscos & Mitigações
- **Hot partition** (merchant concentrado) → aumentar autoscale RU/s; *sharding* por tenant se necessário.  
- **Lag alto** no consumo → aumentar concorrência do Function e RU/s; pausar backfill.  
- **Mudança de schema no legado** → congelar schema antes do backfill; validação rígida no APIM.
