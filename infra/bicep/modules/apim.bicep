param name string
param env string
param location string
param publisherEmail string
param publisherName string
@allowed([ 'Consumption', 'Developer', 'Basic', 'Standard', 'Premium' ])
param skuName string = 'Developer'

var apimName = 'apim-${name}-${env}'

resource apim 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: apimName
  location: location
  sku: { name: skuName, capacity: 1 }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

output apimName string = apim.name