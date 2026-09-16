CLASS zcx_matrix DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS constructor
      IMPORTING
        text     TYPE clike
        previous LIKE previous OPTIONAL.

    METHODS get_text REDEFINITION.

  PRIVATE SECTION.
    DATA mv_text TYPE string.
ENDCLASS.


CLASS zcx_matrix IMPLEMENTATION.

  METHOD constructor.
    super->constructor( previous = previous ).
    mv_text = text.
  ENDMETHOD.


  METHOD get_text.
    result = mv_text.
  ENDMETHOD.

ENDCLASS.
