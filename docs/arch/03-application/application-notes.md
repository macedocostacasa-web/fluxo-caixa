# Notes — Application Layer

**Componentes**: WebSPA, API Lançamentos, Consolidador (Functions), AuthService, Observability  
**Serviços**: Registro Lançamentos, Consulta Consolidado  
**Objetos de Dados**: Lancamento, SaldoDiario

**Padrões**
- Idempotência ponta-a-ponta (Idempotency-Key, correlationId, duplicate detection).
- Event-driven entre API e Consolidador (Service Bus Topic).
- Cache-aside para SaldoDiario (Redis, TTL curto, invalidação por evento).
- Versionamento de API (OpenAPI v1) e testes de contrato.
