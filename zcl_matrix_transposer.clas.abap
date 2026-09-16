class zcl_matrix_transposer definition
  public
  final
  create public.

  public section.
    types:
      ty_cell   type zcl_matrix=>ty_cell,
      ty_row    type zcl_matrix=>ty_row,
      ty_matrix type zcl_matrix=>ty_matrix,
      ty_shape  type zcl_matrix=>ty_shape.

    "! Transpose an m-by-n matrix to n-by-m. Each cell of the result is
    "! source[j,i] = source[i,j].
    class-methods transpose
      importing
        it_matrix            type ty_matrix
      returning
        value(rt_transposed) type ty_matrix
      raising
        zcx_matrix.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_MATRIX_TRANSPOSER IMPLEMENTATION.


  method transpose.
    data(ls_shape) = zcl_matrix=>get_shape( it_matrix ).

    rt_transposed = value #(
      for lv_col = 1 then lv_col + 1 until lv_col > ls_shape-cols
      ( value ty_row(
                      for lv_row = 1 then lv_row + 1 until lv_row > ls_shape-rows
                      ( it_matrix[ lv_row ][ lv_col ] ) ) ) ).
  endmethod.
ENDCLASS.
