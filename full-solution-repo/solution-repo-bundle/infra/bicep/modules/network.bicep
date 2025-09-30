@description('Nome base do produto')
param name string

@description('Ambiente (dev|hml|prod)')
param env string

@description('Região Azure')
param location string

@description('Criar Private DNS Zones padrão para Cosmos/SB/Redis/Blob?')
param enableDnsZones bool = false

var vnetName = 'vnet-${name}-${env}'
var snetApp = 'snet-app'
var snetFunc = 'snet-func'
var snetPE = 'snet-pe'

resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: { addressPrefixes: [ '10.10.0.0/16' ] }
    subnets: [
      { name: snetApp,  properties: { addressPrefix: '10.10.1.0/24' } }
      { name: snetFunc, properties: { addressPrefix: '10.10.2.0/24' } }
      { name: snetPE,   properties: { addressPrefix: '10.10.10.0/24' } }
    ]
  }
}

@description('Subnet para Private Endpoints')
output subnetPrivateEndpointsId string = vnet.properties.subnets[2].id

// (Opcional) Private DNS Zones — criadas aqui para vínculo único à VNET
resource pdzCosmos 'Microsoft.Network/privateDnsZones@2020-06-01' = if (enableDnsZones) {
  name: 'privatelink.documents.azure.com'
  location: 'global'
}
resource pdzSb 'Microsoft.Network/privateDnsZones@2020-06-01' = if (enableDnsZones) {
  name: 'privatelink.servicebus.windows.net'
  location: 'global'
}
resource pdzRedis 'Microsoft.Network/privateDnsZones@2020-06-01' = if (enableDnsZones) {
  name: 'privatelink.redis.cache.windows.net'
  location: 'global'
}
resource pdzBlob 'Microsoft.Network/privateDnsZones@2020-06-01' = if (enableDnsZones) {
  name: 'privatelink.blob.core.windows.net'
  location: 'global'
}

resource linkCosmos 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (enableDnsZones) {
  name: 'privatelink.documents.azure.com/${vnetName}-link'
  location: 'global'
  properties: { virtualNetwork: { id: vnet.id }, registrationEnabled: false }
}
resource linkSb 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (enableDnsZones) {
  name: 'privatelink.servicebus.windows.net/${vnetName}-link'
  location: 'global'
  properties: { virtualNetwork: { id: vnet.id }, registrationEnabled: false }
}
resource linkRedis 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (enableDnsZones) {
  name: 'privatelink.redis.cache.windows.net/${vnetName}-link'
  location: 'global'
  properties: { virtualNetwork: { id: vnet.id }, registrationEnabled: false }
}
resource linkBlob 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (enableDnsZones) {
  name: 'privatelink.blob.core.windows.net/${vnetName}-link'
  location: 'global'
  properties: { virtualNetwork: { id: vnet.id }, registrationEnabled: false }
}