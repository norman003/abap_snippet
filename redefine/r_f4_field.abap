*----------------------------------------------------------------------*
* Help - Field
*----------------------------------------------------------------------*
FORM r_help_field USING i_input TYPE clike
                   CHANGING e_out TYPE clike.
  TYPES: BEGIN OF ty_f4,
           bname TYPE zostb_musu-bname,
           name1 TYPE zostb_musu-name1,
         END OF ty_f4.

  DATA: lt_f4     TYPE TABLE OF ty_f4,
        lt_return TYPE ism_ddshretval,
        ls_return LIKE LINE OF lt_return.

  "Val
  CHECK i_input IS NOT INITIAL.

  "Get
  SELECT bname name1
    INTO TABLE lt_f4
    FROM zostb_musu
   WHERE bukrs = go_db->gs_musu-bukrs
     AND tusid = go_db->gc_tusid-solicitante_super
     AND jrqnr = go_db->gs_musu-jrqnr
     AND statu = go_db->gs_musu-statu.

  "Show
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield     = 'BNAME'
      window_title = 'Usuarios'
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