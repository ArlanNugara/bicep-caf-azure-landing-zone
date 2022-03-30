param storageAccountData object

resource storageacc 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountData.name
  location: resourceGroup().location
  tags:storageAccountData.tags
  kind: storageAccountData.kind 
  sku: {
    name: storageAccountData.skuname
  }
  properties: {
    accessTier: storageAccountData.accessTier
    networkAcls:{
      defaultAction:'Deny'
    }
  }
}


resource diagonosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  name:'${storageAccountData.name}-Diagonostics'
  scope:storageacc
  properties:{
    storageAccountId:resourceId(storageAccountData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',storageAccountData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(storageAccountData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',storageAccountData.logAnalytics.logWorkSpaceName)
    logs:[]
    metrics: [
      {
        category: 'Transaction'
        enabled: true
      }
    ]
  }
}

/*
{
        category:'StorageRead'
        enabled:true
      }
      {
        category:'StorageWrite'
        enabled:true
      }
      {
        category:'StorageDelete'
        enabled:true
      }
      */
