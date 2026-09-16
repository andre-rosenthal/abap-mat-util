class zcl_complex_matrix definition
  public
  final
  create public.

  public section.
    types:
      ty_complex type zcl_complex=>ty_complex,
      ty_cell    type ty_complex,
      ty_row     type standard table of ty_cell with empty key,
      ty_matrix  type standard table of ty_row with empty key.

    types:
      begin of ty_shape,
        rows type i,
        cols type i,
      end of ty_shape.

    class-methods cell
      importing
        iv_re          type decfloat34
        iv_im          type decfloat34 default 0
      returning
        value(rs_cell) type ty_complex.

    class-methods create
      importing
        iv_rows          type i
        iv_cols          type i
        is_fill          type ty_complex optional
      returning
        value(rt_matrix) type ty_matrix
      raising
        zcx_matrix.

    class-methods identity
      importing
        iv_size          type i
      returning
        value(rt_matrix) type ty_matrix
      raising
        zcx_matrix.

    class-methods get_shape
      importing
        it_matrix       type ty_matrix
      returning
        value(rs_shape) type ty_shape
      raising
        zcx_matrix.

    class-methods add
      importing
        it_left       type ty_matrix
        it_right      type ty_matrix
      returning
        value(rt_sum) type ty_matrix
      raising
        zcx_matrix.

    class-methods subtract
      importing
        it_left        type ty_matrix
        it_right       type ty_matrix
      returning
        value(rt_diff) type ty_matrix
      raising
        zcx_matrix.

    class-methods multiply
      importing
        it_left           type ty_matrix
        it_right          type ty_matrix
      returning
        value(rt_product) type ty_matrix
      raising
        zcx_matrix.

    class-methods divide
      importing
        it_left            type ty_matrix
        it_right           type ty_matrix
      returning
        value(rt_quotient) type ty_matrix
      raising
        zcx_matrix.

    class-methods transpose
      importing
        it_matrix            type ty_matrix
      returning
        value(rt_transposed) type ty_matrix
      raising
        zcx_matrix.

    class-methods scale
      importing
        it_matrix        type ty_matrix
        is_scalar        type ty_complex
      returning
        value(rt_scaled) type ty_matrix
      raising
        zcx_matrix.

    class-methods invert
      importing
        it_matrix         type ty_matrix
      returning
        value(rt_inverse) type ty_matrix
      raising
        zcx_matrix.

    class-methods to_string
      importing
        it_matrix      type ty_matrix
      returning
        value(rv_text) type string.

  protected section.
  private section.
    class-methods assert_same_shape
      importing
        it_left      type ty_matrix
        it_right     type ty_matrix
        iv_operation type string
      raising
        zcx_matrix.

    class-methods assert_multipliable
      importing
        it_left  type ty_matrix
        it_right type ty_matrix
      raising
        zcx_matrix.

    class-methods assert_dividable
      importing
        it_left  type ty_matrix
        it_right type ty_matrix
      raising
        zcx_matrix.
ENDCLASS.



