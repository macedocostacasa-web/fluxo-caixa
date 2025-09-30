param name string
param env string
param location string
@allowed([true, false])
param enablePrivateEndpoint bool = false
// param subnetIdForPrivateEndpoint string

var nsName = 'sb-${name}-${env}'

resource ns 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: nsName
  location: location
  sku: { name: 'Standard', tier: 'Standard' }
  properties: { minimumTlsVersion: '1.2', publicNetworkAccess: 'Enabled' }
}

resource topic 'Microsoft.ServiceBus/namespaces/topics@2022-10-01-preview' = {
  name: '${nsName}/lancamentos'
  properties: {
    defaultMessageTimeToLive: 'P2D'
    enableBatchedOperations: true
    requiresDuplicateDetection: true
    duplicateDetectionHistoryTimeWindow: 'PT24H'
  }
}

resource subs 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = {
  name: '${nsName}/lancamentos/consolidador'
  properties: {
    lockDuration: 'PT1M'
    maxDeliveryCount: 10
    deadLetteringOnMessageExpiration: true
  }
}

// Private Endpoint (placeholder — descomente e passe a subnet no main)
/*
resource pe 'Microsoft.Network/privateEndpoints@2023-05-01' = if (enablePrivateEndpoint) {
  name: 'pe-sb-${name}-${env}'
  location: location
  properties: {
    subnet: { id: subnetIdForPrivateEndpoint }
    privateLinkServiceConnections: [{
      name: 'sb-conn'
      properties: {
        privateLinkServiceId: ns.id
        groupIds: ['namespace']
      }
    }]
  }
}
*/
output serviceBusNamespace string = ns.name