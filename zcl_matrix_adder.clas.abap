class zcl_matrix_adder definition
  public
  final
  create public.

  public section.
    types:
      ty_cell   type zcl_matrix=>ty_cell,
      ty_row    type zcl_matrix=>ty_row,
      ty_matrix type zcl_matrix=>ty_matrix,
      ty_shape  type zcl_matrix=>ty_shape.

    "! Create a rectangular m-by-n matrix filled with a constant.
    class-methods create
      importing
        iv_rows          type i
        iv_cols          type i
        iv_fill          type ty_cell default 0
      returning
        value(rt_matrix) type ty_matrix
      raising
        zcx_matrix.

    "! Add two matrices of the same shape. Each cell of the result is
    "! left[i,j] + right[i,j].
    class-methods add
      importing
        it_left       type ty_matrix
        it_right      type ty_matrix
      returning
        value(rt_sum) type ty_matrix
      raising
        zcx_matrix.

    "! Return row and column counts after checking the matrix is rectangular.
    class-methods get_shape
      importing
        it_matrix       type ty_matrix
      returning
        value(rs_shape) type ty_shape
      raising
        zcx_matrix.

    "! Render a matrix as rows of space-separated numbers.
    class-methods to_string
      importing
        it_matrix      type ty_matrix
      returning
        value(rv_text) type string.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_MATRIX_ADDER IMPLEMENTATION.


  method create.
    rt_matrix = zcl_matrix=>create(
      iv_rows = iv_rows
      iv_cols = iv_cols
      iv_fill = iv_fill ).
  endmethod.


  method add.
    zcl_matrix=>assert_same_shape(
      it_left      = it_left
      it_right     = it_right
      iv_operation = 'add' ).

    rt_sum = value #(
      for <ls_left_row> in it_left index into lv_row
      ( value ty_row(
                      for <lv_left> in <ls_left_row> index into lv_col
                      ( <lv_left> + it_right[ lv_row ][ lv_col ] ) ) ) ).
  endmethod.


  method get_shape.
    rs_shape = zcl_matrix=>get_shape( it_matrix ).
  endmethod.


  method to_string.
    rv_text = zcl_matrix=>to_string( it_matrix ).
  endmethod.
ENDCLASS.
