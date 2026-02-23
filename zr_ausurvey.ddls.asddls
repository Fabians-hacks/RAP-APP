@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZAUSURVEY'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZR_AUSURVEY
  as select from zau_survey
  association to parent ZAU_CDS_OV as _ov on _ov.SurveyId = $projection.surveyid
{
  key question_id as QuestionID,
  text as Text,
  survey_id as surveyid,
  _ov
}
