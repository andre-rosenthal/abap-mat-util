*"* use this source file for your ABAP unit test classes
CLASS ltc_complex DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS add_re_and_im FOR TESTING RAISING cx_static_check.
    METHODS subtract FOR TESTING RAISING cx_static_check.
    METHODS multiply_i_squared FOR TESTING RAISING cx_static_check.
    METHODS multiply_conjugate FOR TESTING RAISING cx_static_check.
    METHODS divide_gives_i FOR TESTING RAISING cx_static_check.
    METHODS divide_by_zero FOR TESTING RAISING cx_static_check.
    METHODS to_string_formats FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_complex IMPLEMENTATION.

  METHOD add_re_and_im.
    DATA(ls_sum) = zcl_complex=>add(
      is_left  = zcl_complex=>from( iv_re = 1 iv_im = 2 )
      is_right = zcl_complex=>from( iv_re = 3 iv_im = -5 ) ).

    cl_abap_unit_assert=>assert_equals( act = ls_sum-re exp = CONV decfloat34( 4 ) ).
    cl_abap_unit_assert=>assert_equals( act = ls_sum-im exp = CONV decfloat34( -3 ) ).
  ENDMETHOD.


  METHOD subtract.
    DATA(ls_diff) = zcl_complex=>subtract(
      is_left  = zcl_complex=>from( iv_re = 4 iv_im = 1 )
      is_right = zcl_complex=>from( iv_re = 1 iv_im = 4 ) ).

    cl_abap_unit_assert=>assert_equals( act = ls_diff-re exp = CONV decfloat34( 3 ) ).
    cl_abap_unit_assert=>assert_equals( act = ls_diff-im exp = CONV decfloat34( -3 ) ).
  ENDMETHOD.


  METHOD multiply_i_squared.
    DATA(ls_i) = zcl_complex=>from( iv_re = 0 iv_im = 1 ).
    DATA(ls_i2) = zcl_complex=>multiply( is_left = ls_i is_right = ls_i ).

    cl_abap_unit_assert=>assert_equals( act = ls_i2-re exp = CONV decfloat34( -1 ) ).
    cl_abap_unit_assert=>assert_equals( act = ls_i2-im exp = CONV decfloat34( 0 ) ).
  ENDMETHOD.


  METHOD multiply_conjugate.
    DATA(ls_z) = zcl_complex=>from( iv_re = 1 iv_im = 1 ).
    DATA(ls_conj) = zcl_complex=>from( iv_re = 1 iv_im = -1 ).
    DATA(ls_prod) = zcl_complex=>multiply( is_left = ls_z is_right = ls_conj ).

    cl_abap_unit_assert=>assert_equals( act = ls_prod-re exp = CONV decfloat34( 2 ) ).
    cl_abap_unit_assert=>assert_equals( act = ls_prod-im exp = CONV decfloat34( 0 ) ).
  ENDMETHOD.


  METHOD divide_gives_i.
    DATA(ls_q) = zcl_complex=>divide(
      is_left  = zcl_complex=>from( iv_re = 3 iv_im = 4 )
      is_right = zcl_complex=>from( iv_re = 4 iv_im = -3 ) ).

    cl_abap_unit_assert=>assert_equals( act = ls_q-re exp = CONV decfloat34( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = ls_q-im exp = CONV decfloat34( 1 ) ).
  ENDMETHOD.


  METHOD divide_by_zero.
    TRY.
        zcl_complex=>divide(
          is_left  = zcl_complex=>one( )
          is_right = zcl_complex=>zero( ) ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD to_string_formats.
    cl_abap_unit_assert=>assert_equals(
      act = zcl_complex=>to_string( zcl_complex=>from( iv_re = 3 iv_im = 0 ) )
      exp = `3` ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_complex=>to_string( zcl_complex=>from( iv_re = 0 iv_im = 1 ) )
      exp = `i` ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_complex=>to_string( zcl_complex=>from( iv_re = 0 iv_im = -1 ) )
      exp = `-i` ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_complex=>to_string( zcl_complex=>from( iv_re = 3 iv_im = 4 ) )
      exp = `3+4i` ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_complex=>to_string( zcl_complex=>from( iv_re = 3 iv_im = -4 ) )
      exp = `3-4i` ).
    cl_abap_unit_assert=>assert_equals(
      act = zcl_complex=>to_string( zcl_complex=>from( iv_re = 2 iv_im = 1 ) )
      exp = `2+i` ).
  ENDMETHOD.

ENDCLASS.
