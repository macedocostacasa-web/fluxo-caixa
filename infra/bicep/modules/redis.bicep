param name string
param env string
param location string
@allowed([ 'Basic', 'Standard', 'Premium' ])
param sku string = 'Basic'
param capacity int = 0 // C0 para Basic/Standard
@allowed([true, false])
param enablePrivateEndpoint bool = false
// param subnetIdForPrivateEndpoint string

var cacheName = 'redis-${name}-${env}'

resource cache 'Microsoft.Cache/redis@2023-04-01' = {
  name: cacheName
  location: location
  properties: {
    sku: { name: sku, family: (sku == 'Premium' ? 'P' : 'C'), capacity: capacity }
    enableNonSslPort: false
  }
}

// Private Endpoint placeholder
/*
resource pe 'Microsoft.Network/privateEndpoints@2023-05-01' = if (enablePrivateEndpoint) {
  name: 'pe-redis-${name}-${env}'
  location: location
  properties: {
    subnet: { id: subnetIdForPrivateEndpoint }
    privateLinkServiceConnections: [{
      name: 'redis-conn'
      properties: {
        privateLinkServiceId: cache.id
        groupIds: ['redisCache']
      }
    }]
  }
}
*/