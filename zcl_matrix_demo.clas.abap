class zcl_matrix_demo definition
  public
  final
  create public.

  public section.
    "! Print add, subtract, multiply, divide, transpose, and scale examples.
    class-methods run.

  protected section.
  private section.
    class-methods write_real
      importing
        it_matrix type zcl_matrix=>ty_matrix.

    class-methods write_complex
      importing
        it_matrix type zcl_complex_matrix=>ty_matrix.
ENDCLASS.



CLASS ZCL_MATRIX_DEMO IMPLEMENTATION.


  method run.
    data(lt_a) = value zcl_matrix=>ty_matrix(
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 1 ) )
                                  ( zcl_matrix=>cell( 2 ) )
                                  ( zcl_matrix=>cell( 3 ) ) ) )
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 4 ) )
                                  ( zcl_matrix=>cell( 5 ) )
                                  ( zcl_matrix=>cell( 6 ) ) ) ) ).

    data(lt_b) = value zcl_matrix=>ty_matrix(
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 7 ) )
                                  ( zcl_matrix=>cell( 8 ) )
                                  ( zcl_matrix=>cell( 9 ) ) ) )
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 1 ) )
                                  ( zcl_matrix=>cell( 1 ) )
                                  ( zcl_matrix=>cell( 1 ) ) ) ) ).

    write: / 'Matrix A (2-by-3)'.
    write_real( lt_a ).

    try.
        data(lt_at) = zcl_matrix_transposer=>transpose( lt_a ).
        write: / 'A transposed (3-by-2)'.
        write_real( lt_at ).
      catch zcx_matrix into data(lx_tr).
        write: / 'Error:', lx_tr->get_text( ).
    endtry.

    try.
        data(lt_scaled) = zcl_matrix_scalar_multiplier=>multiply(
          it_matrix = lt_a
          iv_scalar = zcl_matrix=>cell( 2 ) ).
        write: / '2 * A'.
        write_real( lt_scaled ).
      catch zcx_matrix into data(lx_scale).
        write: / 'Error:', lx_scale->get_text( ).
    endtry.

    write: / 'Matrix B (2-by-3)'.
    write_real( lt_b ).

    try.
        data(lt_sum) = zcl_matrix_adder=>add(
          it_left  = lt_a
          it_right = lt_b ).
        write: / 'A + B'.
        write_real( lt_sum ).
      catch zcx_matrix into data(lx_add).
        write: / 'Error:', lx_add->get_text( ).
    endtry.

    try.
        data(lt_diff) = zcl_matrix_subtractor=>subtract(
          it_left  = lt_a
          it_right = lt_b ).
        write: / 'A - B'.
        write_real( lt_diff ).
      catch zcx_matrix into data(lx_sub).
        write: / 'Error:', lx_sub->get_text( ).
    endtry.

    data(lt_c) = value zcl_matrix=>ty_matrix(
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 7 ) )
                                  ( zcl_matrix=>cell( 8 ) ) ) )
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 9 ) )
                                  ( zcl_matrix=>cell( 10 ) ) ) )
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 11 ) )
                                  ( zcl_matrix=>cell( 12 ) ) ) ) ).

    write: / 'Matrix C (3-by-2)'.
    write_real( lt_c ).

    try.
        data(lt_product) = zcl_matrix_multiplier=>multiply(
          it_left  = lt_a
          it_right = lt_c ).
        write: / 'A * C  (2-by-3 times 3-by-2)'.
        write_real( lt_product ).
      catch zcx_matrix into data(lx_mul).
        write: / 'Error:', lx_mul->get_text( ).
    endtry.

    write: /.
    write: / 'Inner dimension mismatch (2-by-3 times 2-by-2)'.
    data(lt_wrong) = value zcl_matrix=>ty_matrix(
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 1 ) )
                                  ( zcl_matrix=>cell( 2 ) ) ) )
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 3 ) )
                                  ( zcl_matrix=>cell( 4 ) ) ) ) ).
    try.
        zcl_matrix_multiplier=>multiply(
          it_left  = lt_a
          it_right = lt_wrong ).
        write: / 'Unexpected success'.
      catch zcx_matrix into data(lx_mismatch).
        write: / lx_mismatch->get_text( ).
    endtry.

    data(lt_d) = value zcl_matrix=>ty_matrix(
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 1 ) )
                                  ( zcl_matrix=>cell( 0 ) ) ) )
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 0 ) )
                                  ( zcl_matrix=>cell( 2 ) ) ) ) ).
    data(lt_e) = value zcl_matrix=>ty_matrix(
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 1 ) )
                                  ( zcl_matrix=>cell( 2 ) ) ) )
      ( value zcl_matrix=>ty_row(
                                  ( zcl_matrix=>cell( 3 ) )
                                  ( zcl_matrix=>cell( 4 ) ) ) ) ).

    write: /.
    write: / 'Matrix E (2-by-2)'.
    write_real( lt_e ).
    write: / 'Matrix D (2-by-2 divisor)'.
    write_real( lt_d ).

    try.
        data(lt_quot) = zcl_matrix_divider=>divide(
          it_left  = lt_e
          it_right = lt_d ).
        write: / 'E / D  (E * D inverse)'.
        write_real( lt_quot ).
      catch zcx_matrix into data(lx_div).
        write: / 'Error:', lx_div->get_text( ).
    endtry.

    write: / 'Non-square divisor (2-by-3 divided by 3-by-2)'.
    try.
        zcl_matrix_divider=>divide(
          it_left  = lt_a
          it_right = lt_c ).
        write: / 'Unexpected success'.
      catch zcx_matrix into data(lx_nonsquare).
        write: / lx_nonsquare->get_text( ).
    endtry.

    write: /.
    write: / '--- Complex matrices ---'.
    data(lt_p) = value zcl_complex_matrix=>ty_matrix(
      ( value zcl_complex_matrix=>ty_row(
                                          ( zcl_complex_matrix=>cell( iv_re = 1 iv_im = 1 ) )
                                          ( zcl_complex_matrix=>cell( iv_re = 2 ) ) ) )
      ( value zcl_complex_matrix=>ty_row(
                                          ( zcl_complex_matrix=>cell( iv_re = 3 ) )
                                          ( zcl_complex_matrix=>cell( iv_re = 4 iv_im = -1 ) ) ) ) ).
    data(lt_q) = value zcl_complex_matrix=>ty_matrix(
      ( value zcl_complex_matrix=>ty_row(
                                          ( zcl_complex_matrix=>cell( iv_re = 1 ) )
                                          ( zcl_complex_matrix=>cell( iv_re = 0 iv_im = 1 ) ) ) )
      ( value zcl_complex_matrix=>ty_row(
                                          ( zcl_complex_matrix=>cell( iv_re = 0 ) )
                                          ( zcl_complex_matrix=>cell( iv_re = 1 ) ) ) ) ).

    write: / 'Complex P (2-by-2)'.
    write_complex( lt_p ).
    write: / 'Complex Q (2-by-2)'.
    write_complex( lt_q ).

    try.
        data(lt_cx_sum) = zcl_complex_matrix=>add( it_left = lt_p it_right = lt_q ).
        write: / 'P + Q'.
        write_complex( lt_cx_sum ).

        data(lt_cx_diff) = zcl_complex_matrix=>subtract( it_left = lt_p it_right = lt_q ).
        write: / 'P - Q'.
        write_complex( lt_cx_diff ).

        data(lt_cx_prod) = zcl_complex_matrix=>multiply( it_left = lt_p it_right = lt_q ).
        write: / 'P * Q'.
        write_complex( lt_cx_prod ).

        data(lt_cx_scaled) = zcl_complex_matrix=>scale(
          it_matrix = lt_p
          is_scalar = zcl_complex_matrix=>cell( iv_re = 0 iv_im = 1 ) ).
        write: / 'i * P'.
        write_complex( lt_cx_scaled ).

        data(lt_cx_t) = zcl_complex_matrix=>transpose( lt_p ).
        write: / 'P transposed'.
        write_complex( lt_cx_t ).

        data(lt_cx_quot) = zcl_complex_matrix=>divide(
          it_left  = lt_p
          it_right = zcl_complex_matrix=>identity( 2 ) ).
        write: / 'P / I'.
        write_complex( lt_cx_quot ).
      catch zcx_matrix into data(lx_cx).
        write: / 'Error:', lx_cx->get_text( ).
    endtry.
  endmethod.


  method write_complex.
    data(lv_text) = zcl_complex_matrix=>to_string( it_matrix ).
    split lv_text at cl_abap_char_utilities=>newline into table data(lt_lines).
    loop at lt_lines assigning field-symbol(<lv_line>).
      write: / <lv_line>.
    endloop.
    write: /.
  endmethod.


  method write_real.
    data(lv_text) = zcl_matrix=>to_string( it_matrix ).
    split lv_text at cl_abap_char_utilities=>newline into table data(lt_lines).
    loop at lt_lines assigning field-symbol(<lv_line>).
      write: / <lv_line>.
    endloop.
    write: /.
  endmethod.
ENDCLASS.
