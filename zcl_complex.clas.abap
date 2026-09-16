class zcl_complex definition
  public
  final
  create public.

  public section.
    types:
      begin of ty_complex,
        re type decfloat34,
        im type decfloat34,
      end of ty_complex.

    class-methods from
      importing
        iv_re           type decfloat34
        iv_im           type decfloat34 default 0
      returning
        value(rs_value) type ty_complex.

    class-methods zero
      returning
        value(rs_value) type ty_complex.

    class-methods one
      returning
        value(rs_value) type ty_complex.

    class-methods add
      importing
        is_left       type ty_complex
        is_right      type ty_complex
      returning
        value(rs_sum) type ty_complex.

    class-methods subtract
      importing
        is_left        type ty_complex
        is_right       type ty_complex
      returning
        value(rs_diff) type ty_complex.

    class-methods multiply
      importing
        is_left           type ty_complex
        is_right          type ty_complex
      returning
        value(rs_product) type ty_complex.

    class-methods divide
      importing
        is_left            type ty_complex
        is_right           type ty_complex
      returning
        value(rs_quotient) type ty_complex
      raising
        zcx_matrix.

    class-methods abs_squared
      importing
        is_value        type ty_complex
      returning
        value(rv_value) type decfloat34.

    class-methods is_zero
      importing
        is_value       type ty_complex
      returning
        value(rv_zero) type abap_bool.

    class-methods to_string
      importing
        is_value       type ty_complex
      returning
        value(rv_text) type string.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_COMPLEX IMPLEMENTATION.


  method from.
    rs_value-re = iv_re.
    rs_value-im = iv_im.
  endmethod.


  method zero.
    rs_value = from( iv_re = 0 iv_im = 0 ).
  endmethod.


  method one.
    rs_value = from( iv_re = 1 iv_im = 0 ).
  endmethod.


  method add.
    rs_sum-re = is_left-re + is_right-re.
    rs_sum-im = is_left-im + is_right-im.
  endmethod.


  method subtract.
    rs_diff-re = is_left-re - is_right-re.
    rs_diff-im = is_left-im - is_right-im.
  endmethod.


  method multiply.
    rs_product-re = is_left-re * is_right-re - is_left-im * is_right-im.
    rs_product-im = is_left-re * is_right-im + is_left-im * is_right-re.
  endmethod.


  method divide.
    data(lv_denom) = abs_squared( is_right ).
    if lv_denom = 0.
      raise exception type zcx_matrix
        exporting
          text = |Cannot divide by the complex number 0|.
    endif.
    rs_quotient-re = ( is_left-re * is_right-re + is_left-im * is_right-im ) / lv_denom.
    rs_quotient-im = ( is_left-im * is_right-re - is_left-re * is_right-im ) / lv_denom.
  endmethod.


  method abs_squared.
    rv_value = is_value-re * is_value-re + is_value-im * is_value-im.
  endmethod.


  method is_zero.
    rv_zero = boolc( is_value-re = 0 and is_value-im = 0 ).
  endmethod.


  method to_string.
    data(lv_re) = condense( conv string( is_value-re ) ).
    data(lv_im_abs) = condense( conv string( abs( is_value-im ) ) ).

    if is_value-im = 0.
      rv_text = lv_re.
      return.
    endif.

    data(lv_im_term) = cond string(
      when abs( is_value-im ) = 1 then `i`
      else |{ lv_im_abs }i| ).

    if is_value-re = 0.
      rv_text = cond #(
        when is_value-im < 0 then |-{ lv_im_term }|
        else lv_im_term ).
      return.
    endif.

    data(lv_sign) = cond string( when is_value-im < 0 then `-` else `+` ).
    rv_text = |{ lv_re }{ lv_sign }{ lv_im_term }|.
  endmethod.
ENDCLASS.
