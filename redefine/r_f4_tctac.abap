*----------------------------------------------------------------------*
* Help - tctac
*----------------------------------------------------------------------*
FORM u_f4_tctac CHANGING e_out TYPE clike.
  TYPES: BEGIN OF ty_f4,
           subty TYPE t591s-subty,
           stext TYPE t591s-stext,
         END OF ty_f4.

  DATA: lt_f4     TYPE TABLE OF ty_f4,
        lt_return TYPE ism_ddshretval,
        ls_return LIKE LINE OF lt_return.

  "Get
  SELECT subty stext INTO TABLE lt_f4 FROM t591s WHERE sprsl = sy-langu AND infty = '9006'.

  "Show
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'SUBTY'
      window_title = 'Cod.Préstamo'
      value_org    = 'S'
    TABLES
      value_tab    = lt_f4
      return_tab   = lt_return.

  "Return
  READ TABLE lt_return INTO ls_return INDEX 1.
  IF sy-subrc = 0.
    e_out = ls_return-fieldval.
  ELSE.
    MESSAGE s000(su) WITH 'Accion cancelada...' DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.