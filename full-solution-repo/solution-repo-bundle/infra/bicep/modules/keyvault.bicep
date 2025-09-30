param name string
param env string
param location string

var suffix = '${name}-${env}'

resource kv 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: 'kv-${suffix}'
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: { name: 'standard', family: 'A' }
    enableRbacAuthorization: true
    enabledForDeployment: false
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: false
    publicNetworkAccess: 'Enabled'
  }
}
output keyVaultUri string = kv.properties.vaultUri