@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Overview CDS base root view of Surveys'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZAU_CDS_OV as select from zau_ov_survey
composition [1..*] of ZR_AUSURVEY as _survey 
{
  key survey_id as SurveyId,
  createdby as CreatedBy,
  createdat as CreatedAt,
  filename,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchanged as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchanged as LastChanged,
  _survey // Make association public
}
