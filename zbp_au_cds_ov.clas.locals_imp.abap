CLASS lhc_ZAU_CDS_OV DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zau_cds_ov RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zau_cds_ov RESULT result.
    METHODS analyze_with_ai FOR MODIFY
       keys FOR ACTION zau_cds_ov~analyze_with_ai.

ENDCLASS.

CLASS lhc_ZAU_CDS_OV IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.
  ENDMETHOD.


  METHOD analyze_with_ai.

    DATA: lt_relevant TYPE TABLE OF string.
    TRY.


        DATA(lo_ai_api) = cl_aic_islm_compl_api_factory=>get( )->create_instance( 'ZAU_GPT' ).
        DATA(lo_message1) = lo_ai_api->create_message_container( ).
      CATCH cx_aic_api_factory.
        "handle exception
    ENDTRY.

    READ ENTITIES OF zau_cds_ov IN LOCAL MODE
    ENTITY zau_cds_ov
    BY \_survey
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_children)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    SELECT FROM zr_aupm FIELDS Description, DepName, id INTO TABLE @DATA(lt_des).
    DATA(lv_json) = /ui2/cl_json=>serialize( data = lt_des ).

    lo_message1->set_system_role( 'In the following you will receive a set of Feedback to a Survey. You are a Product Manager, decide if'
    &&' and what is valueable Feedback and what implies an improvement. Return just the Improvement suggestion of the Feedback. dont double yourself and do not make things up. It is not bad if you do not find anything.' ).

    DATA: lt_ai_answer TYPE table of string.
     DATA(lv_answer_json) = /ui2/cl_json=>serialize( data = lt_children ).

        lo_message1->add_user_message( lv_answer_json ).
        DATA(lv_answer_ai) = lo_ai_api->execute_for_messages( lo_message1 )->get_completion(  ).

DATA: ls_giveover TYPE zr_auproposition.

ls_giveover-Summary = lv_answer_ai.
zbp_r_aupm=>writer( ls_giveover ).


    DATA(x) = 2.
  ENDMETHOD.

ENDCLASS.
