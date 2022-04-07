*----------------------------------------------------------------------*
* Evento UC
*----------------------------------------------------------------------*
FORM uc_create_pedido_liq.
  DATA: lt_report TYPE gtt_report,
        ls_report TYPE gty_report,
        lt_return TYPE bapirettab.

*1. Selección, valida, confirma
  zossd_pedidos_liq_cons=>is_selec_valid_liq(
    EXPORTING
      it_report   = ct_report
      i_question  = 'Desea liquidar los pedidos'
    IMPORTING
      et_report   = lt_report
    EXCEPTIONS
      error       = 1
  ).
  IF sy-subrc <> 0.
    PERFORM print_error. RETURN.
  ENDIF.

  "1.2 [Caso especial]
  "A. Cuando sea tarifa fija enviar monto = 1
  READ TABLE lt_report INTO ls_report INDEX 1.
  IF ls_report-auart IN zliq-r_auart_caso1.
    PERFORM caso_especial_tarifa_fija CHANGING lt_report.
  ENDIF.

*2. Crear Pedido Liquidación y Actualizar Liquidados
  zossd_pedidos_liq_cons=>create_pedido_liq(
    CHANGING
      ct_report     = lt_report
    EXCEPTIONS
      error         = 1
  ). 

*3. Mensaje y Update
  IF sy-subrc <> 0.
    PERFORM show_return USING lt_return.
  ELSE.
    PERFORM print_error.
  ENDIF.
  ct_report = lt_report.
ENDFORM.

*--------------------------------------------------------------------*
* Generar archivo txt
*--------------------------------------------------------------------*
FORM alv100_btn1_generatefile CHANGING ct_report TYPE gtt_report.
  DATA: ls_filecab TYPE gty_filecab.
  DATA: ls_filedet TYPE gty_filedet.

  FIELD-SYMBOLS: <fs_report> LIKE LINE OF ct_report.

* 1. Seleccion
  LOOP AT ct_report TRANSPORTING NO FIELDS WHERE box = abap_off.
    MESSAGE s000 WITH text-s01.
    LEAVE LIST-PROCESSING.
  ENDLOOP.

  PERFORM _isconfirm USING text-c02.

* 2. Do
  LOOP AT ct_report ASSIGNING <fs_report> WHERE box = abap_on.
    ls_linea-sctd1 = <fs_report>-sctd1
  ENDLOOP.
ENDFORM.