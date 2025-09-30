# RUNBOOK.md — Operação & Suporte

## Visão
Serviço event-driven em Azure com API de Lançamentos (App Service), Consolidador (Functions), integração via Service Bus, dados em Cosmos e cache Redis.

## Painéis & Health
- **Workbook**: `workbooks/finance-overview.json`
- Sinais críticos: `http 5xx`, `p95`, backlog SB, DLQ, RU/s, *throttling* 429, `% perda`, lag de consumo.
- Health endpoints: `/healthz` (API); *function health* via logs/metrics.

## Alertas (recomendado)
- API: `5xx > 1% (5m)`, `p95 > 150ms (5m)`
- Consolidado: `p95 > 300ms (5m)`, `perda > 5% (5m)`
- Service Bus: `DeadLetteredMessages > 0`, `ActiveMessages > N`
- Cosmos: `ThrottledRequests > 0`, `Avg RU/s > 80% autoscale`
- Redis: `EvictedKeys > 0`
- Infra: `WAF blocks spike`, `APIM 429 rate-limit`

## Procedimentos Comuns

### 1) Backlog crescendo (Consolidador lento)
1. Verifique RU/s do Cosmos e *throttling* (429).
2. **Aumente autoscale** temporariamente (Cosmos) ou *Concurrency* da Function.
3. Confirme consumo do SB (lock, MaxDeliveryCount, erros).

### 2) DLQ drain (Service Bus)
1. Identifique mensagens na **DLQ** da assinatura `consolidador`.
2. Executar *reprocess* (script ou Function admin) movendo para a fila principal após correção.
3. Documentar causa (schema inválido, exceção no handler).

### 3) Replay de um dia
- Endpoint admin: `POST /admin/replay?merchantId=<MID>&data=YYYY-MM-DD`
- O Consolidador recomputa `saldosDiarios` e emite evento de invalidação de cache.

### 4) Flush de cache (Redis)
- Remover chave `saldo:<merchantId>:<YYYY-MM-DD>` quando detectar dado inválido.
- O recálculo repopula no próximo acesso.

### 5) Aumentar RU/s (Cosmos)
- Subir `maxThroughput` do autoscale por janela limitada.
- Monitorar custo/uso e rebaixar após o pico.

### 6) Escalonar Functions
- Verificar *cold start* e *concurrency*.
- Ajustar `FUNCTIONS_WORKER_PROCESS_COUNT` e *batch size* do trigger SB com cuidado.

### 7) Troca/rotação de segredo
- Preferir **Managed Identity**. Se necessário, rotacionar segredo em **Key Vault** e reiniciar App/Function.

## Playbooks Rápidos (CLI)

### Service Bus — Mensagens ativas e DLQ
```bash
# Contagem rápida (adaptar nomes reais)
az servicebus topic subscription show   -g <rg> --namespace-name sb-<name>-<env> --topic-name lancamentos   --name consolidador --query "{active:countDetails.activeMessageCount, dlq:countDetails.deadLetterMessageCount}"
```

### Cosmos — Throughput atual (autoscale)
```bash
az cosmosdb sql container throughput show   -g <rg> -a cdb-<name>-<env> -d finance -n saldosDiarios   --query "{maxThroughput:resource.autoscaleSettings.maxThroughput}"
```

### Redis — Apagar chave de saldo
```bash
redis-cli -h <host> -a <password> DEL saldo:<MID>:2025-09-30
```

## Incidentes (Severidade)
- **Sev1** indisponibilidade do POST `/lancamentos` (workaround ≤ 30 min).
- **Sev2** perda > 5% por > 10 min ou lag > 10s sustentado.
- **Sev3** degradação isolada (p95 elevado, throttling ocasional).

**Passos padrão**: isole impacto, comunique status, mitigue (escala RU/s, limitar tráfego no APIM, pausar *consumers* problemáticos), RCA e *postmortem*.

## Manutenção Programada
- Janelas fora de horário comercial.
- Anunciar com 24h de antecedência.
- Verificar *drain* do tópico antes de mudanças de schema.

## DR & Recuperação
- Reimplantar Functions/API via pipeline.
- Reprocessar eventos pendentes do SB.
- Validar integridade do `saldosDiarios` consultando amostras e p95.

## Contatos
- **On-call**: @time-sre
- **Arquitetura**: @time-arquitetura
- **Segurança**: @time-security
