*"* use this source file for your ABAP unit test classes
CLASS ltc_matrix_multiplier DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS multiply_two_by_three_by_two FOR TESTING RAISING cx_static_check.
    METHODS multiply_matrix_by_vector FOR TESTING RAISING cx_static_check.
    METHODS multiply_dot_product FOR TESTING RAISING cx_static_check.
    METHODS multiply_square FOR TESTING RAISING cx_static_check.
    METHODS multiply_by_identity FOR TESTING RAISING cx_static_check.
    METHODS identity_by_matrix FOR TESTING RAISING cx_static_check.
    METHODS multiply_by_zero FOR TESTING RAISING cx_static_check.
    METHODS multiply_negatives_and_decimals FOR TESTING RAISING cx_static_check.
    METHODS multiply_empty_matrices FOR TESTING RAISING cx_static_check.
    METHODS inner_dimension_mismatch FOR TESTING RAISING cx_static_check.
    METHODS same_outer_shape_still_mismatch FOR TESTING RAISING cx_static_check.
    METHODS jagged_left FOR TESTING RAISING cx_static_check.
    METHODS jagged_right FOR TESTING RAISING cx_static_check.

    METHODS expect_error
      IMPORTING
        it_left  TYPE zcl_matrix=>ty_matrix
        it_right TYPE zcl_matrix=>ty_matrix.
ENDCLASS.


CLASS ltc_matrix_multiplier IMPLEMENTATION.

  METHOD multiply_two_by_three_by_two.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 9 ) ) ( CONV decfloat34( 10 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 11 ) ) ( CONV decfloat34( 12 ) ) ) ) ).

    DATA(lt_product) = zcl_matrix_multiplier=>multiply( it_left = lt_a it_right = lt_b ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 58 ) ) ( CONV decfloat34( 64 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 139 ) ) ( CONV decfloat34( 154 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_product
      exp = lt_expected ).
  ENDMETHOD.


  METHOD multiply_matrix_by_vector.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_v) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ) ) ).

    DATA(lt_product) = zcl_matrix_multiplier=>multiply( it_left = lt_a it_right = lt_v ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 14 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 32 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_product
      exp = lt_expected ).
  ENDMETHOD.


  METHOD multiply_dot_product.
    DATA(lt_row) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) ) ).
    DATA(lt_col) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 5 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lt_product) = zcl_matrix_multiplier=>multiply( it_left = lt_row it_right = lt_col ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_product ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_product[ 1 ] ) exp = 1 ).
    cl_abap_unit_assert=>assert_equals( act = lt_product[ 1 ][ 1 ] exp = CONV zcl_matrix=>ty_cell( 32 ) ).
  ENDMETHOD.


  METHOD multiply_square.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ) ) ).

    DATA(lt_product) = zcl_matrix_multiplier=>multiply( it_left = lt_a it_right = lt_b ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 19 ) ) ( CONV decfloat34( 22 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 43 ) ) ( CONV decfloat34( 50 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_product
      exp = lt_expected ).
  ENDMETHOD.


  METHOD multiply_by_identity.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ) ) ).
    DATA(lt_identity) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 0 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 0 ) ) ( CONV decfloat34( 1 ) ) ) ) ).

    DATA(lt_product) = zcl_matrix_multiplier=>multiply( it_left = lt_a it_right = lt_identity ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_product
      exp = lt_a ).
  ENDMETHOD.


  METHOD identity_by_matrix.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ) ) ).
    DATA(lt_identity) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 0 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 0 ) ) ( CONV decfloat34( 1 ) ) ) ) ).

    DATA(lt_product) = zcl_matrix_multiplier=>multiply( it_left = lt_identity it_right = lt_a ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_product
      exp = lt_a ).
  ENDMETHOD.


  METHOD multiply_by_zero.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_zero) = zcl_matrix=>create( iv_rows = 3 iv_cols = 2 ).

    DATA(lt_product) = zcl_matrix_multiplier=>multiply( it_left = lt_a it_right = lt_zero ).
    DATA(lt_expected) = zcl_matrix=>create( iv_rows = 2 iv_cols = 2 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_product
      exp = lt_expected ).
  ENDMETHOD.


  METHOD multiply_negatives_and_decimals.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( '-1.5' ) ( '2' ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( '0.5' ) ) )
      ( VALUE zcl_matrix=>ty_row( ( '4' ) ) ) ).

    DATA(lt_product) = zcl_matrix_multiplier=>multiply( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_product[ 1 ][ 1 ]
      exp = CONV zcl_matrix=>ty_cell( '7.25' ) ).
  ENDMETHOD.


  METHOD multiply_empty_matrices.
    DATA lt_a TYPE zcl_matrix=>ty_matrix.
    DATA lt_b TYPE zcl_matrix=>ty_matrix.

    DATA(lt_product) = zcl_matrix_multiplier=>multiply( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_initial( lt_product ).
  ENDMETHOD.


  METHOD inner_dimension_mismatch.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 9 ) ) ( CONV decfloat34( 10 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD same_outer_shape_still_mismatch.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ( CONV decfloat34( 7 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 8 ) ) ( CONV decfloat34( 9 ) ) ( CONV decfloat34( 10 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 11 ) ) ( CONV decfloat34( 12 ) ) ( CONV decfloat34( 13 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD jagged_left.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 9 ) ) ( CONV decfloat34( 10 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 11 ) ) ( CONV decfloat34( 12 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD jagged_right.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 9 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 11 ) ) ( CONV decfloat34( 12 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD expect_error.
    TRY.
        zcl_matrix_multiplier=>multiply( it_left = it_left it_right = it_right ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
