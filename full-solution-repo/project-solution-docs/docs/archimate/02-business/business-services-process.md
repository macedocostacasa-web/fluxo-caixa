# Viewpoint — Business Process / Service

**Roles**: Operador Caixa, Gestor Loja, Suporte TI  
**Processes**: Registrar Lançamento, Consolidar Dia, Consultar Saldo Diário  
**Services**: Serviço Lançamentos, Serviço Consolidado Diário  
**Contracts**: Política de Estorno, SLA Consulta Saldo

**Relações**
- Operador Caixa executa Registrar Lançamento ⇒ realiza Serviço Lançamentos.
- Processo Consolidar Dia ⇒ realiza Serviço Consolidado Diário (gatilhado por evento).
- Gestor Loja usa Serviço Consolidado Diário (SLA: latência/atualidade).
