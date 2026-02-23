class ZBP_R_AUSURVEY definition
  public
  abstract
  final
  for behavior of ZR_AUSURVEY .
  CLASS-METHODS writer IMPORTING lt_to_be_in TYPE Table.

public section.

protected section.
private section.
ENDCLASS.



CLASS ZBP_R_AUSURVEY IMPLEMENTATION.
Method writer.
DATA lt_input  TYPE TABLE FOR CREATE zr_ausurvey.
 lt_input = lt_to_be_in.
 MODIFY ENTITIES OF ZR_AUSURVEY ENTITY ZrAusurvey CREATE FIELDS ( text ) WITH lt_input
      MAPPED DATA(ls_mapped)
      FAILED DATA(ls_failed)
      REPORTED DATA(ls_reported).


ENDMETHOD.
ENDCLASS.
