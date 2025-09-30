# Consumo de Serviços — Checklist de Integração (Cliente)

## Autenticação/Autorização
- [ ] Fluxo **client credentials** (OIDC/Entra ID) configurado
- [ ] `scope`: `api.read` (read), `api.readwrite` (write), `api.admin` (admin)
- [ ] JWT enviado em `Authorization: Bearer <token>` (HTTPS)

## Resiliência e Cotas
- [ ] **Retry** com *exponential backoff + jitter* para 429/5xx
- [ ] **Idempotency-Key** no `POST /lancamentos`
- [ ] Respeito a **rate-limit** do APIM (HTTP 429) e **retry-after**

## Observabilidade
- [ ] Envio/propagação de `x-correlation-id`
- [ ] Logs estruturados no cliente para *traceability* básica
- [ ] Métricas de sucesso/latência do cliente

## Contratos e Schemas
- [ ] OpenAPI **v1** consumido (schemas válidos)
- [ ] Tamanho máximo de payload respeitado (ex.: 1 MB)
- [ ] Charset/locale normalizado (UTF-8; ISO timestamps)

## Segurança de Dados
- [ ] Sem PII desnecessária; mascarar campos sensíveis em logs
- [ ] TLS 1.2+; validação de hostname
- [ ] Rotação das credenciais (se houver) e armazenamento seguro

## Testes
- [ ] Teste contra **Prism** (mock) passando nos contratos
- [ ] Teste de carga básico no seu cliente (sanidade)

**Anexos**: exemplos de requests/responses, códigos de erro esperados, políticas do APIM.
