param appServiceData object

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServiceData.appServicePlanName
  location: resourceGroup().location
  tags:appServiceData.tags
  sku: {
    name: appServiceData.skuName
    capacity: appServiceData.skuCapacity
  }
  kind: 'linux'
}
resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceData.name
  location: resourceGroup().location
  tags:appServiceData.tags
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      //linuxFxVersion: appServiceData.siteConfig.linuxFxVersion //DOTNETCORE|3.0
      /*
      connectionStrings: [
        {
          name: appServiceData.connectionName
          connectionString: ''
          type: 'SQLAzure'
        }
      ]
      */
    }
  }
}
