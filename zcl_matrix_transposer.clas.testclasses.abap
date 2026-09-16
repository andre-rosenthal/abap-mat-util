*"* use this source file for your ABAP unit test classes
CLASS ltc_matrix_transposer DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS transpose_two_by_three FOR TESTING RAISING cx_static_check.
    METHODS transpose_one_by_one FOR TESTING RAISING cx_static_check.
    METHODS transpose_square FOR TESTING RAISING cx_static_check.
    METHODS transpose_column_vector FOR TESTING RAISING cx_static_check.
    METHODS transpose_row_vector FOR TESTING RAISING cx_static_check.
    METHODS transpose_twice_restores FOR TESTING RAISING cx_static_check.
    METHODS transpose_empty FOR TESTING RAISING cx_static_check.
    METHODS transpose_created_fill FOR TESTING RAISING cx_static_check.
    METHODS product_transpose_identity FOR TESTING RAISING cx_static_check.
    METHODS jagged FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_matrix_transposer IMPLEMENTATION.

  METHOD transpose_two_by_three.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lt_t) = zcl_matrix_transposer=>transpose( lt_a ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 4 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 5 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_t
      exp = lt_expected ).
  ENDMETHOD.


  METHOD transpose_one_by_one.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 9 ) ) ) ) ).

    DATA(lt_t) = zcl_matrix_transposer=>transpose( lt_a ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_t
      exp = lt_a ).
  ENDMETHOD.


  METHOD transpose_square.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    DATA(lt_t) = zcl_matrix_transposer=>transpose( lt_a ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_t
      exp = lt_expected ).
  ENDMETHOD.


  METHOD transpose_column_vector.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 10 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 20 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 30 ) ) ) ) ).

    DATA(lt_t) = zcl_matrix_transposer=>transpose( lt_a ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 10 ) ) ( CONV decfloat34( 20 ) ) ( CONV decfloat34( 30 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_t
      exp = lt_expected ).
  ENDMETHOD.


  METHOD transpose_row_vector.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    DATA(lt_t) = zcl_matrix_transposer=>transpose( lt_a ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_t
      exp = lt_expected ).
  ENDMETHOD.


  METHOD transpose_twice_restores.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lt_restored) = zcl_matrix_transposer=>transpose(
      zcl_matrix_transposer=>transpose( lt_a ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_restored
      exp = lt_a ).
  ENDMETHOD.


  METHOD transpose_empty.
    DATA lt_a TYPE zcl_matrix=>ty_matrix.

    DATA(lt_t) = zcl_matrix_transposer=>transpose( lt_a ).

    cl_abap_unit_assert=>assert_initial( lt_t ).
  ENDMETHOD.


  METHOD transpose_created_fill.
    DATA(lt_a) = zcl_matrix=>create(
      iv_rows = 3
      iv_cols = 2
      iv_fill = 7 ).

    DATA(lt_t) = zcl_matrix_transposer=>transpose( lt_a ).
    DATA(ls_shape) = zcl_matrix=>get_shape( lt_t ).

    cl_abap_unit_assert=>assert_equals( act = ls_shape-rows exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = ls_shape-cols exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = lt_t[ 2 ][ 3 ] exp = CONV zcl_matrix=>ty_cell( 7 ) ).
  ENDMETHOD.


  METHOD product_transpose_identity.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 9 ) ) ( CONV decfloat34( 10 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 11 ) ) ( CONV decfloat34( 12 ) ) ) ) ).

    DATA(lt_ab_t) = zcl_matrix_transposer=>transpose(
      zcl_matrix_multiplier=>multiply( it_left = lt_a it_right = lt_b ) ).
    DATA(lt_bt_at) = zcl_matrix_multiplier=>multiply(
      it_left  = zcl_matrix_transposer=>transpose( lt_b )
      it_right = zcl_matrix_transposer=>transpose( lt_a ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_ab_t
      exp = lt_bt_at ).
  ENDMETHOD.


  METHOD jagged.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ) ) ).

    TRY.
        zcl_matrix_transposer=>transpose( lt_a ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
