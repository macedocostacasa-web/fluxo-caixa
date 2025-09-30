# RUNBOOK-DLQ-DRILL.md — Simulado: Dead-Letter Queue (Service Bus)

Objetivo: Ensaiar identificação, tratamento e recuperação de mensagens mortas (DLQ) da assinatura `consolidador` do tópico `lancamentos`.

## Pré-requisitos
- Acesso `Reader`/`Contributor` ao RG e ao namespace SB.
- `az cli` logado; nomes reais de **RG**, **namespace**, **topic**, **subscription**.
- Consolidador com *retries* e DLQ configurados (MaxDeliveryCount≥10).

## Cenário de Falha (Gerado)
1. Lançar mensagens com payload inválido (schema que fará a Function falhar).
2. Confirmar aumento de `DeliveryCount` e, após o limite, ida à **DLQ**.

## Passo-a-passo

### 1) Medir estado inicial
```bash
az servicebus topic subscription show -g <rg> --namespace-name <ns> --topic-name lancamentos --name consolidador   --query "{active:countDetails.activeMessageCount, dlq:countDetails.deadLetterMessageCount}"
```

### 2) Injetar mensagens inválidas (opcional)
Use sua API com um campo inesperado para provocar falha no consolidado.

### 3) Confirmar DLQ>0
Repita o comando do passo 1 até `dlq > 0`.

### 4) Pausar consumo normal (se necessário)
Desative temporariamente a Function (slot/disable), para evitar consumir enquanto investiga.

### 5) Inspecionar uma mensagem DLQ
```bash
# Use ferramentas (ex.: Service Bus Explorer) ou scripts/SDK para ler uma mensagem DLQ
# Valide cabeçalhos (DeadLetterReason/Description), `correlationId` e payload.
```

### 6) Corrigir causa-raiz
- Ajuste schema/validação no Consolidador ou corrija dados de origem.
- Adicione proteções (try/catch, fallback, *poison message routing*).

### 7) Reprocessar DLQ
Opções:
- **Mover para fila principal (requeue)** via script/SDK.
- **Endpoint admin**: `POST /admin/replay?merchantId=<MID>&data=YYYY-MM-DD` para recomputar.

### 8) Retomar consumo e validar
- Reative a Function e monitore `ActiveMessages` decrescendo e `DLQ` zerando.
- Verifique métricas de erro (p95/p99, 5xx) e RU/s no Cosmos.

## Métricas & Evidências
- Antes/depois do drill: contagem `active/dlq`, backlog, lag, erros.
- Telemetria correlacionada via `correlationId`.
- Tempo total de recuperação (RTO do incidente simulado).

## Critérios de Sucesso
- DLQ reduzido a zero; consolidador estável por ≥30 min.
- Nenhuma regressão de performance (p95/p99) e perda ≤ 5% no pico.
