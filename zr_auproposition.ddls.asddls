@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZAUPROPOSITION'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_AUPROPOSITION
  as select from ZAU_PROPOSITION
{
  key uuid as UUID,
  original_text as OriginalText,
  category as Category,
  summary as Summary,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.lastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
}
