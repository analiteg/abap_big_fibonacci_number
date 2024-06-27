CLASS zcl_fibo_big_number DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_fibo_big_number IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA(ro_instance) = NEW lcl_string_culc( ).
    DATA(fibo_number) = ro_instance->fibo_memo( 30000 ).
    out->write( fibo_number ).
    out->write( strlen( fibo_number ) ).
  ENDMETHOD.
ENDCLASS.
