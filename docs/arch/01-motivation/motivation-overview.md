# Viewpoint — Motivation

**Elementos**
- Stakeholders: Comerciante, GestorLoja, EquipeTI, Segurança, FinOps
- Drivers: Confiabilidade, Baixa Latência, Custos Controlados, LGPD
- Goals: Saldo Diário Confiável, Alta Disponibilidade, Custo Elástico
- Outcomes: Redução de Retrabalho, Decisões Rápidas de Caixa
- Requirements: Registrar Lançamento Idempotente; Consolidar por Dia/Loja; Pico 50 rps (perda ≤ 5%); Lag médio ≤ 10s
- Constraints: Prazo MVP; Budget Fixo; Padrões Azure
- Principles: Event-first; Zero Trust; Observabilidade guiada por SLO

**Relações**
Drivers → Goals → Outcomes; Requirements realizam Goals; Principles e Constraints restringem as soluções.
