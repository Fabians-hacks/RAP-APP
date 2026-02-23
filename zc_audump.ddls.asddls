@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Add new Survey'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZAUDUMP'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_AUDUMP
  provider contract transactional_query
  as projection on ZR_AUDUMP
{
  key ID,
  
  Filename,
  Mimetype,
  @Semantics.largeObject: {
        mimeType: 'Mimetype',
        fileName: 'Filename',
        acceptableMimeTypes: ['*/*'],
        contentDispositionPreference: #ATTACHMENT
      }
  Attachment,
  @UI.hidden : true
  CreatedBy,
  @UI.hidden : true
  CreatedAt,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  @UI.hidden : true
  LocalLastChanged,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  @UI.hidden : true
  LastChanged, 
   @UI: {
    lineItem: [{ position: 100 }],
    fieldGroup: [{ qualifier: 'CreateGroup', position: 50 }],
    identification: [{ position: 50 }]
  }
 @EndUserText.label: 'Only Free Text Columns selected'
  isCleaned 
}
