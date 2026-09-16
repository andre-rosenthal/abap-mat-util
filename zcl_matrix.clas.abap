class zcl_matrix definition
  public
  final
  create public.

  public section.
    types:
      ty_cell   type decfloat34,
      ty_row    type standard table of ty_cell with empty key,
      ty_matrix type standard table of ty_row with empty key.

    types:
      begin of ty_shape,
        rows type i,
        cols type i,
      end of ty_shape.

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

    "! Return row and column counts after checking the matrix is rectangular.
    class-methods get_shape
      importing
        it_matrix       type ty_matrix
      returning
        value(rs_shape) type ty_shape
      raising
        zcx_matrix.

    "! Raise ZCX_MATRIX unless both matrices have the same rectangular shape.
    class-methods assert_same_shape
      importing
        it_left      type ty_matrix
        it_right     type ty_matrix
        iv_operation type string default 'combine'
      raising
        zcx_matrix.

    "! Raise ZCX_MATRIX unless left is m-by-n and right is n-by-p.
    class-methods assert_multipliable
      importing
        it_left  type ty_matrix
        it_right type ty_matrix
      raising
        zcx_matrix.

    "! Raise unless left is m-by-n and the divisor is square n-by-n.
    class-methods assert_dividable
      importing
        it_left  type ty_matrix
        it_right type ty_matrix
      raising
        zcx_matrix.

    "! Invert a square matrix with Gauss-Jordan elimination.
    class-methods invert
      importing
        it_matrix         type ty_matrix
      returning
        value(rt_inverse) type ty_matrix
      raising
        zcx_matrix.

    "! Convert a number to a matrix cell. Use this (or CONV decfloat34)
    "! in VALUE constructors; integer literals are type I and are not
    "! compatible with a DECFLOAT34 row type.
    class-methods cell
      importing
        iv_value       type ty_cell
      returning
        value(rv_cell) type ty_cell.

    "! Render a matrix as rows of space-separated numbers.
    class-methods to_string
      importing
        it_matrix      type ty_matrix
      returning
        value(rv_text) type string.

  protected section.
  private section.
ENDCLASS.



