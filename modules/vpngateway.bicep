param vpnGatewayData object

resource vpngateway 'Microsoft.Network/virtualNetworkGateways@2021-03-01' = {
  name: vpnGatewayData.name
  location: resourceGroup().location
  tags:vpnGatewayData.tags
  properties: {
    sku: {
      name: vpnGatewayData.skuname
      tier: vpnGatewayData.skutier
    }
    gatewayType: vpnGatewayData.gatewayType
    activeActive: false
    enableBgp:vpnGatewayData.enableBgp
    vpnType: vpnGatewayData.vpnType
    ipConfigurations: [for (ipc, i) in vpnGatewayData.ipConfigurations: {
      name: '${ipc.name}-${i}'
      properties: {
        privateIPAllocationMethod: 'Dynamic'
        publicIPAddress: {
          id: resourceId('Microsoft.Network/publicIPAddresses', ipc.publicIPAddressName)
        }
        subnet: {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', ipc.vnetName, ipc.subnetname)
        }
      }
    }]
  }
}

resource diagonosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  name:'${vpnGatewayData.name}-Diagonostics'
  scope:vpngateway
  properties:{
    storageAccountId:resourceId(vpnGatewayData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',vpnGatewayData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(vpnGatewayData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',vpnGatewayData.logAnalytics.logWorkSpaceName)
    logs:[
      {
        category: 'GatewayDiagnosticLog'
        enabled: true
      }    
      {
        category: 'TunnelDiagnosticLog'
        enabled: true
      } 
      {
        category: 'RouteDiagnosticLog'
        enabled: true
      }   
      {
        category: 'IKEDiagnosticLog'
        enabled: true
      } 
      {
        category: 'P2SDiagnosticLog'
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
