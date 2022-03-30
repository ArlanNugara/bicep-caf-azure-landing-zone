param vnetData object

resource vnet 'Microsoft.Network/virtualNetworks@2021-03-01' = {
  name: vnetData.vNetName
  location: resourceGroup().location
  tags:vnetData.tags
  properties: {
    enableDdosProtection:true
    ddosProtectionPlan:{
      id:resourceId(vnetData.DDoSProtectionRGName,'Microsoft.Network/ddosProtectionPlans',vnetData.DDoSProtectionPlanName)
    }
    addressSpace: {
      addressPrefixes: [
        vnetData.vNetAddressSpace
      ]
    }
    subnets: [for vnetsubnet in vnetData.subnets: {
      name: vnetsubnet.subnetName
      properties: {
        addressPrefix: vnetsubnet.SubnetAddressSpace
        privateEndpointNetworkPolicies:'Disabled'
        networkSecurityGroup: (!empty(vnetsubnet.networkSecurityGroupName) ? {
          id: resourceId('Microsoft.Network/networkSecurityGroups', vnetsubnet.networkSecurityGroupName)
        } : json('null'))
        routeTable: (!empty(vnetsubnet.routeTableName) ? {
          id: resourceId('Microsoft.Network/routeTables', vnetsubnet.routeTableName)
        } : json('null'))
      }
    }]
  }
}

resource diagonosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  name:'${vnetData.vNetName}-Diagonostics'
  scope:vnet
  properties:{
    storageAccountId:resourceId(vnetData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',vnetData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(vnetData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',vnetData.logAnalytics.logWorkSpaceName)
    logs:[
      {
        category: 'VMProtectionAlerts'
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
