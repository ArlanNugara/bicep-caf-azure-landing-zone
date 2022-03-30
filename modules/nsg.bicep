param nsgData object

resource nsg 'Microsoft.Network/networkSecurityGroups@2021-03-01' = {
  name: nsgData.nsgName
  location: resourceGroup().location
  tags:nsgData.tags
  properties: {
    securityRules: [for (secRule, i) in nsgData.secRules: {
      name: secRule.name
      properties: {
        priority: secRule.priority
        access: secRule.access
        direction: secRule.direction
        protocol: secRule.protocol
        sourcePortRange: secRule.sourcePortRange
        destinationPortRange: secRule.destinationPortRange
        sourceAddressPrefix: secRule.sourceAddressPrefix
        destinationAddressPrefix: secRule.destinationAddressPrefix
      }
    }]
  }
}

/*
resource lockNSG 'Microsoft.Authorization/locks@2020-05-01'= if(false){
  scope:nsg
  name:'${nsgData.nsgName}-lck'
  properties:{
    level:'CanNotDelete'
  }
}
*/

resource diagonosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  scope:nsg
  name:'${nsgData.nsgName}-Diagonostics'
  properties:{
    storageAccountId:resourceId(nsgData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',nsgData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(nsgData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',nsgData.logAnalytics.logWorkSpaceName)
    logs:[
      {
        category: 'NetworkSecurityGroupEvent'
        enabled: true
      }
      {
        category: 'NetworkSecurityGroupRuleCounter'
        enabled: true
      }      
    ]
    metrics: []
  }
}

