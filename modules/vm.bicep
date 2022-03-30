param vmData object
resource vm 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: vmData.name
  location: resourceGroup().location
  tags:vmData.tags
  properties: {
    hardwareProfile: {
      vmSize: vmData.size
    }
    /*
    securityProfile:{
      encryptionAtHost:true
    }
    */
    storageProfile: {
      osDisk: {
        createOption: vmData.createOption
        managedDisk: {
          storageAccountType: vmData.osDiskType
        }
      }
      imageReference: {
        publisher: vmData.publisher
        offer: vmData.offfer
        sku: vmData.sku
        version: vmData.version
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', vmData.nicName)
        }
      ]
    }
    osProfile: {
      computerName: vmData.computername
      adminUsername: vmData.adminUsername
      adminPassword: vmData.adminPasswordOrKey
    }
  }
}

/*
resource diagonosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview'= {
  name:'${vmData.name}-Diagonostics'
  scope:vm
  properties:{
    storageAccountId:resourceId(vmData.logAnalytics.workspaceRGName,'Microsoft.Storage/storageAccounts',vmData.logAnalytics.logStorageAccountName)
    workspaceId:resourceId(vmData.logAnalytics.workspaceRGName,'Microsoft.OperationalInsights/workspaces',vmData.logAnalytics.logWorkSpaceName)
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
*/
