CLASS lhc_proposition DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR proposition RESULT result.

    METHODS pushtojira FOR MODIFY
      keys FOR ACTION proposition~pushtojira.

ENDCLASS.

CLASS lhc_proposition IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD pushtojira.
  ENDMETHOD.

ENDCLASS.

CLASS LHC_ZR_AUPM DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrAupm
        RESULT result,
      pushtojira FOR MODIFY
            keys FOR ACTION ZrAupm~pushtojira.
ENDCLASS.

CLASS LHC_ZR_AUPM IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
  METHOD pushtojira.
  ENDMETHOD.

ENDCLASS.
