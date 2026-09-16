*"* use this source file for your ABAP unit test classes
CLASS ltc_matrix_divider DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS divide_one_by_one FOR TESTING RAISING cx_static_check.
    METHODS divide_by_identity FOR TESTING RAISING cx_static_check.
    METHODS divide_self_is_identity FOR TESTING RAISING cx_static_check.
    METHODS divide_known_two_by_two FOR TESTING RAISING cx_static_check.
    METHODS multiply_then_divide_restores FOR TESTING RAISING cx_static_check.
    METHODS m_by_n_over_n_by_n FOR TESTING RAISING cx_static_check.
    METHODS divide_empty_matrices FOR TESTING RAISING cx_static_check.
    METHODS non_square_divisor FOR TESTING RAISING cx_static_check.
    METHODS inner_dimension_mismatch FOR TESTING RAISING cx_static_check.
    METHODS singular_divisor FOR TESTING RAISING cx_static_check.
    METHODS jagged_left FOR TESTING RAISING cx_static_check.
    METHODS jagged_right FOR TESTING RAISING cx_static_check.

    METHODS identity
      IMPORTING
        iv_size          TYPE i
      RETURNING
        VALUE(rt_matrix) TYPE zcl_matrix=>ty_matrix
      RAISING
        zcx_matrix.

    METHODS expect_error
      IMPORTING
        it_left  TYPE zcl_matrix=>ty_matrix
        it_right TYPE zcl_matrix=>ty_matrix.
ENDCLASS.


CLASS ltc_matrix_divider IMPLEMENTATION.

  METHOD divide_one_by_one.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 12 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ) ) ).

    DATA(lt_q) = zcl_matrix_divider=>divide( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_q[ 1 ][ 1 ]
      exp = CONV zcl_matrix=>ty_cell( 4 ) ).
  ENDMETHOD.


  METHOD divide_by_identity.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ) ) ).

    DATA(lt_q) = zcl_matrix_divider=>divide(
      it_left  = lt_a
      it_right = identity( 2 ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_q
      exp = lt_a ).
  ENDMETHOD.


  METHOD divide_self_is_identity.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 7 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lt_q) = zcl_matrix_divider=>divide( it_left = lt_a it_right = lt_a ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_q
      exp = identity( 2 ) ).
  ENDMETHOD.


  METHOD divide_known_two_by_two.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 0 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 0 ) ) ( CONV decfloat34( 2 ) ) ) ) ).

    DATA(lt_q) = zcl_matrix_divider=>divide( it_left = lt_a it_right = lt_b ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 1 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 2 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_q
      exp = lt_expected ).
  ENDMETHOD.


  METHOD multiply_then_divide_restores.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 7 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lt_product) = zcl_matrix_multiplier=>multiply( it_left = lt_a it_right = lt_b ).
    DATA(lt_restored) = zcl_matrix_divider=>divide( it_left = lt_product it_right = lt_b ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_restored
      exp = lt_a ).
  ENDMETHOD.


  METHOD m_by_n_over_n_by_n.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lt_q) = zcl_matrix_divider=>divide(
      it_left  = lt_a
      it_right = identity( 3 ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_q
      exp = lt_a ).
  ENDMETHOD.


  METHOD divide_empty_matrices.
    DATA lt_a TYPE zcl_matrix=>ty_matrix.
    DATA lt_b TYPE zcl_matrix=>ty_matrix.

    DATA(lt_q) = zcl_matrix_divider=>divide( it_left = lt_a it_right = lt_b ).

    cl_abap_unit_assert=>assert_initial( lt_q ).
  ENDMETHOD.


  METHOD non_square_divisor.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 9 ) ) ( CONV decfloat34( 10 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 11 ) ) ( CONV decfloat34( 12 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD inner_dimension_mismatch.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 0 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 0 ) ) ( CONV decfloat34( 1 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD singular_divisor.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 0 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 0 ) ) ( CONV decfloat34( 1 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 4 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD jagged_left.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ) ) ).
    DATA(lt_b) = identity( 2 ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD jagged_right.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 0 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 0 ) ) ) ) ).

    expect_error( it_left = lt_a it_right = lt_b ).
  ENDMETHOD.


  METHOD identity.
    rt_matrix = zcl_matrix=>create( iv_rows = iv_size iv_cols = iv_size ).
    DATA(lv_i) = 0.
    WHILE lv_i < iv_size.
      lv_i = lv_i + 1.
      READ TABLE rt_matrix INDEX lv_i ASSIGNING FIELD-SYMBOL(<ls_row>).
      READ TABLE <ls_row> INDEX lv_i ASSIGNING FIELD-SYMBOL(<lv_cell>).
      <lv_cell> = 1.
    ENDWHILE.
  ENDMETHOD.


  METHOD expect_error.
    TRY.
        zcl_matrix_divider=>divide( it_left = it_left it_right = it_right ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
