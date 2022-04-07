*----------------------------------------------------------------------*
* Vl02n - Delete
*----------------------------------------------------------------------*
FORM r_vl02n_delete USING is_likp type likp
                           et_return type bapirettab.

  DATA: ls_header_data       TYPE bapiobdlvhdrchg,
       ls_header_control     TYPE bapiobdlvhdrctrlchg,
       ls_header_data_spl    TYPE /spe/bapiobdlvhdrchg,
       ls_header_control_spl TYPE /spe/bapiobdlvhdrctrlchg,

       ls_return             TYPE bapiret2,
       l_lines               TYPE i.

* 1. Llenar data
  ls_header_data-deliv_numb        = is_likp-vbeln. "N° entrega
  ls_header_data_spl-deliv_numb    = is_likp-vbeln. "N° entrega

  ls_header_control-deliv_numb     = is_likp-vbeln. "N° entrega
  ls_header_control_spl-deliv_numb = is_likp-vbeln. "N° entrega

* 2. Borrar entrega
  CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
    EXPORTING
      header_data        = ls_header_data
      header_control     = ls_header_control
      delivery           = ls_header_data-deliv_numb
      header_data_spl    = ls_header_data_spl
      header_control_spl = ls_header_control_spl
      sender_system      = ' '
    TABLES
      return             = et_return
    EXCEPTIONS
      error              = 1.

* 3. Retorno
  DESCRIBE TABLE et_return LINES l_lines.
  READ TABLE et_return INTO ls_return INDEX l_lines.
  IF ls_return-type = 'E'.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    sy-subrc = 1.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.
  ENDIF.

ENDFORM.