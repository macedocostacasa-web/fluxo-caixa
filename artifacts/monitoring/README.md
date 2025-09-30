# Evidências de Observabilidade

Coloque aqui artefatos de execução real para avaliação:

- `workbook-screenshot.png` — print do dashboard com p95, DLQ, RU/s.
- `alert-definition.json` — export de um alerta (ex.: p95>300ms, DLQ>0).
- `loadtest-summary.json` — resumo do Azure Load Testing (k6).

Exemplo de `loadtest-summary.json` esperado:
```json
{
  "testId": "consolidado-50rps",
  "duration": "5m",
  "rps_avg": 50.0,
  "http_req_failed_rate": 0.03,
  "http_req_duration_p95_ms": 240,
  "http_req_duration_p99_ms": 600,
  "timestamp": "2025-09-30T12:00:00Z"
}
```
