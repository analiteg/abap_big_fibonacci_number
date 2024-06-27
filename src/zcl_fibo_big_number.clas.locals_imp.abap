CLASS lcl_string_culc DEFINITION CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS fibo_memo
      IMPORTING !n            TYPE i
      RETURNING VALUE(result) TYPE string.

    METHODS allign_strings
      IMPORTING iv_str_1 TYPE string
                iv_str_2 TYPE string

      EXPORTING ev_str_1 TYPE string
                ev_str_2 TYPE string.

    METHODS sum_strings
      IMPORTING iv_string_1   TYPE string
                iv_string_2   TYPE string

      RETURNING VALUE(rv_str) TYPE string.

  PRIVATE SECTION.
    TYPES:

      BEGIN OF ty_fibo_memo,
        n          TYPE i,
        fibo_value TYPE string,
      END OF ty_fibo_memo.

    DATA lt_fibo_memo TYPE HASHED TABLE OF ty_fibo_memo WITH UNIQUE KEY n.
    DATA lv_buffer       TYPE string.
    DATA lv_number    TYPE i VALUE 0.

ENDCLASS.


CLASS lcl_string_culc IMPLEMENTATION.
  METHOD allign_strings.
    DATA(str_1) = iv_str_1.
    DATA(str_2) = iv_str_2.
    DATA(char_diff) = strlen( str_1 ) - strlen( str_2 ).

    IF char_diff > 0.
      lv_buffer = str_2.
      DO abs( char_diff ) TIMES.
        DATA(str_2_final) = insert( val = lv_buffer
                                    sub = `0` ).
        lv_buffer = str_2_final.
      ENDDO.
    ELSE.
      lv_buffer = str_1.
      DO abs( char_diff ) TIMES.
        DATA(str_1_final) = insert( val = lv_buffer
                                    sub = `0` ).
        lv_buffer = str_1_final.
      ENDDO.
    ENDIF.

    IF str_2_final IS NOT INITIAL.
      ev_str_2 = str_2_final.
    ELSE.
      ev_str_2 = str_2.
    ENDIF.

    IF str_1_final IS NOT INITIAL.
      ev_str_1 = str_1_final.
    ELSE.
      ev_str_1 = str_1.
    ENDIF.
  ENDMETHOD.

  METHOD sum_strings.
    allign_strings( EXPORTING iv_str_1 = iv_string_1
                              iv_str_2 = iv_string_2

                    IMPORTING ev_str_1 = DATA(ev_string_1)
                              ev_str_2 = DATA(ev_string_2) ).

    DATA(lv_length) = strlen( ev_string_1 ) - 1.
    CLEAR lv_buffer.
    TRY.
        WHILE lv_length >= 0.

          DATA(i_1) = CONV i( ev_string_1+lv_length(1) ).
          DATA(i_2) = CONV i( ev_string_2+lv_length(1) ).

          DATA(summ) = i_1 + i_2 + lv_number.

          IF ( summ ) < 10.
            DATA(summ_str) = CONV string( summ ).
            DATA(str_summ) = insert( val = lv_buffer
                                     sub = summ_str ).
            lv_buffer = str_summ.
            lv_number = 0.
          ELSE.

            IF lv_length = 0.
              DATA(summ_str_2) = CONV string( summ ).
              str_summ = insert( val = lv_buffer
                                 sub = summ_str_2 ).
            ELSE.

              DATA(summ_str_3) = CONV string( summ MOD 10 ).

              str_summ = insert( val = lv_buffer
                                 sub = summ_str_3 ).
              lv_buffer = str_summ.
              lv_number = 1.
            ENDIF.
          ENDIF.

          lv_length -= 1.

        ENDWHILE.
      CATCH cx_root INTO DATA(lr_exc). " TODO: variable is assigned but never used (ABAP cleaner)
        str_summ = 'error'.
    ENDTRY.
    str_summ = condense( val  = str_summ
                         from = ` `
                         to   = `` ).
    rv_str = str_summ.
  ENDMETHOD.

  METHOD fibo_memo.
    ASSIGN lt_fibo_memo[ n = n ] TO FIELD-SYMBOL(<fibo_memo>).
    IF sy-subrc = 0.
      result = <fibo_memo>-fibo_value.
      RETURN.
    ENDIF.

    CASE n.
      WHEN 0.
        result = '0'.
      WHEN 1.
        result = '1'.
      WHEN OTHERS.
        result = sum_strings( iv_string_1 = fibo_memo( n - 1 )
                              iv_string_2 = fibo_memo( n - 2 ) ).

    ENDCASE.

    INSERT VALUE #( n          = n
                    fibo_value = result ) INTO TABLE lt_fibo_memo.
  ENDMETHOD.
ENDCLASS.
