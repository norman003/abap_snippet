METHODS u_alv_ischanged EXCEPTION error.

*----------------------------------------------------------------------*
* Alv - Lee cambios
*----------------------------------------------------------------------*
FORM u_alv_ischanged.
  METHOD u_alv_ischanged.
    DATA: lo_alv  TYPE REF TO cl_gui_alv_grid,
          l_valid TYPE c.

    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = lo_alv.

    "Verifica la consistencia de los datos
    lo_alv->check_changed_data( IMPORTING e_valid = l_valid ).

    IF l_valid IS INITIAL.
      RAISE error.
    ENDIF.
  ENDMETHOD.
ENDFORM.