param name string
param env string
param location string
param autoscaleMaxThroughputLanc int = 4000
param autoscaleMaxThroughputSaldo int = 2000
@allowed([true, false])
param enablePrivateEndpoint bool = false
// param subnetIdForPrivateEndpoint string

var acc = 'cdb-${name}-${env}'
var dbName = 'finance'

resource account 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: acc
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    consistencyPolicy: { defaultConsistencyLevel: 'Session' }
    locations: [ { locationName: location, failoverPriority: 0 } ]
    enableMultipleWriteLocations: false
    publicNetworkAccess: 'Enabled'
    capabilities: []
  }
}

resource db 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2023-04-15' = {
  name: '${acc}/${dbName}'
  properties: { resource: { id: dbName } }
}

resource cLanc 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  name: '${acc}/${dbName}/lancamentos'
  properties: {
    resource: {
      id: 'lancamentos'
      partitionKey: { paths: ['/merchantId'], kind: 'Hash' }
      indexingPolicy: {
        indexingMode: 'consistent'
        compositeIndexes: [[ { path: '/createdAt', order: 'ascending' }, { path: '/amount', order: 'ascending' } ]]
      }
      defaultTtl: -1
    }
    options: { autoscaleSettings: { maxThroughput: autoscaleMaxThroughputLanc } }
  }
}

resource cSaldo 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  name: '${acc}/${dbName}/saldosDiarios'
  properties: {
    resource: {
      id: 'saldosDiarios'
      partitionKey: { paths: ['/merchantId'], kind: 'Hash' }
      indexingPolicy: { indexingMode: 'consistent' }
      defaultTtl: 604800 // 7 dias
    }
    options: { autoscaleSettings: { maxThroughput: autoscaleMaxThroughputSaldo } }
  }
}

// Private Endpoint placeholder
/*
resource pe 'Microsoft.Network/privateEndpoints@2023-05-01' = if (enablePrivateEndpoint) {
  name: 'pe-cosmos-${name}-${env}'
  location: location
  properties: {
    subnet: { id: subnetIdForPrivateEndpoint }
    privateLinkServiceConnections: [{
      name: 'cdb-conn'
      properties: {
        privateLinkServiceId: account.id
        groupIds: ['Sql']
      }
    }]
  }
}
*/
output cosmosAccountName string = account.name