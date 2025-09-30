# CONTRIBUTING

Obrigado por contribuir! Este guia padroniza **branches**, **ADRs** e **PRs**.

## Fluxo de Branches (GitHub Flow + Releases)
- `main`: sempre **deployável**. Protegida (PR obrigatório, checks verdes).
- `release/x.y.z`: corte de versão estável (opcional). Tags semânticas (`vX.Y.Z`).
- `feat/<slug>`: novas features (ex.: `feat/lancamentos-idempotentes`).
- `fix/<slug>`: correções (ex.: `fix/retry-consolidador`).
- `docs/<slug>`: documentação (ex.: `docs/archimate-tech-deployment`).

**Commits** (Convencional):
```
feat(api): idempotency-key no POST /lancamentos
fix(consolidador): backoff exponencial para 429
docs(archimate): adiciona deployment com private endpoints
```
- Use `BREAKING CHANGE:` no body quando aplicável.
- Mensagens em português ou inglês, seja consistente.

## ADRs (Architecture Decision Records)
- Pasta: `docs/adrs/`
- Template: `docs/adrs/ADR-TEMPLATE.md`
- Convenção de nome: `ADR-XXXX-titulo-kebab-case.md` (ex.: `ADR-0013-geo-replicacao-cosmos.md`)
- Status: `Proposta` → `Aceita` ou `Rejeitada`.
- Cada ADR deve referenciar requisitos/NFRs e impactos em **diagramas/APIs/IaC**.

**Como abrir um ADR novo**
1. Crie a branch `docs/adr-XXXX-<slug>`
2. Copie o template e preencha contexto/decisão/alternativas/consequências
3. Adicione links para PRs/commits/diagramas e referências
4. Abra PR pedindo *Architecture Review*

## Pull Requests
- **Checklist**:
  - [ ] Build & testes verdes (CI)
  - [ ] Atualizou **ADRs** (se houve decisão/alteração de arquitetura)
  - [ ] Atualizou **diagramas ArchiMate** (se impactou arquitetura)
  - [ ] Atualizou **OpenAPI** e **contratos** (se impactou API)
  - [ ] Atualizou **IaC** e **Workflows** (se impactou infraestrutura)
  - [ ] Notas de **FinOps** (se alterou RU/s, tiers, custos)
  - [ ] Logs/telemetria exigidos pelos **SLOs**

- **Labels**: `area:api`, `area:consolidador`, `area:infra`, `docs`, `adr`, `finops`
- **Review**: 2 aprovadores (um de aplicação, um de arquitetura/infra), quando possível

## Versionamento e Releases
- Tag semântica (SemVer): `vMAJOR.MINOR.PATCH`
- CHANGELOG do projeto deve referenciar **ADRs** afetados
- After release: gerar artefatos (diagramas exportados, OpenAPI) no GitHub Pages (opcional)

## Qualidade & Segurança
- Lint e testes unitários obrigatórios
- Testes de **contrato** para APIs (Dredd/Prism)
- Scans de IaC/Dependências (ex.: `tfsec`, `trivy`, `npm audit`)
- Segredos via **Managed Identity/Key Vault** (proibido secret em repo)
