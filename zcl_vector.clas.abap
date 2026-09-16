class zcl_vector definition
  public
  final
  create public.

  public section.
    types:
      ty_cell   type decfloat34,
      ty_vector type standard table of ty_cell with empty key.

    "! Convert a number to a vector component. Use this (or CONV decfloat34)
    "! in VALUE constructors; integer literals are type I and are not
    "! compatible with a DECFLOAT34 line type.
    class-methods cell
      importing
        iv_value       type ty_cell
      returning
        value(rv_cell) type ty_cell.

    "! Build a 2-D or 3-D vector from components.
    class-methods of
      importing
        iv_x             type ty_cell
        iv_y             type ty_cell
        iv_z             type ty_cell optional
      returning
        value(rt_vector) type ty_vector.

    "! Create a vector of iv_length components filled with iv_fill.
    class-methods create
      importing
        iv_length        type i
        iv_fill          type ty_cell default 0
      returning
        value(rt_vector) type ty_vector
      raising
        zcx_matrix.

    class-methods length
      importing
        it_vector        type ty_vector
      returning
        value(rv_length) type i.

    class-methods add
      importing
        it_left       type ty_vector
        it_right      type ty_vector
      returning
        value(rt_sum) type ty_vector
      raising
        zcx_matrix.

    class-methods subtract
      importing
        it_left        type ty_vector
        it_right       type ty_vector
      returning
        value(rt_diff) type ty_vector
      raising
        zcx_matrix.

    "! Multiply every component by a real scalar.
    class-methods scale
      importing
        it_vector        type ty_vector
        iv_scalar        type ty_cell
      returning
        value(rt_scaled) type ty_vector.

    "! Dot product. Both vectors must have the same length.
    class-methods dot
      importing
        it_left       type ty_vector
        it_right      type ty_vector
      returning
        value(rv_dot) type ty_cell
      raising
        zcx_matrix.

    "! Cross product. Both vectors must be 3-D.
    class-methods cross
      importing
        it_left         type ty_vector
        it_right        type ty_vector
      returning
        value(rt_cross) type ty_vector
      raising
        zcx_matrix.

    "! Euclidean length sqrt(x1² + x2² + ...).
    class-methods norm
      importing
        it_vector      type ty_vector
      returning
        value(rv_norm) type ty_cell.

    "! Return a unit vector in the same direction. Zero vectors raise.
    class-methods normalize
      importing
        it_vector      type ty_vector
      returning
        value(rt_unit) type ty_vector
      raising
        zcx_matrix.

    class-methods to_string
      importing
        it_vector      type ty_vector
      returning
        value(rv_text) type string.

  protected section.
  private section.
    class-methods assert_same_length
      importing
        it_left      type ty_vector
        it_right     type ty_vector
        iv_operation type string
      raising
        zcx_matrix.
ENDCLASS.



CLASS ZCL_VECTOR IMPLEMENTATION.


  method add.
    assert_same_length( it_left = it_left it_right = it_right iv_operation = 'add' ).

    rt_sum = value #(
      for <lv_left> in it_left index into lv_i
      ( <lv_left> + it_right[ lv_i ] ) ).
  endmethod.


  method assert_same_length.
    if lines( it_left ) <> lines( it_right ).
      raise exception type zcx_matrix
        exporting
          text = |Cannot { iv_operation } vectors of length { lines( it_left ) } and { lines( it_right ) }|.
    endif.
  endmethod.


  method cell.
    rv_cell = iv_value.
  endmethod.


  method create.
    if iv_length < 0.
      raise exception type zcx_matrix
        exporting
          text = |Vector length must be non-negative (got { iv_length })|.
    endif.

    rt_vector = value #(
      for lv_i = 1 then lv_i + 1 until lv_i > iv_length
      ( cell( iv_fill ) ) ).
  endmethod.


  method cross.
    if lines( it_left ) <> 3 or lines( it_right ) <> 3.
      raise exception type zcx_matrix
        exporting
          text = |Cross product requires two 3-D vectors (got { lines( it_left ) } and { lines( it_right ) })|.
    endif.

    data(lv_x1) = it_left[ 1 ].
    data(lv_y1) = it_left[ 2 ].
    data(lv_z1) = it_left[ 3 ].
    data(lv_x2) = it_right[ 1 ].
    data(lv_y2) = it_right[ 2 ].
    data(lv_z2) = it_right[ 3 ].

    append lv_y1 * lv_z2 - lv_z1 * lv_y2 to rt_cross.
    append lv_z1 * lv_x2 - lv_x1 * lv_z2 to rt_cross.
    append lv_x1 * lv_y2 - lv_y1 * lv_x2 to rt_cross.
  endmethod.


  method dot.
    assert_same_length( it_left = it_left it_right = it_right iv_operation = 'dot' ).

    rv_dot = reduce ty_cell(
      init lv_acc = conv ty_cell( 0 )
      for <lv_left> in it_left index into lv_i
      next lv_acc = lv_acc + <lv_left> * it_right[ lv_i ] ).
  endmethod.


  method length.
    rv_length = lines( it_vector ).
  endmethod.


  method norm.
    data(lv_sum_sq) = reduce ty_cell(
      init lv_acc = conv ty_cell( 0 )
      for <lv_cell> in it_vector
      next lv_acc = lv_acc + <lv_cell> * <lv_cell> ).

    rv_norm = conv ty_cell( sqrt( conv f( lv_sum_sq ) ) ).
  endmethod.


  method normalize.
    data(lv_norm) = norm( it_vector ).
    if lv_norm = 0.
      raise exception type zcx_matrix
        exporting
          text = |Cannot normalize the zero vector|.
    endif.

    rt_unit = scale( it_vector = it_vector iv_scalar = conv ty_cell( 1 ) / lv_norm ).
  endmethod.


  method of.
    append cell( iv_x ) to rt_vector.
    append cell( iv_y ) to rt_vector.
    if iv_z is supplied.
      append cell( iv_z ) to rt_vector.
    endif.
  endmethod.


  method scale.
    rt_scaled = value #(
      for <lv_cell> in it_vector
      ( iv_scalar * <lv_cell> ) ).
  endmethod.


  method subtract.
    assert_same_length( it_left = it_left it_right = it_right iv_operation = 'subtract' ).

    rt_diff = value #(
      for <lv_left> in it_left index into lv_i
      ( <lv_left> - it_right[ lv_i ] ) ).
  endmethod.


  method to_string.
    data lt_parts type string_table.

    loop at it_vector assigning field-symbol(<lv_cell>).
      append condense( conv string( <lv_cell> ) ) to lt_parts.
    endloop.

    concatenate lines of lt_parts into rv_text separated by ` `.
  endmethod.
ENDCLASS.
