CLASS zbp_c_au_cds_ov DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zc_au_cds_ov.
  PUBLIC SECTION.
TYPES: BEGIN OF passtype,
             text TYPE string,
           END OF passtype.
    TYPES tt_passtype TYPE TABLE OF passtype WITH EMPTY KEY.
    CLASS-METHODS writer IMPORTING lt_to_be_in TYPE tt_passtype lv_filename type string.
  PRIVATE SECTION.


ENDCLASS.


CLASS zbp_c_au_cds_ov IMPLEMENTATION.
  METHOD writer.
    MODIFY ENTITIES OF zau_cds_ov         " konsistenter Name
         ENTITY zau_cds_ov
         CREATE
         FIELDS ( filename )
         WITH VALUE #(
           ( %cid = 'CID_PARENT_1'
           filename = lv_filename
           )
         )

         ENTITY zau_cds_ov
         CREATE BY \_survey
         FIELDS ( Text )
         WITH VALUE #(
           ( %cid_ref = 'CID_PARENT_1'
             %target  = VALUE #(
               FOR lv_idx = 1 THEN lv_idx + 1
               UNTIL lv_idx > lines( lt_to_be_in )
               LET ls_input = lt_to_be_in[ lv_idx ] IN
               ( %cid     = |CID_CHILD_{ lv_idx }|
                 Text     = ls_input-text
                 %control = VALUE #( Text = if_abap_behv=>mk-on )
               )
             )
           )
         )

         MAPPED   DATA(ls_mapped)
         FAILED   DATA(ls_failed)
         REPORTED DATA(ls_reported).
  ENDMETHOD.
ENDCLASS.
