METHOD r_alv_selected EXCEPTIONS error.

*----------------------------------------------------------------------*
* Selected
*----------------------------------------------------------------------*
  METHOD r_alv_selected.

    DATA: lt_row TYPE lvc_t_row,
          ls_row LIKE LINE OF lt_row.
    FIELD-SYMBOLS: <fs_g100> LIKE LINE gt_g100.

    "Clear select
    LOOP AT gt_g100 ASSIGNING FIELD-SYMBOL(<fs_g100>).
      CLEAR <fs_g100>-selec.
    ENDLOOP.

    "Set select
    go_alv->get_selected_rows( IMPORTING et_index_rows = lt_row ).
    IF lt_row IS INITIAL AND ls_layo-sel_mode <> 'A'.
      go_alv->get_current_cell( IMPORTING es_row_id = ls_row ).
      APPEND ls_row TO lt_row.
    ENDIF.
    LOOP AT lt_row INTO ls_row.
      READ TABLE gt_g100 ASSIGNING <fs_g100> INDEX ls_row-index.
      IF sy-subrc = 0.
        <fs_g100>-selec = abap_on.
      ENDIF.
    ENDLOOP.

    IF lt_row IS INITIAL.
      RAISING error.
    ENDIF.
  ENDMETHOD.