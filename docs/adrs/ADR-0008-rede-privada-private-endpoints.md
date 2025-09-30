# ADR-0008 — Rede Privada (Private Endpoints & VNET Integration)

**Status**: Aceita — 2025-09-30  
**Decisão**  
- Private Endpoints para **Cosmos, Service Bus, Redis, Blob**  
- **VNET Integration** para App Service/Functions  
- Desabilitar endpoints públicos quando possível

**Consequências**  
- ✅ Reduz superfície de ataque; adequação LGPD/segurança  
- ⚠️ Complexidade de DNS privado e custo de rede
