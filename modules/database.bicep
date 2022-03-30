param databaseData object

resource sqlServer 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: databaseData.sqlServer.name
  location: resourceGroup().location
  tags:databaseData.sqlServer.tags
  properties: {
    publicNetworkAccess:'Disabled'
    minimalTlsVersion:databaseData.sqlServer.properties.minimalTlsVersion
    administratorLogin: databaseData.sqlServer.properties.administratorLoginId
    administratorLoginPassword: databaseData.sqlServer.properties.administratorLoginPassword
  }
  /*
  resource fwRule 'firewallRules@2021-05-01-preview' = {
    name: databaseData.firewallRules.name
    properties: {
      startIpAddress: databaseData.firewallRules.startIpAddress
      endIpAddress: databaseData.firewallRules.endIpAddress
    }
  }
  */
}

resource db 'Microsoft.Sql/servers/databases@2021-05-01-preview' = {
  parent: sqlServer
  name: databaseData.name
  location: resourceGroup().location
  tags:databaseData.tags
  properties: {
    //collation: databaseData.properties.collation
    //requestedBackupStorageRedundancy: databaseData.properties.requestedBackupStorageRedundancy
  }
}

resource privateEndPoint 'Microsoft.Network/privateEndpoints@2021-05-01'={
  name:'${databaseData.sqlServer.name}-PvtEndPoint'
  location:resourceGroup().location
  tags:databaseData.sqlServer.tags
  properties:{
    subnet:{
      id:resourceId('Microsoft.Network/virtualNetworks/subnets',databaseData.sqlServer.privateEndpointVnetName,databaseData.sqlServer.privateEndpointSubnetName)
    }
    privateLinkServiceConnections:[
      {
      name:'${databaseData.sqlServer.name}-PvtEndPoint-SQL'
      properties:{
        privateLinkServiceId:sqlServer.id
        groupIds:[
          'sqlServer'
        ]
      }
    }
  ]
  }
}


resource privateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name:'${databaseData.sqlServer.name}${environment().suffixes.sqlServerHostname}'
  //name:concat(databaseData.sqlServer.name,environment().suffixes.sqlServerHostname)
  location:'global'
  tags:databaseData.sqlServer.tags
  properties:{}
}

resource privateDNSVNetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name:'${privateDNSZone.name}/${privateDNSZone.name}-link'
  location:'global'
  tags:databaseData.sqlServer.tags
  properties:{
    registrationEnabled:false
    virtualNetwork:{
      id:resourceId('Microsoft.Network/virtualNetworks',databaseData.sqlServer.privateEndpointVnetName)
    }
  }
}

resource privateDNSZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name:'${privateEndPoint.name}/PvtDNSZoneGroup'
  properties:{
    privateDnsZoneConfigs:[
      {
        name:'${databaseData.sqlServer.name}-PrivateDNSConfig'
        properties:{
          privateDnsZoneId:privateDNSZone.id
        }
      }
    ]
  }
}

resource diagonosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  name:'${databaseData.name}-Diagonostics'
  scope:db
  properties:{
    storageAccountId:resourceId(databaseData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',databaseData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(databaseData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',databaseData.logAnalytics.logWorkSpaceName)
    logs:[
      {
        category: 'SQLInsights'
        enabled: true
      }    
      {
        category: 'AutomaticTuning'
        enabled: true
      } 
      {
        category: 'QueryStoreRuntimeStatistics'
        enabled: true
      }   
      {
        category: 'QueryStoreWaitStatistics'
        enabled: true
      } 
      {
        category: 'Errors'
        enabled: true
      } 
      {
        category: 'DatabaseWaitStatistics'
        enabled: true
      }
      {
        category: 'Timeouts'
        enabled: true
      }
      {
        category: 'Blocks'
        enabled: true
      }
      {
        category: 'Deadlocks'
        enabled: true
      }
      {
        category: 'DevOpsOperationsAudit'
        enabled: true
      }
      {
        category: 'SQLSecurityAuditEvents'
        enabled: true
      }  
    ]
    metrics: [
      {
        category: 'Basic'
        enabled: true
      }
      {
        category: 'InstanceAndAppAdvanced'
        enabled: true
      }
      {
        category: 'WorkloadManagement'
        enabled: true
      }
    ]
  }
}

/*
resource diagonosticSettingsSqlServer 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  name:'${databaseData.sqlServer.name}-Diagonostics'
  scope:sqlServer
  properties:{
    storageAccountId:resourceId(databaseData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',databaseData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(databaseData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',databaseData.logAnalytics.logWorkSpaceName)
    logs:[
      {
        category: 'SQLInsights'
        enabled: true
      }    
      {
        category: 'AutomaticTuning'
        enabled: true
      } 
      {
        category: 'QueryStoreRuntimeStatistics'
        enabled: true
      }   
      {
        category: 'QueryStoreWaitStatistics'
        enabled: true
      } 
      {
        category: 'Errors'
        enabled: true
      } 
      {
        category: 'DatabaseWaitStatistics'
        enabled: true
      }
      {
        category: 'Timeouts'
        enabled: true
      }
      {
        category: 'Blocks'
        enabled: true
      }
      {
        category: 'Deadlocks'
        enabled: true
      }
      {
        category: 'DevOpsOperationsAudit'
        enabled: true
      }
      {
        category: 'SQLSecurityAuditEvents'
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
*/

/*
resource privateEndPointConnection 'Microsoft.Sql/servers/privateEndpointConnections@2021-05-01-preview'={
  name: '${databaseData.sqlServer.name}-PrivateEPC'
  parent:sqlServer
  properties:{
    privateEndpoint:{
      id:privateEndPoint.id
    }
    privateLinkServiceConnectionState:{
      description:'Private Link Connection'
      status:'Approved'
    }
  }
}
*/

