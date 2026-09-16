*"* use this source file for your ABAP unit test classes
CLASS ltc_matrix_adder DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS add_two_by_three FOR TESTING RAISING cx_static_check.
    METHODS add_one_by_one FOR TESTING RAISING cx_static_check.
    METHODS add_square FOR TESTING RAISING cx_static_check.
    METHODS add_column_vector FOR TESTING RAISING cx_static_check.
    METHODS add_row_vector FOR TESTING RAISING cx_static_check.
    METHODS add_negatives_and_decimals FOR TESTING RAISING cx_static_check.
    METHODS add_zeros FOR TESTING RAISING cx_static_check.
    METHODS add_empty_matrices FOR TESTING RAISING cx_static_check.
    METHODS add_created_fill FOR TESTING RAISING cx_static_check.
    METHODS mismatch_rows FOR TESTING RAISING cx_static_check.
    METHODS mismatch_columns FOR TESTING RAISING cx_static_check.
    METHODS jagged_left FOR TESTING RAISING cx_static_check.
    METHODS jagged_right FOR TESTING RAISING cx_static_check.
    METHODS create_rejects_negative_rows FOR TESTING RAISING cx_static_check.
    METHODS create_rejects_negative_cols FOR TESTING RAISING cx_static_check.
    METHODS get_shape_of_created_matrix FOR TESTING RAISING cx_static_check.

    METHODS expect_error
      IMPORTING
        it_left TYPE zcl_matrix_adder=>ty_matrix
        it_right TYPE zcl_matrix_adder=>ty_matrix.
ENDCLASS.


CLASS ltc_matrix_adder IMPLEMENTATION.

  METHOD add_two_by_three.
    DATA(lt_a) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ( CONV decfloat34( 9 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 1 ) ) ) ) ).

    DATA(lt_sum) = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b ).

    DATA(lt_expected) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 8 ) ) ( CONV decfloat34( 10 ) ) ( CONV decfloat34( 12 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ( CONV decfloat34( 7 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_sum
      exp = lt_expected ).
  ENDMETHOD.


  METHOD add_one_by_one.
    DATA(lt_a) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 12 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( -5 ) ) ) ) ).

    DATA(lt_sum) = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_sum[ 1 ][ 1 ]
      exp = CONV zcl_matrix_adder=>ty_cell( 7 ) ).
  ENDMETHOD.


  METHOD add_square.
    DATA(lt_a) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 0 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 0 ) ) ( CONV decfloat34( 1 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ) ) ).

    DATA(lt_sum) = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b ).

    DATA(lt_expected) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_sum
      exp = lt_expected ).
  ENDMETHOD.


  METHOD add_column_vector.
    DATA(lt_a) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 10 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 20 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 30 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 3 ) ) ) ) ).

    DATA(lt_sum) = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_sum ) exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 1 ][ 1 ] exp = CONV zcl_matrix_adder=>ty_cell( 11 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 2 ][ 1 ] exp = CONV zcl_matrix_adder=>ty_cell( 22 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 3 ][ 1 ] exp = CONV zcl_matrix_adder=>ty_cell( 33 ) ).
  ENDMETHOD.


  METHOD add_row_vector.
    DATA(lt_a) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 1 ) ) ) ) ).

    DATA(lt_sum) = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b ).

    DATA(lt_expected) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 5 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_sum
      exp = lt_expected ).
  ENDMETHOD.


  METHOD add_negatives_and_decimals.
    DATA(lt_a) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( '-1.5' ) ( '0.25' ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( '2.5' ) ( '-0.75' ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( '0.5' ) ( '-0.25' ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( '-2.5' ) ( '1.75' ) ) ) ).

    DATA(lt_sum) = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 1 ][ 1 ] exp = CONV zcl_matrix_adder=>ty_cell( -1 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 1 ][ 2 ] exp = CONV zcl_matrix_adder=>ty_cell( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 2 ][ 1 ] exp = CONV zcl_matrix_adder=>ty_cell( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 2 ][ 2 ] exp = CONV zcl_matrix_adder=>ty_cell( 1 ) ).
  ENDMETHOD.


  METHOD add_zeros.
    DATA(lt_a) = zcl_matrix_adder=>create( iv_rows = 2 iv_cols = 2 ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 9 ) ) ( CONV decfloat34( 8 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lt_sum) = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_sum
      exp = lt_b ).
  ENDMETHOD.


  METHOD add_empty_matrices.
    DATA lt_a TYPE zcl_matrix_adder=>ty_matrix.
    DATA lt_b TYPE zcl_matrix_adder=>ty_matrix.

    DATA(lt_sum) = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_initial( lt_sum ).
  ENDMETHOD.


  METHOD add_created_fill.
    DATA(lt_a) = zcl_matrix_adder=>create(
      iv_rows = 3
      iv_cols = 2
      iv_fill = 4 ).
    DATA(lt_b) = zcl_matrix_adder=>create(
      iv_rows = 3
      iv_cols = 2
      iv_fill = 6 ).

    DATA(lt_sum) = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals( act = lines( lt_sum ) exp = 3 ).
    cl_abap_unit_assert=>assert_equals( act = lines( lt_sum[ 1 ] ) exp = 2 ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 3 ][ 2 ] exp = CONV zcl_matrix_adder=>ty_cell( 10 ) ).
  ENDMETHOD.


  METHOD mismatch_rows.
    DATA(lt_a) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD mismatch_columns.
    DATA(lt_a) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD jagged_left.
    DATA(lt_a) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD jagged_right.
    DATA(lt_a) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix_adder=>ty_matrix(
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 1 ) ) ) )
      ( VALUE zcl_matrix_adder=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD create_rejects_negative_rows.
    TRY.
        zcl_matrix_adder=>create( iv_rows = -1 iv_cols = 2 ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix for negative rows' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD create_rejects_negative_cols.
    TRY.
        zcl_matrix_adder=>create( iv_rows = 2 iv_cols = -3 ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix for negative columns' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD get_shape_of_created_matrix.
    DATA(lt_matrix) = zcl_matrix_adder=>create( iv_rows = 4 iv_cols = 7 ).
    DATA(ls_shape) = zcl_matrix_adder=>get_shape( lt_matrix ).

    cl_abap_unit_assert=>assert_equals( act = ls_shape-rows exp = 4 ).
    cl_abap_unit_assert=>assert_equals( act = ls_shape-cols exp = 7 ).
  ENDMETHOD.


  METHOD expect_error.
    TRY.
        zcl_matrix_adder=>add( it_left = it_left it_right = it_right ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
