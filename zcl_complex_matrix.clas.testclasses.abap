*"* use this source file for your ABAP unit test classes
CLASS ltc_complex_matrix DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS add_two_by_two FOR TESTING RAISING cx_static_check.
    METHODS subtract_two_by_two FOR TESTING RAISING cx_static_check.
    METHODS multiply_with_i FOR TESTING RAISING cx_static_check.
    METHODS scale_by_i FOR TESTING RAISING cx_static_check.
    METHODS transpose_two_by_three FOR TESTING RAISING cx_static_check.
    METHODS divide_by_identity FOR TESTING RAISING cx_static_check.
    METHODS divide_self_is_identity FOR TESTING RAISING cx_static_check.
    METHODS multiply_then_divide_restores FOR TESTING RAISING cx_static_check.
    METHODS mismatch_add FOR TESTING RAISING cx_static_check.
    METHODS mismatch_multiply FOR TESTING RAISING cx_static_check.
    METHODS singular_divide FOR TESTING RAISING cx_static_check.
    METHODS jagged FOR TESTING RAISING cx_static_check.

    METHODS c
      IMPORTING
        iv_re          TYPE decfloat34
        iv_im          TYPE decfloat34 DEFAULT 0
      RETURNING
        VALUE(rs_cell) TYPE zcl_complex=>ty_complex.

    METHODS expect_error
      IMPORTING
        it_left  TYPE zcl_complex_matrix=>ty_matrix OPTIONAL
        it_right TYPE zcl_complex_matrix=>ty_matrix OPTIONAL
        iv_op    TYPE string.
ENDCLASS.


