*--------------------------------------------------------------------*
* View - Call Const
*--------------------------------------------------------------------*
FORM u_view_callconst USING lt_programa TYPE STANDARD TABLE.

  DATA: lt_dba   TYPE scprvimsellist,
        ls_dba   LIKE LINE OF lt_dba,
        ls_programa TYPE string.

  LOOP AT lt_programa INTO ls_programa.
    ls_dba-viewfield = 'PROGRAMA'.
    ls_dba-operator  = 'EQ'.
    ls_dba-value     = ls_programa.
    ls_dba-and_or    = 'OR'.
    AT LAST.
      CLEAR ls_dba-and_or.
    ENDAT.
    APPEND ls_dba TO lt_dba.
    CLEAR ls_dba.
  ENDLOOP.

  CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
    EXPORTING
      action                       = 'S'
      view_name                    = 'ZOSVA_CONSTANTES'
    TABLES
      dba_sellist                  = lt_dba
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