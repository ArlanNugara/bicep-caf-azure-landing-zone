param routeTableData object

resource routetable 'Microsoft.Network/routeTables@2021-03-01' = {
  name: routeTableData.routeTableName
  location: resourceGroup().location
  tags:routeTableData.tags
  properties: {
    disableBgpRoutePropagation: false
    routes: routeTableData.routes
  }
}

output routeTableId string = routetable.id
