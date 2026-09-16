*"* use this source file for your ABAP unit test classes
CLASS ltc_matrix_subtractor DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS subtract_two_by_three FOR TESTING RAISING cx_static_check.
    METHODS subtract_one_by_one FOR TESTING RAISING cx_static_check.
    METHODS subtract_square FOR TESTING RAISING cx_static_check.
    METHODS subtract_column_vector FOR TESTING RAISING cx_static_check.
    METHODS subtract_row_vector FOR TESTING RAISING cx_static_check.
    METHODS subtract_negatives_and_decimals FOR TESTING RAISING cx_static_check.
    METHODS subtract_zeros FOR TESTING RAISING cx_static_check.
    METHODS subtract_self_is_zero FOR TESTING RAISING cx_static_check.
    METHODS subtract_empty_matrices FOR TESTING RAISING cx_static_check.
    METHODS add_then_subtract_restores FOR TESTING RAISING cx_static_check.
    METHODS mismatch_rows FOR TESTING RAISING cx_static_check.
    METHODS mismatch_columns FOR TESTING RAISING cx_static_check.
    METHODS jagged_left FOR TESTING RAISING cx_static_check.
    METHODS jagged_right FOR TESTING RAISING cx_static_check.

    METHODS expect_error
      IMPORTING
        it_left  TYPE zcl_matrix=>ty_matrix
        it_right TYPE zcl_matrix=>ty_matrix.
ENDCLASS.


CLASS ltc_matrix_subtractor IMPLEMENTATION.

  METHOD subtract_two_by_three.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 8 ) ) ( CONV decfloat34( 10 ) ) ( CONV decfloat34( 12 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ( CONV decfloat34( 7 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ( CONV decfloat34( 9 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 1 ) ) ) ) ).

    DATA(lt_diff) = zcl_matrix_subtractor=>subtract( it_left = lt_a it_right = lt_b ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_diff
      exp = lt_expected ).
  ENDMETHOD.


  METHOD subtract_one_by_one.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 12 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( -5 ) ) ) ) ).

    DATA(lt_diff) = zcl_matrix_subtractor=>subtract( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_diff[ 1 ][ 1 ]
      exp = CONV zcl_matrix=>ty_cell( 17 ) ).
  ENDMETHOD.


  METHOD subtract_square.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ) ) ).

    DATA(lt_diff) = zcl_matrix_subtractor=>subtract( it_left = lt_a it_right = lt_b ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 0 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 0 ) ) ( CONV decfloat34( 1 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_diff
      exp = lt_expected ).
  ENDMETHOD.


  METHOD subtract_column_vector.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 10 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 20 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 30 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ) ) ).

    DATA(lt_diff) = zcl_matrix_subtractor=>subtract( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_diff ) exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 1 ][ 1 ] exp = CONV zcl_matrix=>ty_cell( 9 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 2 ][ 1 ] exp = CONV zcl_matrix=>ty_cell( 18 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 3 ][ 1 ] exp = CONV zcl_matrix=>ty_cell( 27 ) ).
  ENDMETHOD.


  METHOD subtract_row_vector.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 5 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 1 ) ) ) ) ).

    DATA(lt_diff) = zcl_matrix_subtractor=>subtract( it_left = lt_a it_right = lt_b ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_diff
      exp = lt_expected ).
  ENDMETHOD.


  METHOD subtract_negatives_and_decimals.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( '-1.5' ) ( '0.25' ) ) )
      ( VALUE zcl_matrix=>ty_row( ( '2.5' ) ( '-0.75' ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( '0.5' ) ( '-0.25' ) ) )
      ( VALUE zcl_matrix=>ty_row( ( '-2.5' ) ( '1.75' ) ) ) ).

    DATA(lt_diff) = zcl_matrix_subtractor=>subtract( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 1 ][ 1 ] exp = CONV zcl_matrix=>ty_cell( '-2' ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 1 ][ 2 ] exp = CONV zcl_matrix=>ty_cell( '0.5' ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 2 ][ 1 ] exp = CONV zcl_matrix=>ty_cell( 5 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 2 ][ 2 ] exp = CONV zcl_matrix=>ty_cell( '-2.5' ) ).
  ENDMETHOD.


  METHOD subtract_zeros.
    DATA(lt_zeros) = zcl_matrix=>create( iv_rows = 2 iv_cols = 2 ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 9 ) ) ( CONV decfloat34( 8 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lt_diff) = zcl_matrix_subtractor=>subtract( it_left = lt_b it_right = lt_zeros ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_diff
      exp = lt_b ).
  ENDMETHOD.


  METHOD subtract_self_is_zero.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( -1 ) ) ( CONV decfloat34( 4 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 9 ) ) ) ) ).

    DATA(lt_diff) = zcl_matrix_subtractor=>subtract( it_left = lt_a it_right = lt_a ).
    DATA(lt_zeros) = zcl_matrix=>create( iv_rows = 2 iv_cols = 3 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_diff
      exp = lt_zeros ).
  ENDMETHOD.


  METHOD subtract_empty_matrices.
    DATA lt_a TYPE zcl_matrix=>ty_matrix.
    DATA lt_b TYPE zcl_matrix=>ty_matrix.

    DATA(lt_diff) = zcl_matrix_subtractor=>subtract( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_initial( lt_diff ).
  ENDMETHOD.


  METHOD add_then_subtract_restores.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ( CONV decfloat34( 9 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 1 ) ) ) ) ).

    DATA(lt_sum) = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b ).
    DATA(lt_restored) = zcl_matrix_subtractor=>subtract( it_left = lt_sum it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_restored
      exp = lt_a ).
  ENDMETHOD.


  METHOD mismatch_rows.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD mismatch_columns.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD jagged_left.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD jagged_right.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD expect_error.
    TRY.
        zcl_matrix_subtractor=>subtract( it_left = it_left it_right = it_right ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
