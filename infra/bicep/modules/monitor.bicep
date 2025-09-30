param name string
param env string
param location string

var suffix = '${name}-${env}'

resource la 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'law-${suffix}'
  location: location
  properties: { retentionInDays: 30 }
}

resource ai 'Microsoft.Insights/components@2020-02-02' = {
  name: 'appi-${suffix}'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: la.id
  }
}

output logAnalyticsId string = la.id
output appInsightsConnectionString string = ai.properties.ConnectionString