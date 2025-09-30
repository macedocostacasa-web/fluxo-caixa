# ADR-0005 — Segurança de Borda e APIs (Front Door/WAF + APIM + Entra ID + Key Vault)

**Status**: Aceita — 2025-09-30  
**Decisão**  
- **Front Door + WAF** na borda (DDoS, regras)  
- **API Management** com `validate-jwt`, *rate-limit*, validação de schema OpenAPI  
- **Entra ID** (OAuth2/OIDC) para AutN/Z  
- **Key Vault + Managed Identity** para segredos

**Consequências**  
- ✅ Zero Trust e governança central de APIs  
- ⚠️ Custos adicionais e políticas para manter
