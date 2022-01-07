*----------------------------------------------------------------------*
* Submit
*----------------------------------------------------------------------*
FORM r_submit.

  SUBMIT zosfi_rpt_registro_percepcion
    WITH p_bukrs  EQ i_bukrs
    WITH s_cpnumb IN lr_cpnumber
    WITH p_ple    EQ space
    WITH p_expmem EQ 'X'
    AND RETURN.

  TRY .
      IMPORT lt_memory = lt_memory FROM MEMORY ID 'ZOSFI_RPT_REGISTRO_PERCEPCION'.
      FREE MEMORY ID 'ZOSFI_RPT_REGISTRO_PERCEPCION'.

    CATCH cx_root INTO lo_error.
      lw_message = lo_error->get_text( ).
      MESSAGE e000 WITH lw_message RAISING error.
  ENDTRY.
ENDIF.