CLASS ZCL_COMPLEX_MATRIX IMPLEMENTATION.


  method cell.
    rs_cell = zcl_complex=>from( iv_re = iv_re iv_im = iv_im ).
  endmethod.


  method create.
    if iv_rows < 0 or iv_cols < 0.
      raise exception type zcx_matrix
        exporting
          text = |Matrix dimensions must be non-negative (got { iv_rows }-by-{ iv_cols })|.
    endif.

    data(ls_fill) = is_fill.
    rt_matrix = value #(
      for lv_row = 1 then lv_row + 1 until lv_row > iv_rows
      ( value ty_row(
                      for lv_col = 1 then lv_col + 1 until lv_col > iv_cols
                      ( ls_fill ) ) ) ).
  endmethod.


  method identity.
    rt_matrix = create( iv_rows = iv_size iv_cols = iv_size ).
    data(lv_i) = 0.
    while lv_i < iv_size.
      lv_i = lv_i + 1.
      read table rt_matrix index lv_i assigning field-symbol(<ls_row>).
      read table <ls_row> index lv_i assigning field-symbol(<ls_cell>).
      <ls_cell> = zcl_complex=>one( ).
    endwhile.
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


  method add.
    assert_same_shape( it_left = it_left it_right = it_right iv_operation = 'add' ).

    rt_sum = value #(
      for <ls_left_row> in it_left index into lv_row
      ( value ty_row(
                      for <ls_left> in <ls_left_row> index into lv_col
                      ( zcl_complex=>add(
                      is_left  = <ls_left>
                      is_right = it_right[ lv_row ][ lv_col ] ) ) ) ) ).
  endmethod.


  method subtract.
    assert_same_shape( it_left = it_left it_right = it_right iv_operation = 'subtract' ).

    rt_diff = value #(
      for <ls_left_row> in it_left index into lv_row
      ( value ty_row(
                      for <ls_left> in <ls_left_row> index into lv_col
                      ( zcl_complex=>subtract(
                      is_left  = <ls_left>
                      is_right = it_right[ lv_row ][ lv_col ] ) ) ) ) ).
  endmethod.


  method multiply.
    assert_multipliable( it_left = it_left it_right = it_right ).

    data(ls_left)  = get_shape( it_left ).
    data(ls_right) = get_shape( it_right ).

    rt_product = value #(
      for lv_i = 1 then lv_i + 1 until lv_i > ls_left-rows
      ( value ty_row(
          for lv_j = 1 then lv_j + 1 until lv_j > ls_right-cols
          ( reduce ty_complex(
              init ls_acc = zcl_complex=>zero( )
              for lv_k = 1 then lv_k + 1 until lv_k > ls_left-cols
              next ls_acc = zcl_complex=>add(
                is_left  = ls_acc
                is_right = zcl_complex=>multiply(
                  is_left  = it_left[ lv_i ][ lv_k ]
                  is_right = it_right[ lv_k ][ lv_j ] ) ) ) ) ) ) ).
  endmethod.


  method divide.
    assert_dividable( it_left = it_left it_right = it_right ).

    rt_quotient = multiply(
      it_left  = it_left
      it_right = invert( it_right ) ).
  endmethod.


  method transpose.
    data(ls_shape) = get_shape( it_matrix ).

    rt_transposed = value #(
      for lv_col = 1 then lv_col + 1 until lv_col > ls_shape-cols
      ( value ty_row(
                      for lv_row = 1 then lv_row + 1 until lv_row > ls_shape-rows
                      ( it_matrix[ lv_row ][ lv_col ] ) ) ) ).
  endmethod.


  method scale.
    get_shape( it_matrix ).

    rt_scaled = value #(
      for <ls_row> in it_matrix
      ( value ty_row(
                      for <ls_cell> in <ls_row>
                      ( zcl_complex=>multiply( is_left = is_scalar is_right = <ls_cell> ) ) ) ) ).
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
    data ls_cell type ty_complex.

    lv_i = 0.
    while lv_i < lv_n.
      lv_i = lv_i + 1.
      lv_row = it_matrix[ lv_i ].
      lv_j = 0.
      while lv_j < lv_n.
        lv_j = lv_j + 1.
        ls_cell = cond ty_complex(
          when lv_j = lv_i then zcl_complex=>one( )
          else zcl_complex=>zero( ) ).
        append ls_cell to lv_row.
      endwhile.
      append lv_row to lt_work.
    endwhile.

    data(lv_width) = lv_n * 2.
    data lv_pivot_row type i.
    data lv_max type decfloat34.
    data lv_candidate type decfloat34.
    data ls_pivot type ty_complex.
    data ls_factor type ty_complex.
    data lv_swap type ty_row.
    data lv_col type i.

    lv_i = 0.
    while lv_i < lv_n.
      lv_i = lv_i + 1.

      lv_pivot_row = lv_i.
      read table lt_work index lv_i assigning field-symbol(<ls_probe>).
      read table <ls_probe> index lv_i assigning field-symbol(<ls_diag>).
      lv_max = zcl_complex=>abs_squared( <ls_diag> ).

      lv_j = lv_i.
      while lv_j < lv_n.
        lv_j = lv_j + 1.
        read table lt_work index lv_j assigning field-symbol(<ls_cand_row>).
        read table <ls_cand_row> index lv_i assigning field-symbol(<ls_cand>).
        lv_candidate = zcl_complex=>abs_squared( <ls_cand> ).
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
      read table <ls_pivot_row> index lv_i assigning field-symbol(<ls_pivot>).
      ls_pivot = <ls_pivot>.
      loop at <ls_pivot_row> assigning field-symbol(<ls_scale>).
        <ls_scale> = zcl_complex=>divide( is_left = <ls_scale> is_right = ls_pivot ).
      endloop.

      lv_j = 0.
      while lv_j < lv_n.
        lv_j = lv_j + 1.
        if lv_j = lv_i.
          continue.
        endif.
        read table lt_work index lv_j assigning field-symbol(<ls_elim>).
        read table <ls_elim> index lv_i assigning field-symbol(<ls_factor>).
        ls_factor = <ls_factor>.
        if zcl_complex=>is_zero( ls_factor ) = abap_true.
          continue.
        endif.
        lv_col = 0.
        while lv_col < lv_width.
          lv_col = lv_col + 1.
          read table <ls_elim> index lv_col assigning field-symbol(<ls_dest>).
          read table <ls_pivot_row> index lv_col assigning field-symbol(<ls_src>).
          <ls_dest> = zcl_complex=>subtract(
            is_left  = <ls_dest>
            is_right = zcl_complex=>multiply( is_left = ls_factor is_right = <ls_src> ) ).
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
      loop at <ls_row> assigning field-symbol(<ls_cell>).
        data(lv_cell) = zcl_complex=>to_string( <ls_cell> ).
        lv_line = cond #(
          when lv_line is initial then lv_cell
          else |{ lv_line } { lv_cell }| ).
      endloop.
      append lv_line to lt_lines.
    endloop.

    concatenate lines of lt_lines into rv_text separated by cl_abap_char_utilities=>newline.
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
ENDCLASS.
