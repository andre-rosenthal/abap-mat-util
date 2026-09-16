*"* use this source file for your ABAP unit test classes
CLASS ltc_vector DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS add_three_d FOR TESTING RAISING cx_static_check.
    METHODS subtract_two_d FOR TESTING RAISING cx_static_check.
    METHODS scale_by_two FOR TESTING RAISING cx_static_check.
    METHODS dot_product FOR TESTING RAISING cx_static_check.
    METHODS cross_ijk FOR TESTING RAISING cx_static_check.
    METHODS cross_generic FOR TESTING RAISING cx_static_check.
    METHODS norm_three_four_five FOR TESTING RAISING cx_static_check.
    METHODS normalize_three_four FOR TESTING RAISING cx_static_check.
    METHODS empty_dot_is_zero FOR TESTING RAISING cx_static_check.
    METHODS mismatch_add FOR TESTING RAISING cx_static_check.
    METHODS cross_rejects_two_d FOR TESTING RAISING cx_static_check.
    METHODS normalize_zero FOR TESTING RAISING cx_static_check.
    METHODS create_rejects_negative FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltc_vector IMPLEMENTATION.

  METHOD add_three_d.
    DATA(lt_sum) = zcl_vector=>add(
      it_left  = zcl_vector=>of( iv_x = 1 iv_y = 2 iv_z = 3 )
      it_right = zcl_vector=>of( iv_x = 4 iv_y = 5 iv_z = 6 ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 1 ] exp = zcl_vector=>cell( 5 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 2 ] exp = zcl_vector=>cell( 7 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_sum[ 3 ] exp = zcl_vector=>cell( 9 ) ).
  ENDMETHOD.


  METHOD subtract_two_d.
    DATA(lt_diff) = zcl_vector=>subtract(
      it_left  = zcl_vector=>of( iv_x = 5 iv_y = 1 )
      it_right = zcl_vector=>of( iv_x = 2 iv_y = 4 ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 1 ] exp = zcl_vector=>cell( 3 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_diff[ 2 ] exp = zcl_vector=>cell( -3 ) ).
  ENDMETHOD.


  METHOD scale_by_two.
    DATA(lt_scaled) = zcl_vector=>scale(
      it_vector = zcl_vector=>of( iv_x = 1 iv_y = -2 iv_z = 3 )
      iv_scalar = 2 ).

    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 1 ] exp = zcl_vector=>cell( 2 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 2 ] exp = zcl_vector=>cell( -4 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_scaled[ 3 ] exp = zcl_vector=>cell( 6 ) ).
  ENDMETHOD.


  METHOD dot_product.
    DATA(lv_dot) = zcl_vector=>dot(
      it_left  = zcl_vector=>of( iv_x = 1 iv_y = 2 iv_z = 3 )
      it_right = zcl_vector=>of( iv_x = 4 iv_y = 5 iv_z = 6 ) ).

    cl_abap_unit_assert=>assert_equals( act = lv_dot exp = zcl_vector=>cell( 32 ) ).
  ENDMETHOD.


  METHOD cross_ijk.
    DATA(lt_cross) = zcl_vector=>cross(
      it_left  = zcl_vector=>of( iv_x = 1 iv_y = 0 iv_z = 0 )
      it_right = zcl_vector=>of( iv_x = 0 iv_y = 1 iv_z = 0 ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_cross[ 1 ] exp = zcl_vector=>cell( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_cross[ 2 ] exp = zcl_vector=>cell( 0 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_cross[ 3 ] exp = zcl_vector=>cell( 1 ) ).
  ENDMETHOD.


  METHOD cross_generic.
    DATA(lt_cross) = zcl_vector=>cross(
      it_left  = zcl_vector=>of( iv_x = 1 iv_y = 2 iv_z = 3 )
      it_right = zcl_vector=>of( iv_x = 4 iv_y = 5 iv_z = 6 ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_cross[ 1 ] exp = zcl_vector=>cell( -3 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_cross[ 2 ] exp = zcl_vector=>cell( 6 ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_cross[ 3 ] exp = zcl_vector=>cell( -3 ) ).
  ENDMETHOD.


  METHOD norm_three_four_five.
    DATA(lv_norm) = zcl_vector=>norm( zcl_vector=>of( iv_x = 3 iv_y = 4 ) ).

    cl_abap_unit_assert=>assert_equals( act = lv_norm exp = zcl_vector=>cell( 5 ) ).
  ENDMETHOD.


  METHOD normalize_three_four.
    DATA(lt_unit) = zcl_vector=>normalize( zcl_vector=>of( iv_x = 3 iv_y = 4 ) ).

    cl_abap_unit_assert=>assert_equals( act = lt_unit[ 1 ] exp = zcl_vector=>cell( '0.6' ) ).
    cl_abap_unit_assert=>assert_equals( act = lt_unit[ 2 ] exp = zcl_vector=>cell( '0.8' ) ).
  ENDMETHOD.


  METHOD empty_dot_is_zero.
    DATA lt_empty TYPE zcl_vector=>ty_vector.

    cl_abap_unit_assert=>assert_equals(
      act = zcl_vector=>dot( it_left = lt_empty it_right = lt_empty )
      exp = zcl_vector=>cell( 0 ) ).
  ENDMETHOD.


  METHOD mismatch_add.
    TRY.
        zcl_vector=>add(
          it_left  = zcl_vector=>of( iv_x = 1 iv_y = 2 )
          it_right = zcl_vector=>of( iv_x = 1 iv_y = 2 iv_z = 3 ) ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD cross_rejects_two_d.
    TRY.
        zcl_vector=>cross(
          it_left  = zcl_vector=>of( iv_x = 1 iv_y = 2 )
          it_right = zcl_vector=>of( iv_x = 3 iv_y = 4 ) ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD normalize_zero.
    TRY.
        zcl_vector=>normalize( zcl_vector=>create( iv_length = 3 ) ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD create_rejects_negative.
    TRY.
        zcl_vector=>create( iv_length = -1 ).
        cl_abap_unit_assert=>fail( msg = 'Expected zcx_matrix' ).
      CATCH zcx_matrix.
        RETURN.
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
