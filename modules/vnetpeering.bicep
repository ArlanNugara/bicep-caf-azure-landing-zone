
param vnetpeeringdata object

resource vnetpeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-03-01' = {
  name: '${vnetpeeringdata.vNetName}/${vnetpeeringdata.vNetName}-${vnetpeeringdata.peeredwith}'
  properties: {
    allowVirtualNetworkAccess: vnetpeeringdata.allowVirtualNetworkAccess
    allowForwardedTraffic: vnetpeeringdata.allowForwardedTraffic
    allowGatewayTransit: vnetpeeringdata.allowGatewayTransit
    useRemoteGateways: vnetpeeringdata.useRemoteGateways
    remoteVirtualNetwork: {
      id: resourceId(vnetpeeringdata.toRgName, 'Microsoft.Network/virtualNetworks', vnetpeeringdata.peeredwith)
    }
  }
}
