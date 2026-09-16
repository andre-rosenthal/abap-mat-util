class zcl_matrix_multiplier definition
  public
  final
  create public.

  public section.
    types:
      ty_cell   type zcl_matrix=>ty_cell,
      ty_row    type zcl_matrix=>ty_row,
      ty_matrix type zcl_matrix=>ty_matrix,
      ty_shape  type zcl_matrix=>ty_shape.

    "! Multiply an m-by-n matrix by an n-by-p matrix. Each cell of the
    "! m-by-p result is the dot product of a left row and a right column.
    class-methods multiply
      importing
        it_left           type ty_matrix
        it_right          type ty_matrix
      returning
        value(rt_product) type ty_matrix
      raising
        zcx_matrix.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_MATRIX_MULTIPLIER IMPLEMENTATION.


  method multiply.
    zcl_matrix=>assert_multipliable(
      it_left  = it_left
      it_right = it_right ).

    data(ls_left)  = zcl_matrix=>get_shape( it_left ).
    data(ls_right) = zcl_matrix=>get_shape( it_right ).

    rt_product = value #(
      for lv_i = 1 then lv_i + 1 until lv_i > ls_left-rows
      ( value ty_row(
          for lv_j = 1 then lv_j + 1 until lv_j > ls_right-cols
          ( reduce ty_cell(
              init lv_acc = conv ty_cell( 0 )
              for lv_k = 1 then lv_k + 1 until lv_k > ls_left-cols
              next lv_acc = lv_acc + it_left[ lv_i ][ lv_k ] * it_right[ lv_k ][ lv_j ] ) ) ) ) ).
  endmethod.
ENDCLASS.
