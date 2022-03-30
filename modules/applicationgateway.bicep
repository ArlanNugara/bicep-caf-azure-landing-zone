param appGWData object

var appgw_id = resourceId('Microsoft.Network/applicationGateways', appGWData.name)

resource appGW 'Microsoft.Network/applicationGateways@2021-03-01' = {
  name: appGWData.name
  location: resourceGroup().location
  tags:appGWData.tags
  properties: {
    gatewayIPConfigurations: [
      {
        name: 'appgw-ip-config'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', appGWData.gatewayIPConfigurations.vnetName, appGWData.gatewayIPConfigurations.subnetName)
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appgw-public-frontend-ip'
        properties: {
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', appGWData.frontendIPConfigurations.publicIPAddressName)
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'Port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'backend-appService'
        properties: {
          backendAddresses: [
            {
              fqdn: appGWData.backendAddressPools.fqdn
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'HttpSettings'
        properties: {
          port: 80
          protocol: 'Http'
        }
      }
    ]
    httpListeners: [
      {
        name: 'HttpListener'
        properties: {
          frontendIPConfiguration: {
            id: '${appgw_id}/frontendIPConfigurations/appgw-public-frontend-ip'
          }
          frontendPort: {
            id: '${appgw_id}/frontendPorts/Port_80'
          }
          protocol: 'Http'
        }
      }
    ]
    requestRoutingRules: [
      {
        name: 'RoutingRule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${appgw_id}/httpListeners/HttpListener'
          }
          backendAddressPool: {
            id: '${appgw_id}/backendAddressPools/backend-appService'
          }
          backendHttpSettings: {
            id: '${appgw_id}/backendHttpSettingsCollection/HttpSettings'
          }
        }
      }
    ]
    sku: {
      name: appGWData.sku.name
      tier: appGWData.sku.tier
      capacity: appGWData.sku.capacity
    }
  }
}
