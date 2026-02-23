class ZBP_R_AUPROPOSITION definition
  public
  abstract
  final
  for behavior of ZR_AUPROPOSITION .

public section.
TYPES: BEGIN OF ty_feedback,
         original_text TYPE string,
         category      TYPE string,
         summary       TYPE string,
       END OF ty_feedback.
CLASS-METHODS writer IMPORTING ls_feedback Type ty_feedback.
protected section.
private section.

ENDCLASS.



CLASS ZBP_R_AUPROPOSITION IMPLEMENTATION.
METHOD writer.
 DATA: lt_create TYPE TABLE FOR CREATE ZR_AUPROPOSITION,
        ls_create LIKE LINE OF lt_create.

  ls_create-%cid         = '1'.
  ls_create-OriginalText = ls_feedback-original_text.
  ls_create-Category     = ls_feedback-category.
  ls_create-Summary      = ls_feedback-summary.
  APPEND ls_create TO lt_create.

  MODIFY ENTITIES OF ZR_AUPROPOSITION IN LOCAL MODE
    ENTITY ZrAuproposition
    CREATE FIELDS ( OriginalText Summary Category )
    WITH lt_create
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).
ENDMETHOD.


ENDCLASS.
