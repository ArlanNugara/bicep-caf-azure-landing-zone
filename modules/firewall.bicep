param firewallData object

resource firewall 'Microsoft.Network/azureFirewalls@2021-03-01' = {
  name: firewallData.name
  location: resourceGroup().location
  tags:firewallData.tags
  properties: {
    applicationRuleCollections: [for apprule in firewallData.applicationRuleCollections: {
      name: apprule.name
      properties: {
        priority: apprule.priority
        action: {
          type: apprule.action
        }
        rules: apprule.rules
      }
    }]
    ipConfigurations: [for appipconfig in firewallData.ipConfigurations: {
      name: appipconfig.name
      properties: {
        publicIPAddress: {
          id: resourceId('Microsoft.Network/publicIPAddresses', appipconfig.publicIPAddressName)
        }
        subnet: {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', appipconfig.vnetName, appipconfig.subnetName)
        }
      }
    }]
  }
}

resource diagonosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  name:'${firewallData.name}-Diagonostics'
  scope:firewall
  properties:{
    storageAccountId:resourceId(firewallData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',firewallData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(firewallData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',firewallData.logAnalytics.logWorkSpaceName)
    logs:[
      {
        category: 'AzureFirewallApplicationRule'
        enabled: true
      }
      {
        category: 'AzureFirewallNetworkRule'
        enabled: true
      }
      {
        category: 'AzureFirewallDnsProxy'
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
