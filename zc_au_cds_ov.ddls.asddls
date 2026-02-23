@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: 'Overview CDS base root view of Surveys'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_AU_CDS_OV
  provider contract transactional_query
  as projection on ZAU_CDS_OV
{
  @EndUserText: {
    label: 'UUID', 
    quickInfo: 'Global Unique ID for table'
  }
  key SurveyId,
  filename,
  _survey : redirected to composition child ZC_AUSURVEY
}
