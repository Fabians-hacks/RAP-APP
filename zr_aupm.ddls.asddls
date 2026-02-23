@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZAUPM'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_AUPM
  as select from zau_pm  
  composition [0..*] of ZR_AUPROPOSITION as _prop
  
{
  key id as ID,
  dep_name as DepName,
  description as Description,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  _prop
}
