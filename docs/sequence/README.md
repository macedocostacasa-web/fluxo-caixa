# Diagramas de Sequência (PlantUML)

Geração rápida dos fluxos principais:

- `01-write-flow.puml` — POST /lancamentos (idempotente, evento no SB, consolidação/Redis)
- `02-refund-flow.puml` — Estorno (lançamento compensatório + recalculo)
- `03-read-flow.puml` — GET /consolidado (cache-aside Redis → Cosmos)

Para visualizar localmente:
```bash
# usando Docker (exemplo)
docker run --rm -v $(pwd):/workspace plantuml/plantuml -tpng docs/sequence/*.puml

# ou gerar SVG
docker run --rm -v $(pwd):/workspace plantuml/plantuml -tsvg docs/sequence/*.puml
```
