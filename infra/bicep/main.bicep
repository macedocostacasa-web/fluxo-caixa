@description('Nome base do produto, ex.: fin')
param name string

@description('Ambiente (dev|hml|prod)')
param env string = 'dev'

@description('Região Azure, ex.: eastus')
param location string = resourceGroup().location

@description('Habilitar recursos opcionais de rede privada (PE/DNS)?')
param enablePrivateNetwork bool = false

var suffix = '${name}-${env}'

// Módulos principais (rede primeiro)
module network './modules/network.bicep' = {
  name: 'net-${suffix}'
  params: {
    name: name
    env: env
    location: location
    enableDnsZones: enablePrivateNetwork
  }
}

module monitor './modules/monitor.bicep' = {
  name: 'mon-${suffix}'
  params: {
    name: name
    env: env
    location: location
  }
}

module kv './modules/keyvault.bicep' = {
  name: 'kv-${suffix}'
  params: {
    name: name
    env: env
    location: location
  }
}

module servicebus './modules/servicebus.bicep' = {
  name: 'sb-${suffix}'
  params: {
    name: name
    env: env
    location: location
    // subnetIdForPrivateEndpoint: network.outputs.subnetPrivateEndpointsId
    enablePrivateEndpoint: enablePrivateNetwork
  }
}

module cosmos './modules/cosmos.bicep' = {
  name: 'cdb-${suffix}'
  params: {
    name: name
    env: env
    location: location
    autoscaleMaxThroughputLanc: 4000
    autoscaleMaxThroughputSaldo: 2000
    // subnetIdForPrivateEndpoint: network.outputs.subnetPrivateEndpointsId
    enablePrivateEndpoint: enablePrivateNetwork
  }
}

module redis './modules/redis.bicep' = {
  name: 'redis-${suffix}'
  params: {
    name: name
    env: env
    location: location
    sku: 'Basic'
    capacity: 0 // Basic C0
    // subnetIdForPrivateEndpoint: network.outputs.subnetPrivateEndpointsId
    enablePrivateEndpoint: enablePrivateNetwork
  }
}

module storage './modules/storage.bicep' = {
  name: 'stg-${suffix}'
  params: {
    name: name
    env: env
    location: location
    // subnetIdForPrivateEndpoint: network.outputs.subnetPrivateEndpointsId
    enablePrivateEndpoint: enablePrivateNetwork
  }
}

module apim './modules/apim.bicep' = {
  name: 'apim-${suffix}'
  params: {
    name: name
    env: env
    location: location
    publisherEmail: 'owner@example.com'
    publisherName: 'Owner'
    skuName: 'Developer'
  }
}

// Front Door/WAF (placeholder opcional)
module frontdoor './modules/frontdoor-placeholder.bicep' = {
  name: 'fd-${suffix}'
  params: {
    name: name
    env: env
    location: location
  }
}