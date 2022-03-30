param ddosProtectionPlanData object

resource ddosProtectionPlan 'Microsoft.Network/ddosProtectionPlans@2021-05-01' = {
  name:ddosProtectionPlanData.name
  location:ddosProtectionPlanData.location
  tags:ddosProtectionPlanData.tags
  properties:{}
}
