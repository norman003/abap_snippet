*----------------------------------------------------------------------*
* TIPS de PROGRAMACION
* Cuando se programe acciones para un REPORT
* 1. Es la selección es valida
*    Mostrar confirmación
*    Retorna los ítems seleccionados, return, icon
* 2. Acción
* 3. Actualiza el REPORT
*----------------------------------------------------------------------*
FORM 100_sendfactu_push USING pi_method TYPE char03.

  DATA: lt_output TYPE tt_output.

  zqcpefe_process_ws=>is_selec_valid_factu(
    EXPORTING
      it_output  = gt_output
      i_question = 'Desea Ejecutar la acción'
      i_accion   = pi_method
    IMPORTING
      et_output  = lt_output
    EXCEPTIONS
      error      = 1
  ).
  IF sy-subrc <> 0.
    PERFORM set_return_to_report_factu USING lt_output CHANGING gt_output.
    PERFORM print_message. RETURN.
  ENDIF.


  zqcpefe_process_ws=>enviar_ws_factu(
    EXPORTING
      i_accion  = pi_method
    CHANGING
      ct_output = lt_output
    EXCEPTIONS
      error     = 1
  ).
  PERFORM set_return_to_report_factu USING lt_output CHANGING gt_output.
  PERFORM print_message. RETURN.
ENDFORM.                    " PROCESA_ACCION


************************************************************************
* 1. 
************************************************************************
METHOD is_selec_valid_factu.

  DATA: l_message TYPE string.
  FIELD-SYMBOLS: <fs_output> LIKE LINE OF it_output.

* Verificación
  "1. Selección
  et_output = it_output.
  DELETE et_output WHERE selec IS INITIAL.
  IF et_output IS INITIAL.
    MESSAGE e000 WITH text-e02 DISPLAY LIKE gc_chars.
  ENDIF.

  "2. Validación
  LOOP AT et_output ASSIGNING <fs_output>.
    REFRESH <fs_output>-return.

    IF <fs_output>-stadoc IN gc_grpnr-generado AND i_accion = 1.
      _set_log( EXPORTING i_text = 'Documento ya generado'
                  CHANGING ct_return = <fs_output>-return ).
    ENDIF.

    IF <fs_output>-stadoc IN gc_grpnr-rechazado.
      _set_log( EXPORTING i_text = 'Factura esta rechaza no se puede procesar'
                  CHANGING ct_return = <fs_output>-return ).
    ENDIF.

    IF <fs_output>-staanu IN gc_ws_factu-r_staanu.
      _set_log( EXPORTING i_text = 'Factura de anulación no se puede procesar'
                  CHANGING ct_return = <fs_output>-return ).
    ENDIF.

    IF <fs_output>-zztipo EQ '03'                                                                         "I-WMR
    OR ( ( <fs_output>-zztipo EQ '07' OR <fs_output>-zztipo EQ '08' ) AND <fs_output>-zzncndtm EQ '03' ).     "I-WMR
    ELSE.                                                                                               "I-WMR
      IF <fs_output>-zzncndtm IS NOT INITIAL.
        IF <fs_output>-zztipo IN gc_ws_factu-r_ncndtp AND
           <fs_output>-zzncndtm IN gc_ws_factu-r_ncndtm.
        ELSE.
          CONCATENATE 'El documento afectado por la nc/nd'
                      <fs_output>-zzncndtp
                      'no es una factura, no se puede enviar a Sunat'
                    INTO l_message SEPARATED BY space.
          _set_log( EXPORTING i_text = l_message
                    CHANGING ct_return = <fs_output>-return ).
        ENDIF.
      ELSE.
        IF <fs_output>-zztipo NOT IN gc_ws_factu-r_tipo.
          _set_log( EXPORTING i_text = 'Documento no es factura'
                    CHANGING ct_return = <fs_output>-return ).
        ENDIF.
      ENDIF.
    ENDIF.

    "Read Enqueue
    zqcpefe_utilities=>read_enqueue(
      EXPORTING
        i_vbeln    = <fs_output>-vbeln
        i_zznrcpsn = <fs_output>-zznrcpsn
      EXCEPTIONS
        error      = 1
    ).
    IF sy-subrc <> 0.
      _sy_to_return( CHANGING ct_return = <fs_output>-return ).
    ENDIF.
  ENDLOOP.

  "3. Construir icon log
  _build_icon_return_selec( CHANGING ct_output = et_output ).
  READ TABLE et_output WITH KEY icon = gc_red TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    MESSAGE e000 WITH 'Hay errores de seleccion, verificar' RAISING error.
  ENDIF.


* Confirmación
  zqcpefe_utilities=>get_confirm(
    EXPORTING
      i_question = i_question
    EXCEPTIONS
      cancel     = 1
  ).
  IF sy-subrc <> 0.
    RAISE error.
  ENDIF.
ENDMETHOD.

************************************************************************
* 2. 
************************************************************************
METHOD enviar_ws_factu.

  DATA: ls_input      TYPE zqcws_procesar_documento_suna1,

        "Actualizar
        lt_stafe      TYPE ztt_stafe,
        lt_return     TYPE bapirettab,

        lw_lines      TYPE numc10,
        lw_current    TYPE numc10,
        l_message     TYPE string.

  FIELD-SYMBOLS: <fs_output> LIKE LINE OF ct_output,
                 <fs_stafe> LIKE LINE OF lt_stafe.

