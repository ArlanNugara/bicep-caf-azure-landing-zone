param bastionHostData object

resource bastion 'Microsoft.Network/bastionHosts@2021-03-01' = {
  name: bastionHostData.name
  location: resourceGroup().location
  tags:bastionHostData.tags
  properties: {
    ipConfigurations: [
      {
        name: 'bastion-${bastionHostData.name}-ipcfg'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', bastionHostData.ipConfigurations.publicIPAddressName)
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', bastionHostData.ipConfigurations.vnetName, bastionHostData.ipConfigurations.subnetname)
          }
        }
      }
    ]
  }
}

resource diagonosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  name:'${bastionHostData.name}-Diagonostics'
  scope:bastion
  properties:{
    storageAccountId:resourceId(bastionHostData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',bastionHostData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(bastionHostData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',bastionHostData.logAnalytics.logWorkSpaceName)
    logs:[
      {
        category: 'BastionAuditLogs'
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

