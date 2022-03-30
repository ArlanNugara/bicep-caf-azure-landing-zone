param nicData object

resource nic 'Microsoft.Network/networkInterfaces@2021-03-01' = {
  name: nicData.name
  location: resourceGroup().location
  tags:nicData.tags
  properties: {
    ipConfigurations: [
      {
        name: nicData.ipConfigurations.name
        properties: {
          subnet: {
            id: '${resourceId('Microsoft.Network/virtualNetworks', nicData.ipConfigurations.vnetName)}/subnets/${nicData.ipConfigurations.subnetName}'
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', nicData.ipConfigurations.publicIPAddressName)
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', nicData.nsgName)
    }
  }
}

resource diagonosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  name:'${nicData.name}-Diagonostics'
  scope:nic
  properties:{
    storageAccountId:resourceId(nicData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',nicData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(nicData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',nicData.logAnalytics.logWorkSpaceName)
    logs:[]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}