CLASS ZCL_MATRIX IMPLEMENTATION.


  method create.
    if iv_rows < 0 or iv_cols < 0.
      raise exception type zcx_matrix
        exporting
          text = |Matrix dimensions must be non-negative (got { iv_rows }-by-{ iv_cols })|.
    endif.

    rt_matrix = value #(
      for lv_row = 1 then lv_row + 1 until lv_row > iv_rows
      ( value ty_row(
                      for lv_col = 1 then lv_col + 1 until lv_col > iv_cols
                      ( iv_fill ) ) ) ).
  endmethod.


  method get_shape.
    rs_shape-rows = lines( it_matrix ).
    if rs_shape-rows = 0.
      rs_shape-cols = 0.
      return.
    endif.

    rs_shape-cols = lines( it_matrix[ 1 ] ).

    loop at it_matrix assigning field-symbol(<ls_row>).
      if lines( <ls_row> ) <> rs_shape-cols.
        raise exception type zcx_matrix
          exporting
            text = |Matrix is not rectangular: row { sy-tabix } has { lines( <ls_row> ) } columns, expected { rs_shape-cols }|.
      endif.
    endloop.
  endmethod.


  method assert_same_shape.
    data(ls_left)  = get_shape( it_left ).
    data(ls_right) = get_shape( it_right ).

    if ls_left-rows <> ls_right-rows or ls_left-cols <> ls_right-cols.
      raise exception type zcx_matrix
        exporting
          text = |Cannot { iv_operation } a { ls_left-rows }-by-{ ls_left-cols } matrix and a { ls_right-rows }-by-{ ls_right-cols } matrix|.
    endif.
  endmethod.


  method assert_multipliable.
    data(ls_left)  = get_shape( it_left ).
    data(ls_right) = get_shape( it_right ).

    if ls_left-cols <> ls_right-rows.
      raise exception type zcx_matrix
        exporting
          text = |Cannot multiply a { ls_left-rows }-by-{ ls_left-cols } matrix by a { ls_right-rows }-by-{ ls_right-cols } matrix|.
    endif.
  endmethod.


  method assert_dividable.
    data(ls_left)  = get_shape( it_left ).
    data(ls_right) = get_shape( it_right ).

    if ls_right-rows <> ls_right-cols.
      raise exception type zcx_matrix
        exporting
          text = |Cannot divide by a { ls_right-rows }-by-{ ls_right-cols } matrix; the divisor must be square (n-by-n)|.
    endif.

    if ls_left-cols <> ls_right-rows.
      raise exception type zcx_matrix
        exporting
          text = |Cannot divide a { ls_left-rows }-by-{ ls_left-cols } matrix by a { ls_right-rows }-by-{ ls_right-cols } matrix|.
    endif.
  endmethod.


  method invert.
    data(ls_shape) = get_shape( it_matrix ).
    if ls_shape-rows <> ls_shape-cols.
      raise exception type zcx_matrix
        exporting
          text = |Cannot invert a { ls_shape-rows }-by-{ ls_shape-cols } matrix; the matrix must be square|.
    endif.

    data(lv_n) = ls_shape-rows.
    if lv_n = 0.
      clear rt_inverse.
      return.
    endif.

    data lt_work type ty_matrix.
    data lv_i type i.
    data lv_j type i.
    data lv_row type ty_row.
    data lv_cell type ty_cell.

    lv_i = 0.
    while lv_i < lv_n.
      lv_i = lv_i + 1.
      lv_row = it_matrix[ lv_i ].
      lv_j = 0.
      while lv_j < lv_n.
        lv_j = lv_j + 1.
        lv_cell = cond ty_cell(
          when lv_j = lv_i then conv ty_cell( 1 )
          else conv ty_cell( 0 ) ).
        append lv_cell to lv_row.
      endwhile.
      append lv_row to lt_work.
    endwhile.

    data(lv_width) = lv_n * 2.
    data lv_pivot_row type i.
    data lv_max type ty_cell.
    data lv_candidate type ty_cell.
    data lv_pivot type ty_cell.
    data lv_factor type ty_cell.
    data lv_swap type ty_row.
    data lv_col type i.

    lv_i = 0.
    while lv_i < lv_n.
      lv_i = lv_i + 1.

      lv_pivot_row = lv_i.
      read table lt_work index lv_i assigning field-symbol(<ls_probe>).
      read table <ls_probe> index lv_i assigning field-symbol(<lv_diag>).
      lv_max = abs( <lv_diag> ).

      lv_j = lv_i.
      while lv_j < lv_n.
        lv_j = lv_j + 1.
        read table lt_work index lv_j assigning field-symbol(<ls_candidate>).
        read table <ls_candidate> index lv_i assigning field-symbol(<lv_cand>).
        lv_candidate = abs( <lv_cand> ).
        if lv_candidate > lv_max.
          lv_max = lv_candidate.
          lv_pivot_row = lv_j.
        endif.
      endwhile.

      if lv_max = 0.
        raise exception type zcx_matrix
          exporting
            text = |Divisor matrix is singular and cannot be inverted|.
      endif.

      if lv_pivot_row <> lv_i.
        read table lt_work index lv_i assigning field-symbol(<ls_a>).
        read table lt_work index lv_pivot_row assigning field-symbol(<ls_b>).
        lv_swap = <ls_a>.
        <ls_a> = <ls_b>.
        <ls_b> = lv_swap.
      endif.

      read table lt_work index lv_i assigning field-symbol(<ls_pivot_row>).
      read table <ls_pivot_row> index lv_i assigning field-symbol(<lv_pivot>).
      lv_pivot = <lv_pivot>.
      loop at <ls_pivot_row> assigning field-symbol(<lv_scale>).
        <lv_scale> = <lv_scale> / lv_pivot.
      endloop.

      lv_j = 0.
      while lv_j < lv_n.
        lv_j = lv_j + 1.
        if lv_j = lv_i.
          continue.
        endif.
        read table lt_work index lv_j assigning field-symbol(<ls_elim>).
        read table <ls_elim> index lv_i assigning field-symbol(<lv_factor>).
        lv_factor = <lv_factor>.
        if lv_factor = 0.
          continue.
        endif.
        lv_col = 0.
        while lv_col < lv_width.
          lv_col = lv_col + 1.
          read table <ls_elim> index lv_col assigning field-symbol(<lv_dest>).
          read table <ls_pivot_row> index lv_col assigning field-symbol(<lv_src>).
          <lv_dest> = <lv_dest> - lv_factor * <lv_src>.
        endwhile.
      endwhile.
    endwhile.

    rt_inverse = value #(
      for lv_r = 1 then lv_r + 1 until lv_r > lv_n
      ( value ty_row(
                      for lv_c = 1 then lv_c + 1 until lv_c > lv_n
                      ( lt_work[ lv_r ][ lv_c + lv_n ] ) ) ) ).
  endmethod.


  method to_string.
    data lt_lines type string_table.

    loop at it_matrix assigning field-symbol(<ls_row>).
      data(lv_line) = ``.
      loop at <ls_row> assigning field-symbol(<lv_cell>).
        data(lv_cell) = condense( conv string( <lv_cell> ) ).
        lv_line = cond #(
          when lv_line is initial then lv_cell
          else |{ lv_line } { lv_cell }| ).
      endloop.
      append lv_line to lt_lines.
    endloop.

    concatenate lines of lt_lines into rv_text separated by cl_abap_char_utilities=>newline.
  endmethod.


  method cell.
    rv_cell = iv_value.
  endmethod.
ENDCLASS.
