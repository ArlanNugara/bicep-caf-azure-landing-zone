param connectionData object

resource conn 'Microsoft.Network/connections@2021-03-01' = {
  name:connectionData.name
  location:resourceGroup().location
  tags:connectionData.tags
  properties:{
    virtualNetworkGateway1:{
      properties:{}
      id:resourceId('Microsoft.Network/virtualNetworkGateways',connectionData.sourceVpnGatewayName)
    }
    virtualNetworkGateway2:{
      properties:{}
      id:resourceId(connectionData.toRgName,'Microsoft.Network/virtualNetworkGateways',connectionData.targetVpnGatewayName)
    }
    connectionType:connectionData.connectionType
    routingWeight:3
    sharedKey:connectionData.sharedKey
  }
}