CLASS ltc_complex_matrix IMPLEMENTATION.

  METHOD add_two_by_two.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 iv_im = 1 ) ) ( c( iv_re = 2 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 3 ) ) ( c( iv_re = 4 iv_im = -1 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 0 iv_im = 1 ) ) ( c( iv_re = 1 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 0 iv_im = 1 ) ) ) ) ).

    DATA(lt_sum) = zcl_complex_matrix=>add( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 1 ][ 1 ]-re exp = CONV decfloat34( 1 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 1 ][ 1 ]-im exp = CONV decfloat34( 2 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 2 ][ 2 ]-re exp = CONV decfloat34( 4 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 2 ][ 2 ]-im exp = CONV decfloat34( 0 ) ).
  ENDMETHOD.


  METHOD subtract_two_by_two.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 iv_im = 1 ) ) ( c( iv_re = 2 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 3 ) ) ( c( iv_re = 4 iv_im = -1 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 0 iv_im = 2 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 0 iv_im = 1 ) ) ( c( iv_re = 1 ) ) ) ) ).

    DATA(lt_diff) = zcl_complex_matrix=>subtract( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 1 ][ 1 ]-re exp = CONV decfloat34( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 1 ][ 1 ]-im exp = CONV decfloat34( 1 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 1 ][ 2 ]-re exp = CONV decfloat34( 2 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 1 ][ 2 ]-im exp = CONV decfloat34( -2 ) ).
  ENDMETHOD.


  METHOD multiply_with_i.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 0 iv_im = 1 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 0 ) ) ( c( iv_re = 1 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 0 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 0 iv_im = 1 ) ) ( c( iv_re = 1 ) ) ) ) ).

    DATA(lt_p) = zcl_complex_matrix=>multiply( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals( act = lt_p[ 1 ][ 1 ]-re exp = CONV decfloat34( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_p[ 1 ][ 1 ]-im exp = CONV decfloat34( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_p[ 1 ][ 2 ]-re exp = CONV decfloat34( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_p[ 1 ][ 2 ]-im exp = CONV decfloat34( 1 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_p[ 2 ][ 1 ]-re exp = CONV decfloat34( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_p[ 2 ][ 1 ]-im exp = CONV decfloat34( 1 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_p[ 2 ][ 2 ]-re exp = CONV decfloat34( 1 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_p[ 2 ][ 2 ]-im exp = CONV decfloat34( 0 ) ).
  ENDMETHOD.


  METHOD scale_by_i.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 0 iv_im = 1 ) ) ) ) ).

    DATA(lt_scaled) = zcl_complex_matrix=>scale(
      it_matrix = lt_a
      is_scalar = c( iv_re = 0 iv_im = 1 ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 1 ][ 1 ]-re exp = CONV decfloat34( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 1 ][ 1 ]-im exp = CONV decfloat34( 1 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 1 ][ 2 ]-re exp = CONV decfloat34( -1 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 1 ][ 2 ]-im exp = CONV decfloat34( 0 ) ).
  ENDMETHOD.


  METHOD transpose_two_by_three.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 iv_im = 1 ) ) ( c( iv_re = 2 ) ) ( c( iv_re = 3 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 4 ) ) ( c( iv_re = 5 iv_im = -1 ) ) ( c( iv_re = 6 ) ) ) ) ).

    DATA(lt_t) = zcl_complex_matrix=>transpose( lt_a ).
    DATA(ls_shape) = zcl_complex_matrix=>get_shape( lt_t ).

    cl_abap_unit_assert=>assert_equals( act = ls_shape-rows exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = ls_shape-cols exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = lt_t[ 2 ][ 2 ]-re exp = CONV decfloat34( 5 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_t[ 2 ][ 2 ]-im exp = CONV decfloat34( -1 ) ).
  ENDMETHOD.


  METHOD divide_by_identity.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 iv_im = 2 ) ) ( c( iv_re = 3 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 4 ) ) ( c( iv_re = 5 iv_im = -1 ) ) ) ) ).

    DATA(lt_q) = zcl_complex_matrix=>divide(
      it_left  = lt_a
      it_right = zcl_complex_matrix=>identity( 2 ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_q exp = lt_a ).
  ENDMETHOD.


  METHOD divide_self_is_identity.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 iv_im = 1 ) ) ( c( iv_re = 0 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 0 ) ) ( c( iv_re = 1 iv_im = -1 ) ) ) ) ).

    DATA(lt_q) = zcl_complex_matrix=>divide( it_left = lt_a it_right = lt_a ).

    cl_abap_unit_assert=>assert_equals( act = lt_q exp = zcl_complex_matrix=>identity( 2 ) ).
  ENDMETHOD.


  METHOD multiply_then_divide_restores.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 iv_im = 1 ) ) ( c( iv_re = 2 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 0 iv_im = 1 ) ) ( c( iv_re = 1 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 0 iv_im = 1 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 0 ) ) ( c( iv_re = 2 ) ) ) ) ).

    DATA(lt_product) = zcl_complex_matrix=>multiply( it_left = lt_a it_right = lt_b ).
    DATA(lt_restored) = zcl_complex_matrix=>divide( it_left = lt_product it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals( act = lt_restored exp = lt_a ).
  ENDMETHOD.


  METHOD mismatch_add.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 2 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b iv_op = 'add' ).
  ENDMETHOD.


  METHOD mismatch_multiply.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 2 ) ) ( c( iv_re = 3 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 0 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 0 ) ) ( c( iv_re = 1 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b iv_op = 'multiply' ).
  ENDMETHOD.


  METHOD singular_divide.
    DATA(lt_a) = zcl_complex_matrix=>identity( 2 ).
    DATA(lt_b) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 2 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 2 ) ) ( c( iv_re = 4 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b iv_op = 'divide' ).
  ENDMETHOD.


  METHOD jagged.
    DATA(lt_a) = VALUE zcl_complex_matrix=>ty_matrix(
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 1 ) ) ( c( iv_re = 2 ) ) ) )
      ( VALUE zcl_complex_matrix=>ty_row( ( c( iv_re = 3 ) ) ) ) ).

    TRY.
        zcl_complex_matrix=>transpose( lt_a ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD c.
    rs_cell = zcl_complex_matrix=>cell( iv_re = iv_re iv_im = iv_im ).
  ENDMETHOD.


  METHOD expect_error.
    TRY.
        CASE iv_op.
          WHEN 'add'.
            zcl_complex_matrix=>add( it_left = it_left it_right = it_right ).
          WHEN 'multiply'.
            zcl_complex_matrix=>multiply( it_left = it_left it_right = it_right ).
          WHEN 'divide'.
            zcl_complex_matrix=>divide( it_left = it_left it_right = it_right ).
        ENDCASE.
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
