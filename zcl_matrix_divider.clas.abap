class zcl_matrix_divider definition
  public
  final
  create public.

  public section.
    types:
      ty_cell   type zcl_matrix=>ty_cell,
      ty_row    type zcl_matrix=>ty_row,
      ty_matrix type zcl_matrix=>ty_matrix,
      ty_shape  type zcl_matrix=>ty_shape.

    "! Right-divide an m-by-n matrix by an n-by-p matrix: A / B = A * B⁻¹.
    "! The divisor must be square (p = n) and invertible. The result is m-by-n.
    class-methods divide
      importing
        it_left            type ty_matrix
        it_right           type ty_matrix
      returning
        value(rt_quotient) type ty_matrix
      raising
        zcx_matrix.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_MATRIX_DIVIDER IMPLEMENTATION.


  method divide.
    zcl_matrix=>assert_dividable(
      it_left  = it_left
      it_right = it_right ).

    data(lt_inverse) = zcl_matrix=>invert( it_right ).

    rt_quotient = zcl_matrix_multiplier=>multiply(
      it_left  = it_left
      it_right = lt_inverse ).
  endmethod.
ENDCLASS.
