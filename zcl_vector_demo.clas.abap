class zcl_vector_demo definition
  public
  final
  create public.
  public section.
    "! Print add, subtract, scale, dot, cross, norm, and normalize examples.
    class-methods run.
  protected section.
  private section.
    class-methods write_vector
      importing
        iv_label  type clike
        it_vector type zcl_vector=>ty_vector.
endclass.
class zcl_vector_demo implementation.
  method run.
    data(lt_u) = zcl_vector=>of( iv_x = 1 iv_y = 2 iv_z = 3 ).
    data(lt_v) = zcl_vector=>of( iv_x = 4 iv_y = 5 iv_z = 6 ).
    data(lt_w) = zcl_vector=>of( iv_x = 3 iv_y = 4 ).
    write_vector( iv_label = 'u (3-D)' it_vector = lt_u ).
    write_vector( iv_label = 'v (3-D)' it_vector = lt_v ).
    write_vector( iv_label = 'w (2-D)' it_vector = lt_w ).
    try.
        write_vector(
          iv_label  = 'u + v'
          it_vector = zcl_vector=>add( it_left = lt_u it_right = lt_v ) ).
        write_vector(
          iv_label  = 'u - v'
          it_vector = zcl_vector=>subtract( it_left = lt_u it_right = lt_v ) ).
        write_vector(
          iv_label  = '2 * u'
          it_vector = zcl_vector=>scale( it_vector = lt_u iv_scalar = 2 ) ).
        write: / 'u · v =', condense( conv string( zcl_vector=>dot( it_left = lt_u it_right = lt_v ) ) ).
        write: /.
        write_vector(
          iv_label  = 'u × v'
          it_vector = zcl_vector=>cross( it_left = lt_u it_right = lt_v ) ).
        write: / '|w|   =', condense( conv string( zcl_vector=>norm( lt_w ) ) ).
        write: /.
        write_vector(
          iv_label  = 'ŵ'
          it_vector = zcl_vector=>normalize( lt_w ) ).
      catch zcx_matrix into data(lx_error).
        write: / 'Error:', lx_error->get_text( ).
    endtry.
    write: / 'Length mismatch (3-D + 2-D)'.
    try.
        zcl_vector=>add( it_left = lt_u it_right = lt_w ).
        write: / 'Unexpected success'.
      catch zcx_matrix into data(lx_len).
        write: / lx_len->get_text( ).
    endtry.
    write: /.
    write: / 'Cross product of 2-D vectors'.
    try.
        zcl_vector=>cross( it_left = lt_w it_right = lt_w ).
        write: / 'Unexpected success'.
      catch zcx_matrix into data(lx_cross).
        write: / lx_cross->get_text( ).
    endtry.
    write: /.
    write: / 'Normalize the zero vector'.
    try.
        zcl_vector=>normalize( zcl_vector=>create( iv_length = 3 ) ).
        write: / 'Unexpected success'.
      catch zcx_matrix into data(lx_zero).
        write: / lx_zero->get_text( ).
    endtry.
  endmethod.
  method write_vector.
    write: / |{ iv_label } = { zcl_vector=>to_string( it_vector ) }|.
    write: /.
  endmethod.
endclass.


