*----------------------------------------------------------------------*
* View - call with bukrs
*----------------------------------------------------------------------*
FORM u_view_callbukrs USING ir_bukrs TYPE gtr_bukrs
                             i_name   TYPE dd02v-tabname.
  DATA: lt_dba      TYPE scprvimsellist,
        ls_dba      LIKE LINE OF lt_dba,
        ls_bukrs    LIKE LINE OF ir_bukrs,
        lt_excl     TYPE TABLE OF vimexclfun,
        ls_excl     LIKE LINE OF lt_excl.

  "1. Filtro de Sociedad
  LOOP AT ir_bukrs INTO ls_bukrs.
    ls_dba-viewfield = 'BUKRS'.
    ls_dba-operator  = 'EQ'.
    ls_dba-value     = ls_bukrs-low.
    ls_dba-and_or    = 'OR'.
    AT LAST.
      CLEAR ls_dba-and_or.
    ENDAT.
    APPEND ls_dba TO lt_dba.
    CLEAR ls_dba.
  ENDLOOP.

  "2. Filtro de botones
  ls_excl-function = 'DELE'.
  APPEND ls_excl TO lt_excl.

  ls_excl-function = 'KOPE'.
  APPEND ls_excl TO lt_excl.

  "3. Mostrar
  CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
    EXPORTING
      action                       = 'S'      "S See, U Update
      view_name                    = i_name
    TABLES
      dba_sellist                  = lt_dba
      excl_cua_funct               = lt_excl
    EXCEPTIONS
      client_reference             = 1
      foreign_lock                 = 2
      invalid_action               = 3
      no_clientindependent_auth    = 4
      no_database_function         = 5
      no_editor_function           = 6
      no_show_auth                 = 7
      no_tvdir_entry               = 8
      no_upd_auth                  = 9
      only_show_allowed            = 10
      system_failure               = 11
      unknown_field_in_dba_sellist = 12
      view_not_found               = 13
      maintenance_prohibited       = 14
      OTHERS                       = 15.
 IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
 ENDIF.
ENDFORM.