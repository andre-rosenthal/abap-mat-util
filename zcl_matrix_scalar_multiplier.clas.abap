class zcl_matrix_scalar_multiplier definition
  public
  final
  create public.

  public section.
    types:
      ty_cell   type zcl_matrix=>ty_cell,
      ty_row    type zcl_matrix=>ty_row,
      ty_matrix type zcl_matrix=>ty_matrix,
      ty_shape  type zcl_matrix=>ty_shape.

    "! Multiply every cell of an m-by-n matrix by a scalar. The result has
    "! the same shape: C[i,j] = scalar * A[i,j].
    class-methods multiply
      importing
        it_matrix        type ty_matrix
        iv_scalar        type ty_cell
      returning
        value(rt_scaled) type ty_matrix
      raising
        zcx_matrix.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_MATRIX_SCALAR_MULTIPLIER IMPLEMENTATION.


  method multiply.
    zcl_matrix=>get_shape( it_matrix ).

    rt_scaled = value #(
      for <ls_row> in it_matrix
      ( value ty_row(
                      for <lv_cell> in <ls_row>
                      ( iv_scalar * <lv_cell> ) ) ) ).
  endmethod.
ENDCLASS.