* 1. Indicador
  DESCRIBE TABLE ct_output LINES lw_lines.

  "Tabla ZTB_STAFE contiene el estado del VBELN
  SELECT * INTO TABLE lt_stafe
    FROM ztb_stafe
    FOR ALL ENTRIES IN ct_output
    WHERE vbeln    = ct_output-vbeln
      AND zznrcpsn = ct_output-zznrcpsn.


* 2. Envio
  LOOP AT ct_output ASSIGNING <fs_output>.

    "Indicador
    zqcpefe_utilities=>show_progress( EXPORTING i_lines = lw_lines CHANGING c_current = lw_current ).

    "Lock Document
    lock_doc(
      EXPORTING
        i_vbeln    = <fs_output>-vbeln
        i_zznrcpsn = <fs_output>-zznrcpsn
      EXCEPTIONS
        error      = 1
    ).
    IF sy-subrc <> 0.
      _sy_to_return( CHANGING ct_return = <fs_output>-return ).
      CONTINUE. "Siguiente
    ENDIF.

    READ TABLE lt_stafe ASSIGNING <fs_stafe> WITH KEY vbeln = <fs_output>-vbeln
                                                      zznrcpsn = <fs_output>-zznrcpsn.
    IF sy-subrc = 0.

*     Prepara INPUT WS
      zqcpefe_save_documentos=>fill_input_factu(
        EXPORTING
          is_factura = <fs_output>
        IMPORTING
          es_input   = ls_input
      ).

* 3. Call WS
      call_ws_factu(
        EXPORTING
          is_input   = ls_input
          i_accion   = i_accion
        IMPORTING
          et_return  = <fs_output>-return
        CHANGING
          cs_stafe   = <fs_stafe>
        EXCEPTIONS
          error      = 1
      ).
      IF sy-subrc = 0.

*  4. Resultado
        <fs_output>-stacli = <fs_stafe>-stacli.
        <fs_output>-stadoc = <fs_stafe>-stadoc.
        <fs_output>-idcdr  = <fs_stafe>-idcdr.
      ELSE.
        _sy_to_return( CHANGING ct_return = <fs_output>-return ).
      ENDIF.
    ELSE.
      CONCATENATE 'El documento' <fs_output>-vbeln
                  'con nro' <fs_output>-zznrcpsn 'no existe verificar'
                  INTO l_message SEPARATED BY space.
      _set_log( EXPORTING i_text = l_message
                CHANGING ct_return = <fs_output>-return ).
    ENDIF.
  ENDLOOP.

*5. Actualizar DB
  save_db(
    EXPORTING
      it_stafe     = lt_stafe
    CHANGING
      ct_return    = lt_return
  ).
  APPEND LINES OF lt_return TO <fs_output>-return.

*6. Unlock Document
  unlock_doc_block( ct_output ).

*7. Resultado general
  _build_icon_return( CHANGING ct_output = ct_output ).
  _build_message( EXPORTING it_output = ct_output
                  EXCEPTIONS error    = 1 ).
  IF sy-subrc <> 0.
    RAISE error.
  ENDIF.

ENDMETHOD.
************************************************************************
* 3. 
************************************************************************
METHOD _build_icon_return.
  FIELD-SYMBOLS: <fs_output> LIKE LINE OF ct_output.

  LOOP AT ct_output ASSIGNING <fs_output>.
    READ TABLE <fs_output>-return WITH KEY type = gc_chare TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      <fs_output>-icon = gc_red.
    ELSE.
      <fs_output>-icon = gc_green.
    ENDIF.
  ENDLOOP.
ENDMETHOD. 
************************************************************************
* 3. 
************************************************************************
method _BUILD_MESSAGE.

  READ TABLE it_output WITH KEY icon = gc_red TRANSPORTING NO FIELDS.
  IF sy-subrc = 0.
    MESSAGE 'Se ejecuto con errores, verificar el log' TYPE gc_chare RAISING error.
  ELSE.
    READ TABLE it_output WITH KEY icon = gc_green TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      MESSAGE 'Acciones Ejecutadas correctamente' TYPE gc_chars.
    ELSE.
      MESSAGE 'Hay documentos que no se pueden procesar por FE' TYPE gc_chare RAISING error.
    ENDIF.
  ENDIF.

endmethod.
************************************************************************
* 3. 
************************************************************************
FORM set_return_to_report_factu USING it_output    TYPE tt_output
                                CHANGING ct_output TYPE tt_output.

  DATA: ls_output LIKE LINE OF it_output.
  FIELD-SYMBOLS: <fs_output> LIKE LINE OF ct_output.

  LOOP AT it_output INTO ls_output.
    READ TABLE ct_output ASSIGNING <fs_output> WITH KEY vbeln    = ls_output-vbeln
                                                        zznrcpsn = ls_output-zznrcpsn.
    IF sy-subrc = 0.
      <fs_output>-icon   = ls_output-icon.
      <fs_output>-return = ls_output-return.
      <fs_output>-stacli = ls_output-stacli.
      <fs_output>-stadoc = ls_output-stadoc.
      <fs_output>-idcdr  = ls_output-idcdr.
    ENDIF.
  ENDLOOP.
ENDFORM.