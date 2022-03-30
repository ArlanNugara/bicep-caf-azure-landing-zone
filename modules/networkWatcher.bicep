param networkWatcherData object

resource networkWatcher 'Microsoft.Network/networkWatchers@2021-05-01' = {
  name:'${networkWatcherData.name}-${networkWatcherData.location}'
  location:networkWatcherData.location
  tags:networkWatcherData.tags
  properties:{}
}
