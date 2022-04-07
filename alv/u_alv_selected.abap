METHODS a_alv_selected IMPORTING it_data TYPE STANDARD TABLE EXPORTING rt_data TYPE STANDARD TABLE.

*----------------------------------------------------------------------*
* Get selected
*----------------------------------------------------------------------*
FORM u_alv_getselected USING io_alv TYPE REF TO cl_gui_alv_grid
                              it_data TYPE STANDARD TABLE
                        CHANGING rt_data TYPE STANDARD TABLE.
  METHOD a_alv_selected.
    DATA: lt_rows TYPE lvc_t_row,
          ls_rows LIKE LINE OF lt_rows,
          ls_layo TYPE lvc_s_layo.

    FIELD-SYMBOLS: <fs_data> TYPE any.

    go_alv->get_frontend_layout( IMPORTING es_layout = ls_layo ).
    go_alv->get_selected_rows( IMPORTING et_index_rows = lt_rows ).

    IF lt_rows IS INITIAL AND ls_layo-sel_mode <> 'A'.
      go_alv->get_current_cell( IMPORTING es_row_id = ls_rows ).
      APPEND ls_rows TO lt_rows.
    ENDIF.

    LOOP AT lt_rows INTO ls_rows.
      READ TABLE it_data ASSIGNING <fs_data> INDEX ls_rows-index.
      APPEND <fs_data> TO rt_data.
    ENDLOOP.
  ENDMETHOD.
ENDFORM.