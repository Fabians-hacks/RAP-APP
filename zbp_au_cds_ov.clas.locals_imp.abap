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
  DATA: lt_relevant Type Table of string.
  TRY.
        DATA(lo_ai_api) = cl_aic_islm_compl_api_factory=>get( )->create_instance( 'ZAU_ISLM' ).
      CATCH cx_aic_api_factory.
        "handle exception
    ENDTRY.
    DATA(lo_message1) = lo_ai_api->create_message_container( ).
       lo_message1->set_system_role(
  'You are a classifier. Analyze the provided customer feedback text and determine ' &&
  'whether it is relevant to a software development backlog (e.g., bug reports, ' &&
  'feature requests, usability issues, or technical complaints). ' &&
  'Respond with exactly one word: "true" if relevant, "false" if not. ' &&
  'No explanation, no punctuation, no additional text.'
).




  READ ENTITIES OF zau_cds_ov IN LOCAL MODE
    ENTITY zau_cds_ov
    BY \_survey
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_children)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

  " 2. Mit den Children arbeiten
  LOOP AT lt_children INTO DATA(ls_child).
    DATA(column) = ls_child-Text.
    lo_message1->add_user_message(  column ).
    DATA(lv_response) = lo_ai_api->execute_for_messages( lo_message1 )->get_completion(  ).
    IF lv_response <> 'false'.
    APPEND column to lt_relevant.
    ENDIF.
    lo_message1->add_user_message( '' ).
  ENDLOOP.
  TYPES: BEGIN OF ty_feedback,
         original_text TYPE string,
         category      TYPE string,
         summary       TYPE string,
       END OF ty_feedback.

DATA: lt_feedback TYPE TABLE OF ty_feedback,
      ls_feedback TYPE ty_feedback.

" Create a second AI message container for detailed analysis
DATA(lo_message2) = lo_ai_api->create_message_container( ).
lo_message2->set_system_role(
  'You are a product owner assistant. Analyze the provided customer feedback and respond ' &&
  'in exactly this format, with no extra text: ' &&
  'CATEGORY: <Bug Report|Feature Request|Usability Issue|Technical Complaint> ' &&
  'SUMMARY: <one concise sentence summarizing the feedback>'
).

" Loop over the already-filtered relevant entries
LOOP AT lt_relevant INTO DATA(lv_relevant_text).
  lo_message2->add_user_message( lv_relevant_text ).
  DATA(lv_analysis) = lo_ai_api->execute_for_messages( lo_message2 )->get_completion( ).

  " Parse the response
  DATA(lv_category) = ||.
  DATA(lv_summary)  = ||.

  FIND PCRE 'CATEGORY:\s*(.+?)\s*SUMMARY:' IN lv_analysis
    SUBMATCHES lv_category.

FIND PCRE 'SUMMARY:\s*(.+)$' IN lv_analysis
    SUBMATCHES lv_summary.


  ls_feedback-original_text = lv_relevant_text.
  ls_feedback-category      = condense( lv_category ).
  ls_feedback-summary       = condense( lv_summary ).
  APPEND ls_feedback TO lt_feedback.
  zbp_r_auproposition=>writer( ls_feedback ).
  " Clear user messages to avoid context bleed between entries
  lo_message2->add_user_message( '' ).
ENDLOOP.

DATA(x) = 2.


  ENDMETHOD.

ENDCLASS.
