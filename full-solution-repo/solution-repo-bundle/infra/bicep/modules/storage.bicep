param name string
param env string
param location string
@allowed([true, false])
param enablePrivateEndpoint bool = false
// param subnetIdForPrivateEndpoint string

var stg = 'st${uniqueString(resourceGroup().id, name, env)}' // nome global

resource sa 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: stg
  location: location
  sku: { name: 'Standard_LRS' }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    publicNetworkAccess: 'Enabled'
  }
}

resource containerReports 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-04-01' = {
  name: '${sa.name}/default/reports'
  properties: { publicAccess: 'None' }
}

// Private Endpoint placeholder
/*
resource pe 'Microsoft.Network/privateEndpoints@2023-05-01' = if (enablePrivateEndpoint) {
  name: 'pe-stg-${name}-${env}'
  location: location
  properties: {
    subnet: { id: subnetIdForPrivateEndpoint }
    privateLinkServiceConnections: [{
      name: 'stg-conn'
      properties: {
        privateLinkServiceId: sa.id
        groupIds: ['blob']
      }
    }]
  }
}
*/
output storageAccountName string = sa.name