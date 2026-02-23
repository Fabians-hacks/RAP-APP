class ZBP_R_AUPM definition
  public
  abstract
  final
  for behavior of ZR_AUPM .

public section.
CLASS-METHODS writer IMPORTING lt_import type zr_auproposition.
protected section.
private section.
ENDCLASS.



CLASS ZBP_R_AUPM IMPLEMENTATION.
  METHOD writer.


DATA: lt_to_be_written TYPE zr_auproposition.
lt_to_be_written = lt_import.
DATA: id_1 type sysuuid_x16.
id_1 = 'd9c023a0-715c-1fd1-8492-c01e00049573'.
    MODIFY ENTITIES OF zr_aupm
      ENTITY ZrAupm
      CREATE BY \_prop
      FIELDS ( Summary )
      WITH VALUE #(
        ( %key-id = id_1
          %target = VALUE #(
            (  %cid            = 'PROP_CID_1'
            Summary        = lt_to_be_written-Summary
            %control-Summary = if_abap_behv=>mk-on ) )
          )
        )

      FAILED   DATA(lt_failed)
      MAPPED   DATA(lt_mapped)
      REPORTED DATA(lt_reported).


DATA(x) = 2.
  ENDMETHOD.
ENDCLASS.
