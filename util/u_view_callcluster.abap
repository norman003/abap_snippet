*--------------------------------------------------------------------*
* View - Cluster
*--------------------------------------------------------------------*
FORM u_view_callcluster USING i_view TYPE clike.

  CALL FUNCTION 'VIEWCLUSTER_MAINTENANCE_CALL'
    EXPORTING
      viewcluster_name             = i_view
      maintenance_action           = 'S'
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
ENDFORM.                    "_viewclustercall