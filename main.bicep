targetScope = 'subscription'

param resourceArray array
param vpnGatewayConnectionArray array
param vnetPeeringArray array
param DDoSProtectionPlan object

//Create Resource Group
resource rgs 'Microsoft.Resources/resourceGroups@2021-04-01' = [for (res, i) in resourceArray: {
  name: res.rgName
  location: res.rgLocation
  tags: res.tags
}]

//create DDoS Protection Plan for Subscription
module DDoSM 'modules/ddosProtectionPlan.bicep' = {
  name: '${DDoSProtectionPlan.name}-Deployment'
  scope: resourceGroup(DDoSProtectionPlan.rgName)
  dependsOn: [
    rgs
  ]
  params: {
    ddosProtectionPlanData: DDoSProtectionPlan
  }
}

//Create Zone Specific Resources
module reszoneM 'resourcezone.bicep' = [for (res, i) in resourceArray: {
  name: '${res.rgName}-${res.zoneName}-ZoneModule-${i}'
  params: {
    vNetArray: res.vNetArray
    nsgArray: res.nsgArray
    vmArray: res.vmArray
    nicArray: res.nicArray
    pipArray: res.pipArray
    bastionHostArray: res.bastionHostArray
    dbArray: res.dbArray
    appArray: res.appArray
    storageArray: res.storageArray
    firewallArray: res.firewallArray
    routeTableArray: res.routeTableArray
    appGatewayArray: res.appGatewayArray
    rgName: res.rgName
    logAnalyticsWorkspaceArray: res.logAnalyticsWorkspaceArray
    vpnGatewayArray: res.vpnGatewayArray
    logStorageArray: res.logStorageArray
    networkWatcherArray: res.networkWatcherArray
  }
  dependsOn: [
    rgs
    DDoSM
  ]
}]

//Create VNET Peering
module vnetpeeringM 'modules/vnetpeering.bicep' = [for (vnetpeer, i) in vnetPeeringArray: {
  name: '${vnetpeer.fromRgName}-VNETPEERING-Module-${i}'
  scope: resourceGroup(vnetpeer.fromRgName)
  dependsOn: [
    reszoneM
  ]
  params: {
    vnetpeeringdata: vnetpeer
  }
}]

//Create VPN Gateway Connection
module vpnconnM 'modules/connection.bicep' = [for (connData, i) in vpnGatewayConnectionArray: {
  name: '${connData.fromRgName}-VPNGWConn-Module-${i}'
  scope: resourceGroup(connData.fromRgName)
  params: {
    connectionData: connData
  }
  dependsOn: [
    reszoneM
  ]
}]
