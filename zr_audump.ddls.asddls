@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZAUDUMP'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_AUDUMP
  as select from zau_dump
{
  key id as ID,
  @Semantics.largeObject: {
        mimeType: 'Mimetype',
        fileName: 'Filename',
        acceptableMimeTypes: ['*/*'],
        contentDispositionPreference: #ATTACHMENT
      }
  filename as Filename,
  mimetype as Mimetype,
  attachment as Attachment,
  created_by as CreatedBy,
  created_at as CreatedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged,
  is_cleaned as isCleaned
}
