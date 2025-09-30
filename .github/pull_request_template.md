# Pull Request — Checklist de Arquitetura & Qualidade

> Preencha os campos abaixo e marque o checklist. Este template reforça nossas práticas de **ADRs**, **ArchiMate**, **SLOs**, **Segurança** e **FinOps**.

## Resumo
Descreva o problema e a solução proposta em 2–3 frases.

## Tipo de mudança
- [ ] `feat` — nova funcionalidade
- [ ] `fix` — correção
- [ ] `docs` — documentação (inclui ADR/diagramas)
- [ ] `refactor` — refatoração sem mudança de comportamento
- [ ] `infra` — IaC/Workflows/Observabilidade
- [ ] `chore` — manutenção

## Impacto em arquitetura
- **ADRs** relacionados/atualizados: <!-- ADR-XXXX, links -->
- **Diagramas ArchiMate** afetados: <!-- arquivos .drawio -->
- **Rationale** resumido: <!-- por que é necessário -->

## API (se aplicável)
- OpenAPI atualizado?  [ ] Sim  [ ] N/A
- Mudança breaking?     [ ] Sim  [ ] Não
- Testes de contrato (Dredd/Prism) rodaram?  [ ] Sim

## Dados & Migrações (se aplicável)
- Esquemas/índices Cosmos alterados?  [ ] Sim  [ ] Não
- Backfill/migração necessária?       [ ] Sim  [ ] Não
- Plano de reversão (rollback)?       <!-- descreva -->

## Observabilidade
- Logs estruturados/correlação (`correlationId`)  [ ] Ok
- Métricas/SLOs afetados (p95, DLQ, RU/s, perda≤5%)  [ ] Ok
- Dashboards/Workbooks atualizados?  [ ] Sim  [ ] N/A
- Alertas necessários (429, DLQ>0, backlog, perda>5%)  [ ] Ok

## Segurança & Compliance
- AutN/AutZ (Entra ID/APIM) afetados?  [ ] Sim  [ ] Não
- Segredos: Key Vault/MI (sem secrets no repo)  [ ] Ok
- Rede privada (PE/VNET) impactada?  [ ] Sim  [ ] Não
- LGPD/retention/TTL/relatórios  [ ] Ok

## FinOps
- Estimativa de custo/uso (RU/s, SB msgs, Redis tier)  [ ] Incluída
- Orçamentos/limites/quotas relevantes  [ ] Ok

## Testes
- Unitários  [ ] Ok
- Integração (Service Bus/Cosmos/Redis)  [ ] Ok
- Contrato (APIs)  [ ] Ok
- Carga (se impacta NFRs)  [ ] N/A  [ ] Executados
- Chaos/Resiliência (opcional)  [ ] N/A  [ ] Executados

## Riscos & Rollback
- Riscos identificados: <!-- latência, hot partition, etc. -->
- Estratégia de rollback/feature flag: <!-- como voltar em segurança -->

## Screenshots/Artefatos (opcional)
Cole imagens ou links (diagramas, dashboards, resultados de teste).

## Issues relacionadas
Closes #..., Relates-to #...

---
**Checklist final**
- [ ] CI verde (build/test/lint)
- [ ] ADR criado/atualizado se houve decisão de arquitetura
- [ ] Diagramas ArchiMate atualizados e exportados
- [ ] OpenAPI/contrato alinhados (se API)
- [ ] IaC/Workflows atualizados (se infra)
- [ ] Segurança/Segredos revisados
- [ ] SLOs/alertas/observabilidade cobertos
- [ ] FinOps considerado
