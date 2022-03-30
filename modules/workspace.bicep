param workspaceData object

resource workspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: workspaceData.name
  location: resourceGroup().location
  tags:workspaceData.tags
  properties:{
    sku:{
      name:workspaceData.sku
    }
    retentionInDays:workspaceData.retentionInDays
    workspaceCapping:{
      dailyQuotaGb:1
    }
    publicNetworkAccessForIngestion:'Enabled'
    publicNetworkAccessForQuery:'Enabled'
  }
}

resource logAnalyticsWorkspaceDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: workspace
  name: '${workspaceData.name}-diagnosticSettings'
  properties: {
    workspaceId: workspace.id
    logs: [
      {
        category: 'Audit'
        enabled: true
        retentionPolicy: {
          days: 7
          enabled: true
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 7
          enabled: true
        }
      }
    ]
  }
}
