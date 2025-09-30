
@description('Resource Group alvo dos budgets')
param resourceGroupName string

@description('Moeda (ex.: USD, BRL)')
param currency string = 'USD'

@description('Valores por ambiente')
param amountDev int = 200
param amountHml int = 800
param amountProd int = 2000

@description('Dia de ciclo do budget (1-31)')
param startDay int = 1

var scope = resourceGroup(resourceGroupName)

resource budgetDev 'Microsoft.Consumption/budgets@2023-05-01' = {
  name: 'budget-dev'
  scope: scope.id
  properties: {
    category: 'Cost'
    amount: amountDev
    timeGrain: 'Monthly'
    timePeriod: {
      startDate: dateTimeAdd(formatDateTime(utcNow(), 'yyyy-MM-') + string(startDay) + 'T00:00:00Z', 'P0D')
      endDate: dateTimeAdd(formatDateTime(utcNow(), 'yyyy-MM-') + string(startDay) + 'T00:00:00Z', 'P5Y')
    }
    notifications: {
      actual_80: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 80
        contactEmails: [ 'finops@example.com' ]
        locale: 'pt-br'
      }
      forecast_100: {
        enabled: true
        operator: 'GreaterThan'
        threshold: 100
        thresholdType: 'Forecasted'
        contactEmails: [ 'finops@example.com' ]
        locale: 'pt-br'
      }
    }
  }
}

resource budgetHml 'Microsoft.Consumption/budgets@2023-05-01' = {
  name: 'budget-hml'
  scope: scope.id
  properties: budgetDev.properties
}
resource budgetProd 'Microsoft.Consumption/budgets@2023-05-01' = {
  name: 'budget-prod'
  scope: scope.id
  properties: {
    category: 'Cost'
    amount: amountProd
    timeGrain: 'Monthly'
    timePeriod: budgetDev.properties.timePeriod
    notifications: budgetDev.properties.notifications
  }
}
