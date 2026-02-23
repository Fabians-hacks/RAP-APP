CLASS lhc_zr_audump DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING request requested_authorizations FOR zraudump
        RESULT result,
      executeoncreate FOR DETERMINE ON SAVE
        IMPORTING keys FOR zraudump~executeoncreate,
      portdatatosurvey FOR MODIFY
            keys FOR ACTION zraudump~portdatatosurvey.
ENDCLASS.

CLASS lhc_zr_audump IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD executeoncreate.

       DATA(lo_struct) = new zau_data_structurer(  ).
       READ ENTITIES OF zr_audump IN LOCAL MODE ENTITY ZrAudump ALL FIELDS WITH CORRESPONDING #( keys ) RESULT DATA(created_entity_l).

       LOOP AT created_entity_l into DATA(i).
       DATA(i_attach) = i-Attachment.
       DATA(i_truth) = i-isCleaned.
       DATA: i_Filename Type string.
       i_filename = i-Filename.

       lo_struct->structurer( lv_data = i-Attachment lv_checkneeded = i_truth lv_filename = i_filename ).



       ENDLOOP.



  ENDMETHOD.

  METHOD portdatatosurvey.
  ENDMETHOD.



ENDCLASS.

