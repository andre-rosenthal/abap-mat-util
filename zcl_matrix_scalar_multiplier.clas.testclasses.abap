*"* use this source file for your ABAP unit test classes
CLASS ltc_matrix_scalar_multiplier DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS scale_two_by_three FOR TESTING RAISING cx_static_check.
    METHODS scale_one_by_one FOR TESTING RAISING cx_static_check.
    METHODS scale_by_one_is_unchanged FOR TESTING RAISING cx_static_check.
    METHODS scale_by_zero FOR TESTING RAISING cx_static_check.
    METHODS scale_by_negative FOR TESTING RAISING cx_static_check.
    METHODS scale_decimals FOR TESTING RAISING cx_static_check.
    METHODS scale_empty FOR TESTING RAISING cx_static_check.
    METHODS scale_distributes_over_add FOR TESTING RAISING cx_static_check.
    METHODS scale_commutes_with_transpose FOR TESTING RAISING cx_static_check.
    METHODS jagged FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_matrix_scalar_multiplier IMPLEMENTATION.

  METHOD scale_two_by_three.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lt_scaled) = zcl_matrix_scalar_multiplier=>multiply(
      it_matrix = lt_a
      iv_scalar = 2 ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 6 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 8 ) ) ( CONV decfloat34( 10 ) ) ( CONV decfloat34( 12 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_scaled
      exp = lt_expected ).
  ENDMETHOD.


  METHOD scale_one_by_one.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 5 ) ) ) ) ).

    DATA(lt_scaled) = zcl_matrix_scalar_multiplier=>multiply(
      it_matrix = lt_a
      iv_scalar = 3 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_scaled[ 1 ][ 1 ]
      exp = CONV zcl_matrix=>ty_cell( 15 ) ).
  ENDMETHOD.


  METHOD scale_by_one_is_unchanged.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 9 ) ) ( CONV decfloat34( 10 ) ) ) ) ).

    DATA(lt_scaled) = zcl_matrix_scalar_multiplier=>multiply(
      it_matrix = lt_a
      iv_scalar = 1 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_scaled
      exp = lt_a ).
  ENDMETHOD.


  METHOD scale_by_zero.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lt_scaled) = zcl_matrix_scalar_multiplier=>multiply(
      it_matrix = lt_a
      iv_scalar = 0 ).

    DATA(lt_zeros) = zcl_matrix=>create( iv_rows = 2 iv_cols = 3 ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_scaled
      exp = lt_zeros ).
  ENDMETHOD.


  METHOD scale_by_negative.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( -2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 0 ) ) ) ) ).

    DATA(lt_scaled) = zcl_matrix_scalar_multiplier=>multiply(
      it_matrix = lt_a
      iv_scalar = -1 ).

    DATA(lt_expected) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( -1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( -3 ) ) ( CONV decfloat34( 0 ) ) ) ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_scaled
      exp = lt_expected ).
  ENDMETHOD.


  METHOD scale_decimals.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( '1.5' ) ( '2' ) ) )
      ( VALUE zcl_matrix=>ty_row( ( '-0.5' ) ( '4' ) ) ) ).

    DATA(lt_scaled) = zcl_matrix_scalar_multiplier=>multiply(
      it_matrix = lt_a
      iv_scalar = '0.5' ).

    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 1 ][ 1 ] exp = CONV zcl_matrix=>ty_cell( '0.75' ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 1 ][ 2 ] exp = CONV zcl_matrix=>ty_cell( 1 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 2 ][ 1 ] exp = CONV zcl_matrix=>ty_cell( '-0.25' ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 2 ][ 2 ] exp = CONV zcl_matrix=>ty_cell( 2 ) ).
  ENDMETHOD.


  METHOD scale_empty.
    DATA lt_a TYPE zcl_matrix=>ty_matrix.

    DATA(lt_scaled) = zcl_matrix_scalar_multiplier=>multiply(
      it_matrix = lt_a
      iv_scalar = 9 ).

    cl_abap_unit_assert=>assert_initial( lt_scaled ).
  ENDMETHOD.


  METHOD scale_distributes_over_add.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 3 ) ) ( CONV decfloat34( 4 ) ) ) ) ).
    DATA(lt_b) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 7 ) ) ( CONV decfloat34( 8 ) ) ) ) ).

    DATA(lv_k) = CONV zcl_matrix=>ty_cell( 3 ).

    DATA(lt_left) = zcl_matrix_scalar_multiplier=>multiply(
      it_matrix = zcl_matrix_adder=>add( it_left = lt_a it_right = lt_b )
      iv_scalar = lv_k ).
    DATA(lt_right) = zcl_matrix_adder=>add(
      it_left  = zcl_matrix_scalar_multiplier=>multiply( it_matrix = lt_a iv_scalar = lv_k )
      it_right = zcl_matrix_scalar_multiplier=>multiply( it_matrix = lt_b iv_scalar = lv_k ) ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_left
      exp = lt_right ).
  ENDMETHOD.


  METHOD scale_commutes_with_transpose.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ( CONV decfloat34( 6 ) ) ) ) ).

    DATA(lv_k) = CONV zcl_matrix=>ty_cell( -2 ).

    DATA(lt_left) = zcl_matrix_transposer=>transpose(
      zcl_matrix_scalar_multiplier=>multiply( it_matrix = lt_a iv_scalar = lv_k ) ).
    DATA(lt_right) = zcl_matrix_scalar_multiplier=>multiply(
      it_matrix = zcl_matrix_transposer=>transpose( lt_a )
      iv_scalar = lv_k ).

    cl_abap_unit_assert=>assert_equals(
      act = lt_left
      exp = lt_right ).
  ENDMETHOD.


  METHOD jagged.
    DATA(lt_a) = VALUE zcl_matrix=>ty_matrix(
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 1 ) ) ( CONV decfloat34( 2 ) ) ( CONV decfloat34( 3 ) ) ) )
      ( VALUE zcl_matrix=>ty_row( ( CONV decfloat34( 4 ) ) ( CONV decfloat34( 5 ) ) ) ) ).

    TRY.
        zcl_matrix_scalar_multiplier=>multiply(
          it_matrix = lt_a
          iv_scalar = 2 ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
