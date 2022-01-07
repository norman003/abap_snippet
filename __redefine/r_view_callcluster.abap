*----------------------------------------------------------------------*
* View - Call cluster
*----------------------------------------------------------------------*
FORM r_view_callcluster USING ir_bukrs TYPE gtr_bukrs
                               i_name   TYPE vcldir-vclname.
  DATA: lt_cluster  TYPE vclty_sellist_table,
        ls_cluster  LIKE LINE OF lt_cluster,
        lt_dba      TYPE scprvimsellist,
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

  "Usuario
  ls_cluster-object  = 'ZOSVA_MUSU'.
  ls_cluster-sellist = lt_dba.
  APPEND ls_cluster TO lt_cluster.

  "Flujo
  ls_cluster-object  = 'ZOSVA_MFPRO'.
  ls_cluster-sellist = lt_dba.
  APPEND ls_cluster TO lt_cluster.

  "Area de Jerarquia
  ls_cluster-object  = 'ZOSVA_MAJER'.
  ls_cluster-sellist = lt_dba.
  APPEND ls_cluster TO lt_cluster.

  "2. Filtro de botones
  ls_excl-function = 'DELE'.
  APPEND ls_excl TO lt_excl.


  "3. Mostrar
  CALL FUNCTION 'VIEWCLUSTER_MAINTENANCE_CALL'
    EXPORTING
      viewcluster_name             = i_name
      "start_object                 = 'ZOSVA_MUSU'
      maintenance_action           = 'S'
    TABLES
      dba_sellist_cluster          = lt_cluster
      excl_cua_funct_all_objects   = lt_excl
    EXCEPTIONS
      client_reference             = 1
      foreign_lock                 = 2
      viewcluster_not_found        = 3
      viewcluster_is_inconsistent  = 4
      missing_generated_function   = 5
      no_upd_auth                  = 6
      no_show_auth                 = 7
      object_not_found             = 8
      no_tvdir_entry               = 9
      no_clientindep_auth          = 10
      invalid_action               = 11
      saving_correction_failed     = 12
      system_failure               = 13
      unknown_field_in_dba_sellist = 14
      missing_corr_number          = 15
      OTHERS                       = 16.
 IF sy-subrc <> 0.
   MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
 ENDIF.
ENDFORM.