param pipData object

resource pip 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: pipData.name
  location: resourceGroup().location
  tags:pipData.tags
  sku: {
    name: pipData.sku.name
    tier: pipData.sku.tier
  }
  properties: {
    publicIPAllocationMethod: pipData.properties.publicIPAllocationMethod
  }
}

resource diagonosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  name:'${pipData.name}-Diagonostics'
  scope:pip
  properties:{
    storageAccountId:resourceId(pipData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',pipData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(pipData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',pipData.logAnalytics.logWorkSpaceName)
    logs:[
      {
        category: 'DDoSProtectionNotifications'
        enabled: true
      }    
      {
        category: 'DDoSMitigationFlowLogs'
        enabled: true
      } 
      {
        category: 'DDoSMitigationReports'
        enabled: true
      }     
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}
