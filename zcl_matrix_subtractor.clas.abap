class zcl_matrix_subtractor definition
  public
  final
  create public.

  public section.
    types:
      ty_cell   type zcl_matrix=>ty_cell,
      ty_row    type zcl_matrix=>ty_row,
      ty_matrix type zcl_matrix=>ty_matrix,
      ty_shape  type zcl_matrix=>ty_shape.

    "! Subtract two matrices of the same shape. Each cell of the result is
    "! left[i,j] - right[i,j].
    class-methods subtract
      importing
        it_left        type ty_matrix
        it_right       type ty_matrix
      returning
        value(rt_diff) type ty_matrix
      raising
        zcx_matrix.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_MATRIX_SUBTRACTOR IMPLEMENTATION.


  method subtract.
    zcl_matrix=>assert_same_shape(
      it_left      = it_left
      it_right     = it_right
      iv_operation = 'subtract' ).

    rt_diff = value #(
      for <ls_left_row> in it_left index into lv_row
      ( value ty_row(
                      for <lv_left> in <ls_left_row> index into lv_col
                      ( <lv_left> - it_right[ lv_row ][ lv_col ] ) ) ) ).
  endmethod.
ENDCLASS.
