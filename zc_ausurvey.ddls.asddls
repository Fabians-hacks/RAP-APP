@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZAUSURVEY'
}
@AccessControl.authorizationCheck: #MANDATORY
define view entity ZC_AUSURVEY
  as projection on ZR_AUSURVEY
{
  @UI.lineItem: [{ position: 10 }]
  @UI.identification: [{ position: 10 }]
  key QuestionID,

  @UI.lineItem: [{ position: 20 }]
  @UI.identification: [{ position: 20 }]
  Text,

  @UI.lineItem: [{ position: 30 }]
  @UI.identification: [{ position: 30 }]
  surveyid,
  _ov : redirected to parent ZC_AU_CDS_OV
}
