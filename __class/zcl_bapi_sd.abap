class ZCL_BAPI_SD definition
  public
  create public .

public section.

  data GT_RETURN type BAPIRETTAB .
  data GC_CHARC type CHAR1 value 'C'. "#EC NOTEXT .  .  .  .  .  .  .  .  .  .  .  .  .  .  .  . " .

  TYPES gtt_BAPIDLVREFTOSALESORDER TYPE TABLE OF BAPIDLVREFTOSALESORDER.

  methods CREATE_FACTURA
    importing
      !I_VBELN type VBELN_VL_T
      !I_VBTYP type VBTYP
      !I_FKART type FKART
      !I_FKDAT type FKDAT
    exporting
      !E_FACTU type VBELN_VF
    exceptions
      ERROR .
  methods CREATE_SALIDA_MERCA_ENTREGA
    importing
      !I_VBELN type VBELN
      !I_BUDAT type BUDAT default SY-DATUM
      !I_TKNUM type TKNUM
    exceptions
      ERROR .
  methods DELETE_SALIDA_MERCA_ENTREGA
    importing
      !I_VBELN type VBELN
      !I_BUDAT type BUDAT
    exceptions
      ERROR .
  methods DELETE_ENTREGA_COMPLETA
    importing
      !I_VBELN type VBELN_VL
      !I_FACTU type VBELN_VF optional
    exceptions
      ERROR_FAC
      ERROR_TRA
      ERROR_SAL
      ERROR_UMA
      ERROR_ENT .
  methods CREATE_ENTREGA
    importing
      !IT_ORDER type gtt_BAPIDLVREFTOSALESORDER
    returning
      value(R_VBELN) type VBELN
    exceptions
      ERROR .
  methods CREATE_PICKING
    importing
      !I_VBELN type VBELN_VL
      !I_LFDAT type LFDAT optional
      !IT_LIPS type TAB_LIPS
    exceptions
      ERROR .
  methods CREATE_TRANSPORTE_DE_ENTREGA
    importing
      !I_VBELN type VBELN
    changing
      !CS_VTTK type VTTK
    exceptions
      ERROR .
  methods CALL_EMBALA
    importing
      !I_VBELN type VBELN .
  methods CONTAB_SALIDA_MERCA
    importing
      !I_VBELN type VBELN_VL
      !I_BUDAT type BUDAT
    exceptions
      ERROR .
  methods CONTAB_SALIDA_MERCA_BATCH
    importing
      !I_VBELN type VBELN
      !I_BUDAT type BUDAT
    exceptions
      ERROR .
  methods CREATE_TRANSPORTE
    changing
      !CS_VTTK type VTTK
    exceptions
      ERROR .
  methods UPDATE_TRANSPORTE
    importing
      !I_TKNUM type TKNUM
    exceptions
      ERROR .
  methods LINK_TRANSPORTE
    importing
      !I_TKNUM type TKNUM
      !I_VBELN type VBELN
    exceptions
      ERROR .
  methods UNLINK_TRANSPORTE
    importing
      !I_VBELN type VBELN
      !I_TKNUM type TKNUM
    exceptions
      ERROR .
  methods DELETE_TRANSPORTE
    importing
      !I_TKNUM type TKNUM
    exceptions
      ERROR .
  methods DELETE_HU_BATCH
    importing
      !I_VBELN type VBELN
      value(IT_VEKP) type TAB_VEKP
    exceptions
      ERROR .
  methods DELETE_HU
    importing
      !IT_VEPO type TAB_VEPO
    exceptions
      ERROR .
  methods DELETE_FACTURA
    importing
      !I_VBELN type VBELN_VF
      !I_BUDAT type BUDAT optional
    exceptions
      ERROR .
  methods SHOW_RETURN
    importing
      !IT_RETURN type BAPIRETTAB optional .
  methods GET_MESSAGE_SY_IN_BAPIRET2
    returning
      value(RS_RETURN) type BAPIRET2 .
  methods CLEAR .
protected section.

  methods DELETE_ENTREGA
    importing
      !I_VBELN type VBELN
    exceptions
      ERROR .
  methods FORMAT_MESSAGE_TO_BAPIRET2
    importing
      !TY type BAPI_MTYPE
      !ID type SYMSGID
      !NO type CLIKE
      !V1 type SY-MSGV1
      !V2 type SY-MSGV2
      !V3 type SY-MSGV3
      !V4 type SY-MSGV4
    returning
      value(RS_RETURN) type BAPIRET2 .
private section.

  methods LIBERAR_TX .
ENDCLASS.



CLASS ZCL_BAPI_SD IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->CALL_EMBALA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD call_embala.

  DATA: lo_batch TYPE REF TO zosge_batch_input.

  CREATE OBJECT lo_batch.

  lo_batch->bdc_dynpro( i_program = 'SAPMV50A' i_dynpro = '4004' ).
  lo_batch->bdc_field( i_field = 'LIKP-VBELN' i_value = i_vbeln ).
  lo_batch->bdc_field( i_field = 'BDC_OKCODE' i_value = '/00' ).

  lo_batch->bdc_dynpro( i_program = 'SAPMV50A' i_dynpro = '1000' ).
  lo_batch->bdc_field( i_field = 'BDC_OKCODE' i_value = '=VERP_T' ).

  lo_batch->call_transaccion( EXPORTING i_modo = 'E'
                                        i_tran = 'VL02N'
                              EXCEPTIONS error = 1 ).

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->CLEAR
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD clear.

  REFRESH: gt_return.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->CONTAB_SALIDA_MERCA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN_VL
* | [--->] I_BUDAT                        TYPE        BUDAT
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD contab_salida_merca.

  DATA: ls_vbkok  TYPE vbkok,
        l_wbstk   TYPE wbstk,
        l_subrc   TYPE sy-subrc.

  clear( ).

*1. Contruye info
  ls_vbkok-wabuc = 'X'.         "Contabilizar movimiento de mercancías automáticamente
  ls_vbkok-wadat = i_budat.     "Fecha de salida de mercancías
  ls_vbkok-vbeln_vl = i_vbeln.  "N° de Entrega

*2. Contabiliza mercancia
  CALL FUNCTION 'WS_DELIVERY_UPDATE'
    EXPORTING
      vbkok_wa      = ls_vbkok
      synchron      = 'X'
      delivery      = i_vbeln   "N° de Entrega
    EXCEPTIONS
      error_message = 1
      OTHERS        = 2.

  MOVE sy-subrc TO l_subrc.

*3. Retorno
  IF l_subrc = 0.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    liberar_tx( ).

*  3.1 Hay casos de exito que no contabiliza
    SELECT SINGLE wbstk INTO l_wbstk FROM vbuk WHERE vbeln = i_vbeln.
    IF l_wbstk <> gc_charc.
      contab_salida_merca_batch( EXPORTING i_vbeln = i_vbeln
                                           i_budat = i_budat
                                 EXCEPTIONS error = 1 ).
      IF sy-subrc <> 0.
        RAISE error.
      ENDIF.
    ENDIF.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    APPEND get_message_sy_in_bapiret2( ) TO gt_return.
    RAISE error.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->CONTAB_SALIDA_MERCA_BATCH
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN
* | [--->] I_BUDAT                        TYPE        BUDAT
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
method CONTAB_SALIDA_MERCA_BATCH.

  DATA: lo_batch TYPE REF TO zosge_batch_input.

  CREATE OBJECT lo_batch.

  lo_batch->bdc_dynpro( i_program = 'SAPMV50A' i_dynpro = '4004' ).
  lo_batch->bdc_field( i_field = 'BDC_OKCODE' i_value = '/00').
  lo_batch->bdc_field( i_field = 'LIKP-VBELN' i_value = i_vbeln ).

  lo_batch->bdc_dynpro( i_program = 'SAPMV50A' i_dynpro = '1000' ).
  lo_batch->bdc_field( i_field = 'BDC_OKCODE' i_value = '=T\06' ).
  lo_batch->bdc_field( i_field = 'LIKP-BLDAT' i_value = i_budat ).
  lo_batch->bdc_field( i_field = 'BDC_OKCODE' i_value = '=WABU_T').

  lo_batch->call_transaccion(
    EXPORTING
      i_tran    = 'VL02N'
    RECEIVING
      rt_return = gt_return
    EXCEPTIONS
      error     = 1
  ).
  IF sy-subrc <> 0.
    RAISE error.
  ENDIF.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->CREATE_ENTREGA
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_ORDER                       TYPE        GTT_BAPIDLVREFTOSALESORDER
* | [<-()] R_VBELN                        TYPE        VBELN
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD create_entrega.

  DATA: ls_return TYPE bapiret2,
        lw_num    TYPE vbnum.

  clear( ).

* Procesar
  "Desde MM
  "CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_STO'
  
  "Desde SD
  CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_SLS'
    IMPORTING
      delivery          = r_vbeln
      num_deliveries    = lw_num
    TABLES
      sales_order_items = it_order
      return            = gt_return.

* Verificar mensaje de material bloqueado (solo es warning pero genera entrega en 0)
  READ TABLE gt_return INTO ls_return WITH KEY type = 'W'
                                                 id = 'VL'
                                             number = 156.
  IF sy-subrc EQ 0.
    CLEAR r_vbeln.
  ENDIF.

* Verificar resultado
  IF r_vbeln IS NOT INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = abap_true.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    DELETE gt_return WHERE type = 'E'
                       AND id = 'BAPI'
                       AND number = '001'. "Borrar mensaje genérico de error
    RAISE error.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->CREATE_FACTURA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN_VL_T
* | [--->] I_VBTYP                        TYPE        VBTYP
* | [--->] I_FKART                        TYPE        FKART
* | [--->] I_FKDAT                        TYPE        FKDAT
* | [<---] E_FACTU                        TYPE        VBELN_VF
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD create_factura.

  DATA: ls_vbeln         TYPE vbeln_vl,
        ls_creatordatain TYPE bapicreatordata,
        lt_billingdatain TYPE TABLE OF bapivbrk,
        lt_success       TYPE TABLE OF bapivbrksuccess,
        ls_success       TYPE bapivbrksuccess,
        ls_billingdatain TYPE bapivbrk,
        ls_return        TYPE bapiret2,
        l_lines          TYPE i.

  clear( ).

* 1. Llenado de data
  LOOP AT i_vbeln INTO ls_vbeln.
    ls_billingdatain-ordbilltyp = i_fkart.  "Clase de factura a generarse
    ls_billingdatain-ref_doc    = ls_vbeln. "Número del documento modelo
    ls_billingdatain-ref_doc_ca = i_vbtyp.  "Tipo del documento modelo
    ls_billingdatain-bill_date  = i_fkdat.  "Fecha de la factura
    APPEND ls_billingdatain TO lt_billingdatain.
  ENDLOOP.

* 2. Creacion de la factura
  CALL FUNCTION 'BAPI_BILLINGDOC_CREATEMULTIPLE'
    EXPORTING
      creatordatain = ls_creatordatain
      testrun       = ' '
    TABLES
      billingdatain = lt_billingdatain
      return        = gt_return
      success       = lt_success.

* 3. Retorno
  DESCRIBE TABLE gt_return LINES l_lines.
  READ TABLE gt_return INTO ls_return INDEX l_lines.
  IF ls_return-type = 'E'.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE error.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.
    READ TABLE lt_success INTO ls_success INDEX 1.
    e_factu = ls_success-bill_doc.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->CREATE_PICKING
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN_VL
* | [--->] I_LFDAT                        TYPE        LFDAT(optional)
* | [--->] IT_LIPS                        TYPE        TAB_LIPS
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD create_picking.

  DATA: lt_vbpok  TYPE TABLE OF vbpok,
        ls_vbkok  TYPE vbkok,
        ls_vbpok  TYPE vbpok.

  FIELD-SYMBOLS: <fs_lips> LIKE LINE OF it_lips.

* Datos cabecera
  ls_vbkok-vbeln_vl = i_vbeln.
  ls_vbkok-vbeln    = i_vbeln.
  ls_vbkok-lddat    = sy-datum.
  ls_vbkok-lfdat    = i_lfdat.
  ls_vbkok-lduhr    = sy-uzeit.
  ls_vbkok-komue    = abap_true.

*********************************************************
* PARTICION DE LOTES                                    *
*********************************************************

* Datos posiciones
  LOOP AT it_lips ASSIGNING <fs_lips>.
    IF <fs_lips>-uecha IS INITIAL.
      CLEAR ls_vbpok.
      ls_vbpok-vbeln_vl = i_vbeln.
      ls_vbpok-posnr_vl = <fs_lips>-posnr.
      ls_vbpok-vbeln    = i_vbeln.
      ls_vbpok-posnn    = <fs_lips>-posnr.
      ls_vbpok-matnr    = <fs_lips>-matnr.
      ls_vbpok-werks    = <fs_lips>-werks.
      ls_vbpok-lgort    = <fs_lips>-lgort.
      ls_vbpok-kzlgo    = abap_true.
      ls_vbpok-lfimg    = <fs_lips>-lfimg.
      ls_vbpok-lianp    = abap_true.
      APPEND ls_vbpok TO lt_vbpok.
    ELSE.
      CLEAR ls_vbpok.
      ls_vbpok-vbeln_vl   = i_vbeln.
      ls_vbpok-posnr_vl   = <fs_lips>-uecha.
      ls_vbpok-vbeln      = i_vbeln.
      ls_vbpok-posnn      = <fs_lips>-posnr.
      ls_vbpok-matnr      = <fs_lips>-matnr.
      ls_vbpok-werks      = <fs_lips>-werks.
      ls_vbpok-lgort      = <fs_lips>-lgort.
      ls_vbpok-kzlgo    = abap_true.
      ls_vbpok-lianp      = abap_true.
      ls_vbpok-vrkme      = <fs_lips>-vrkme.
      ls_vbpok-meins      = <fs_lips>-meins.
      ls_vbpok-pikmg      = <fs_lips>-lfimg.
      ls_vbpok-charg      = <fs_lips>-charg.
      ls_vbpok-force_orpos_reduction = abap_true.
      ls_vbpok-orpos      = <fs_lips>-uecha.
      ls_vbpok-wms_rfpos  = <fs_lips>-posnr.
      ls_vbpok-lfimg      = <fs_lips>-lfimg.
      APPEND ls_vbpok TO lt_vbpok.
    ENDIF.
  ENDLOOP.

* Ejecutar función (Partición de Lotes)
  CALL FUNCTION 'WS_DELIVERY_UPDATE'
    EXPORTING
      vbkok_wa             = ls_vbkok
      commit               = space
      synchron             = abap_true
      update_picking       = space
      delivery             = i_vbeln
      if_database_update   = '1'
      if_late_delivery_upd = space
    TABLES
      vbpok_tab            = lt_vbpok
    EXCEPTIONS
      error_message        = 1.
  IF sy-subrc NE 0.
    APPEND get_message_sy_in_bapiret2( ) TO gt_return.
    RAISE error.
  ELSE.
    COMMIT WORK AND WAIT.
  ENDIF.

* Esperar Proceso Anterior
  WAIT UP TO 2 SECONDS.

*********************************************************
* PICKING                                               *
*********************************************************

* Posiciones de Picking
  REFRESH lt_vbpok.
  LOOP AT it_lips ASSIGNING <fs_lips> WHERE uecha NE space.
    CLEAR ls_vbpok.
    ls_vbpok-vbeln_vl   = i_vbeln.
    ls_vbpok-posnr_vl   = <fs_lips>-posnr.
    ls_vbpok-vbeln      = i_vbeln.
*    ls_vbpok-lgort      = <fs_lips>-lgort.
    ls_vbpok-posnn      = <fs_lips>-uecha.
    ls_vbpok-pikmg      = <fs_lips>-lfimg.
    APPEND ls_vbpok TO lt_vbpok.
  ENDLOOP.

* Ejecutar función picking
  CALL FUNCTION 'SD_DELIVERY_UPDATE_PICKING'
    EXPORTING
      vbkok_wa      = ls_vbkok
      synchron      = abap_true
    TABLES
      vbpok_tab     = lt_vbpok
    EXCEPTIONS
      error_message = 1.
  IF sy-subrc NE 0.
    APPEND get_message_sy_in_bapiret2( ) TO gt_return.
    RAISE error.
  ELSE.
    COMMIT WORK AND WAIT.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->CREATE_SALIDA_MERCA_ENTREGA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN
* | [--->] I_BUDAT                        TYPE        BUDAT (default =SY-DATUM)
* | [--->] I_TKNUM                        TYPE        TKNUM
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD create_salida_merca_entrega.

  DATA: ls_vttk TYPE vttk.

* Actualizar Transporte
  SELECT SINGLE *
  FROM vttk
  INTO ls_vttk
  WHERE tknum = i_tknum.
  IF ls_vttk-stdis IS INITIAL.
    update_transporte( EXPORTING i_tknum = i_tknum
                      EXCEPTIONS error   = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.
  ENDIF.

* Contabilizar Salida de Mercancías
  contab_salida_merca_batch( EXPORTING i_vbeln = i_vbeln
                                       i_budat = i_budat
                             EXCEPTIONS error   = 1 ).

*BD NTP-060215: No se puede borrar la contabilizacion justo despues
*               de contabilizar
*  contab_salida_merca( EXPORTING i_vbeln = i_vbeln
*                                 i_budat = i_budat
*                      EXCEPTIONS error   = 1 ).
*ED NTP-060215

  IF sy-subrc <> 0.
    RAISE error.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->CREATE_TRANSPORTE
* +-------------------------------------------------------------------------------------------------+
* | [<-->] CS_VTTK                        TYPE        VTTK
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD create_transporte.

  DATA: ls_header   TYPE bapishipmentheader,
        lt_return   TYPE bapiret2tab,
        lt_deadline TYPE TABLE OF bapishipmentheaderdeadline,
        ls_deadline LIKE LINE OF lt_deadline,
        lw_datetime TYPE char15.

  CLEAR: gt_return[], cs_vttk-tknum.

* 1. Llenar datos cabecera
  ls_header-shipment_type     = cs_vttk-shtyp.  "Clase de transporte
  ls_header-trans_plan_pt     = cs_vttk-tplst.  "Puesto de planificación de transporte
  ls_header-service_agent_id  = cs_vttk-tdlnr.  "N° de transportista
  ls_header-container_id      = cs_vttk-signi.  "Vehiculo / Marca / Placa
  ls_header-description       = cs_vttk-tpbez.  "Nombre Conductor
  ls_header-external_id_1     = cs_vttk-exti1.  "Licencia de conductor
  ls_header-external_id_2     = cs_vttk-exti2.  "Certificado de inscripción
  ls_header-text_1            = cs_vttk-text1.  "Texto 1
  ls_header-text_2            = cs_vttk-text2.  "Texto 2
  ls_header-text_3            = cs_vttk-text3.  "Texto 3
  ls_header-text_4            = cs_vttk-text4.  "Texto 4
  ls_header-tendering_carrier_track_id = cs_vttk-tndr_trkid.  "Configuración vehicular

* 2. Creacion de tranporte
  CALL FUNCTION 'BAPI_SHIPMENT_CREATE'
    EXPORTING
      headerdata     = ls_header
    IMPORTING
      transport      = cs_vttk-tknum
    TABLES
      headerdeadline = lt_deadline
      return         = gt_return.

* 3. Retorno
  IF cs_vttk-tknum IS NOT INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    SELECT SINGLE *
    FROM vttk
    INTO cs_vttk
    WHERE tknum EQ cs_vttk-tknum.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE error.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->CREATE_TRANSPORTE_DE_ENTREGA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN
* | [<-->] CS_VTTK                        TYPE        VTTK
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD create_transporte_de_entrega.

  create_transporte( CHANGING cs_vttk = cs_vttk
                     EXCEPTIONS error = 1 ).
  IF sy-subrc = 0.
    link_transporte( EXPORTING i_vbeln = i_vbeln
                               i_tknum = cs_vttk-tknum
                     EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.
  ELSE.
    RAISE error.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_BAPI_SD->DELETE_ENTREGA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD delete_entrega.

  DATA: ls_header_data       TYPE bapiobdlvhdrchg,
       ls_header_control     TYPE bapiobdlvhdrctrlchg,
       ls_header_data_spl    TYPE /spe/bapiobdlvhdrchg,
       ls_header_control_spl TYPE /spe/bapiobdlvhdrctrlchg,

       ls_return             TYPE bapiret2,
       l_lines               TYPE i.

  clear( ).

* 1. Llenar data
  ls_header_data-deliv_numb        = i_vbeln. "N° entrega
  ls_header_data_spl-deliv_numb    = i_vbeln. "N° entrega

  ls_header_control-deliv_numb     = i_vbeln. "N° entrega
  ls_header_control_spl-deliv_numb = i_vbeln. "N° entrega
  ls_header_control-dlv_del        = 'X'.     "Flag: Borrar entrega


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
      return             = gt_return
    EXCEPTIONS
      error              = 1.

* 3. Retorno
  DESCRIBE TABLE gt_return LINES l_lines.
  READ TABLE gt_return INTO ls_return INDEX l_lines.
  IF ls_return-type = 'E'.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE error.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->DELETE_ENTREGA_COMPLETA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN_VL
* | [--->] I_FACTU                        TYPE        VBELN_VF(optional)
* | [EXC!] ERROR_FAC
* | [EXC!] ERROR_TRA
* | [EXC!] ERROR_SAL
* | [EXC!] ERROR_UMA
* | [EXC!] ERROR_ENT
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD delete_entrega_completa.
*----------------------------------------------------------------------*
* Metodo delete Entrega completa
* 1. Anula factura
* 2. Anula transporte de la entrega
*   2.1 Desvincula los transporte asociados
*   2.2 Anula los transportes
* 3. Anula salida de mercancia de la entrega
* 4. Anula HU
* 5. Anula entrega
*----------------------------------------------------------------------*

  DATA: "lt_vepo   TYPE tab_vepo, "-NTP-060215
        lt_vekp   TYPE tab_vekp,
        ls_vttp   TYPE vttp,
        lw_budat  TYPE budat.

* 1. Anular factura (si es que tiene factura)
  IF i_factu IS NOT INITIAL.
    delete_factura( EXPORTING i_vbeln = i_factu
                              i_budat = sy-datum
                   EXCEPTIONS error   = 1 ).
    IF sy-subrc <> 0.
      RAISE error_fac.
    ENDIF.
  ENDIF.

* 2. Obtiene los transporte vinculados
*    Relacion de Entrega-Transporte es 1 a 1
  SELECT SINGLE *
  INTO ls_vttp
  FROM vttp
  WHERE vbeln = i_vbeln.
  IF sy-subrc = 0.
*    unlink_transporte( EXPORTING i_vbeln = i_vbeln
*                                 i_tknum = ls_vttp-tknum
*                       EXCEPTIONS error = 1 ).
*    IF sy-subrc = 0.
    delete_transporte( EXPORTING i_tknum = ls_vttp-tknum
                       EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error_tra.
    ENDIF.
*    ELSE.
*      RAISE error_tra.
*    ENDIF.
  ENDIF.

* 3. Anular movimiento
  SELECT SINGLE a~wadat_ist
    INTO lw_budat
    FROM likp as a INNER JOIN vbuk as b ON a~vbeln = b~vbeln
   WHERE a~vbeln = i_vbeln
     AND b~wbstk = gc_charc.
  IF lw_budat IS NOT INITIAL.
    delete_salida_merca_entrega( EXPORTING i_vbeln = i_vbeln
                                           i_budat = lw_budat
                                 EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error_sal.
    ENDIF.
  ENDIF.

* 4. Anular HU
* Obtiene las U.Manipuleos embalados y sin embalar
  SELECT * FROM vekp INTO TABLE lt_vekp WHERE vpobjkey EQ i_vbeln.
  IF sy-subrc = 0.
    delete_hu_batch( EXPORTING i_vbeln = i_vbeln
                               it_vekp = lt_vekp
                    EXCEPTIONS error   = 1 ).
    IF sy-subrc <> 0.
      RAISE error_uma.
    ENDIF.
  ENDIF.
*BD NTP-060215: No funciono, Solo obtiene las U.Manipuleos embalados
*  SELECT *
*  FROM vepo
*  INTO TABLE lt_vepo
*  WHERE vbeln EQ i_vbeln.
*  IF sy-subrc = 0.
*    delete_hu_batch( EXPORTING it_vepo = lt_vepo
*                     EXCEPTIONS error   = 1 ).
*    IF sy-subrc <> 0.
*      RAISE error_uma.
*    ENDIF.
*  ENDIF.
*ED NTP-060215

* 5. Anular Entrega
  delete_entrega( EXPORTING i_vbeln = i_vbeln
                  EXCEPTIONS error = 1 ).
  IF sy-subrc <> 0.
    RAISE error_ent.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->DELETE_FACTURA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN_VF
* | [--->] I_BUDAT                        TYPE        BUDAT(optional)
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD delete_factura.

  DATA: lt_success  TYPE TABLE OF bapivbrksuccess,
        ls_success  TYPE bapivbrksuccess,
        lw_budat    TYPE budat.

  clear( ).

  lw_budat = i_budat.
  IF lw_budat IS INITIAL.
    lw_budat = sy-datum.
  ENDIF.
  CALL FUNCTION 'BAPI_BILLINGDOC_CANCEL1'
    EXPORTING
      billingdocument = i_vbeln
      billingdate     = lw_budat
    TABLES
      return          = gt_return
      success         = lt_success.
  READ TABLE lt_success INTO ls_success INDEX 1.
  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

    liberar_tx( ).
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE error.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->DELETE_HU
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_VEPO                        TYPE        TAB_VEPO
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD delete_hu.

  DATA: ls_return TYPE bapiret2,
        lw_exidv  TYPE vekp-exidv.
  FIELD-SYMBOLS: <fs_vepo> LIKE LINE OF it_vepo.

  clear( ).

  LOOP AT it_vepo ASSIGNING <fs_vepo>.
    AT NEW venum.
      SELECT SINGLE exidv
      FROM vekp
      INTO lw_exidv
      WHERE venum = <fs_vepo>-venum.
      REFRESH gt_return.
      CALL FUNCTION 'BAPI_HU_DELETE_FROM_DEL'
        EXPORTING
          delivery       = <fs_vepo>-vbeln
          hukey          = lw_exidv
        TABLES
          return         = gt_return.
      READ TABLE gt_return INTO ls_return WITH KEY id = 'HUDIALOG'
                                               number = 202.
      IF sy-subrc = 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
        RAISE error.
      ENDIF.
    ENDAT.
  ENDLOOP.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->DELETE_HU_BATCH
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN
* | [--->] IT_VEKP                        TYPE        TAB_VEKP
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD delete_hu_batch.

  DATA: l_tabix      TYPE monat,
        l_pos        TYPE string,  "Posicion de U.Manipuleo
        lest_borrado TYPE check,   "Estado de accion de borrado
        ls_vekp      LIKE LINE OF it_vekp,
        lo_batch     TYPE REF TO zosge_batch_input.

  clear( ).

  CREATE OBJECT lo_batch.
  lo_batch->bdc_dynpro( i_program = 'SAPMV50A' i_dynpro = '4004' ).
  lo_batch->bdc_field( i_field = 'BDC_OKCODE' i_value = '=VERP_T').
  lo_batch->bdc_field( i_field = 'LIKP-VBELN' i_value = i_vbeln ).


* Borrar por bloque, los U.Manipuleo
  LOOP AT it_vekp INTO ls_vekp.
    CLEAR lest_borrado.
    l_tabix = sy-tabix.

*   1. Al inicio
    IF l_tabix = 1.
      lo_batch->bdc_dynpro( i_program = 'SAPLV51G' i_dynpro = '6000' ).
      lo_batch->bdc_field( i_field = 'BDC_OKCODE' i_value = '=HULOE').
    ENDIF.

*   2. Selección de pos. de la U.Manipuleo
    CONCATENATE 'V51VE-SELKZ(' l_tabix ')' INTO l_pos.
    lo_batch->bdc_field( i_field = l_pos i_value = abap_true ).       "Pos. de Embale

*   Borrado de 4 pos. por resolucion 600x800 - Limitacion de Batch Input - Angel huaraca
    IF l_tabix = 4.
      DELETE it_vekp FROM 1 TO 4.

*     3. Accion de borrado
      lo_batch->bdc_dynpro( i_program = 'SAPLSPO1' i_dynpro = '0100' ).
      lo_batch->bdc_field( i_field = 'BDC_OKCODE' i_value = '=YES').
      lest_borrado = abap_true.
    ENDIF.
  ENDLOOP.

* 3. Accion de borrado, cuando las U.Manipuleos restante sea menor a 4
  IF lest_borrado = ''.
    lo_batch->bdc_dynpro( i_program = 'SAPLSPO1' i_dynpro = '0100' ).
    lo_batch->bdc_field( i_field = 'BDC_OKCODE' i_value = '=YES').
  ENDIF.


  lo_batch->bdc_dynpro( i_program = 'SAPLV51G' i_dynpro = '6000' ).
  lo_batch->bdc_field( i_field = 'BDC_OKCODE' i_value = '=SICH').

  lo_batch->call_transaccion(
    EXPORTING
      i_tran    = 'VL02N'
    RECEIVING
      rt_return = gt_return
    EXCEPTIONS
      error     = 1
  ).
  IF sy-subrc <> 0.
    RAISE error.
  ENDIF.


ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->DELETE_SALIDA_MERCA_ENTREGA
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN
* | [--->] I_BUDAT                        TYPE        BUDAT
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD delete_salida_merca_entrega.

  DATA: lt_mesg TYPE TABLE OF mesg,
        l_subrc TYPE sy-subrc.

  FIELD-SYMBOLS: <fs_mesg> LIKE LINE OF lt_mesg.

  clear( ).

* 1. Anula salida de mercancia de entrega
  CALL FUNCTION 'WS_REVERSE_GOODS_ISSUE'
    EXPORTING
      i_vbeln                   = i_vbeln   "Número de entrega
      i_budat                   = i_budat   "Fecha que se contabilizó
      i_tcode                   = 'VL09'    "Tx: Anulación salida mcías.p.nota entr.
      i_vbtyp                   = 'J'       "Entrega
    TABLES
      t_mesg                    = lt_mesg
    EXCEPTIONS
      error_reverse_goods_issue = 1
      OTHERS                    = 2.

  MOVE sy-subrc TO l_subrc.

* 2. Retorno
  IF l_subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.
    WAIT UP TO 1 SECONDS.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    APPEND get_message_sy_in_bapiret2( ) TO gt_return.
    RAISE error.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->DELETE_TRANSPORTE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_TKNUM                        TYPE        TKNUM
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD delete_transporte.
  DATA: ls_act    TYPE v56e_shipment_activities,
        lt_log    TYPE v56e_logfile,
        l_subrc   TYPE sy-subrc.
  FIELD-SYMBOLS: <fs_log> LIKE LINE OF lt_log.

  clear( ).

* 1. Llenar datos
  ls_act-delete-execute = 'X'.              "Borrar Transporte
  ls_act-delete-shipment_number = i_tknum.  "N° Transporte


* 2. Borra transporte
  CALL FUNCTION 'SD_SHIPMENT_PROCESS'
    IMPORTING
      e_logfile    = lt_log
    CHANGING
      c_activities = ls_act
    EXCEPTIONS
      error        = 1
      OTHERS       = 2.


* 3. Retorno
  l_subrc = sy-subrc.

  LOOP AT lt_log ASSIGNING <fs_log>.
    APPEND format_message_to_bapiret2( ty = <fs_log>-severity
                                       id = <fs_log>-ag
                                       no = <fs_log>-msgnr
                                       v1 = <fs_log>-var1
                                       v2 = <fs_log>-var2
                                       v3 = <fs_log>-var3
                                       v4 = <fs_log>-var4 ) TO gt_return.
  ENDLOOP.

  IF l_subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE error.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Protected Method ZCL_BAPI_SD->FORMAT_MESSAGE_TO_BAPIRET2
* +-------------------------------------------------------------------------------------------------+
* | [--->] TY                             TYPE        BAPI_MTYPE
* | [--->] ID                             TYPE        SYMSGID
* | [--->] NO                             TYPE        CLIKE
* | [--->] V1                             TYPE        SY-MSGV1
* | [--->] V2                             TYPE        SY-MSGV2
* | [--->] V3                             TYPE        SY-MSGV3
* | [--->] V4                             TYPE        SY-MSGV4
* | [<-()] RS_RETURN                      TYPE        BAPIRET2
* +--------------------------------------------------------------------------------------</SIGNATURE>
method FORMAT_MESSAGE_TO_BAPIRET2.
  DATA: l_message TYPE string.

  CALL FUNCTION 'FORMAT_MESSAGE'
    EXPORTING
      id        = id
      lang      = sy-langu
      no        = no
      v1        = v1
      v2        = v2
      v3        = v3
      v4        = v4
    IMPORTING
      msg       = l_message
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.

  rs_return-type       = ty.
  rs_return-id         = id.
  rs_return-number     = no.
  rs_return-message    = l_message.
  rs_return-message_v1 = v1.
  rs_return-message_v2 = v2.
  rs_return-message_v3 = v3.
  rs_return-message_v4 = v4.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->GET_MESSAGE_SY_IN_BAPIRET2
* +-------------------------------------------------------------------------------------------------+
* | [<-()] RS_RETURN                      TYPE        BAPIRET2
* +--------------------------------------------------------------------------------------</SIGNATURE>
method GET_MESSAGE_SY_IN_BAPIRET2.

  DATA: l_message TYPE string.

  CALL FUNCTION 'FORMAT_MESSAGE'
    EXPORTING
      id        = sy-msgid
      lang      = sy-langu
      no        = sy-msgno
      v1        = sy-msgv1
      v2        = sy-msgv2
      v3        = sy-msgv3
      v4        = sy-msgv4
    IMPORTING
      msg       = l_message
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2.

  rs_return-type       = sy-msgty.
  rs_return-id         = sy-msgid.
  rs_return-number     = sy-msgno.
  rs_return-message    = l_message.
  rs_return-message_v1 = sy-msgv1.
  rs_return-message_v2 = sy-msgv2.
  rs_return-message_v3 = sy-msgv3.
  rs_return-message_v4 = sy-msgv4.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_BAPI_SD->LIBERAR_TX
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method LIBERAR_TX.

*   Hay BAPI'S que bloquean tx
*   Liberar la tx, para borrar otros procesos
*   El tiempo depende del servidor, hay que ajustar
    WAIT UP TO 1 SECONDS.
    CALL FUNCTION 'DEQUEUE_ALL'.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->LINK_TRANSPORTE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_TKNUM                        TYPE        TKNUM
* | [--->] I_VBELN                        TYPE        VBELN
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD link_transporte.

  DATA: lt_item         TYPE TABLE OF bapishipmentitem,
        lt_item_act     TYPE TABLE OF bapishipmentitemaction,
        lt_deadline     TYPE TABLE OF bapishipmentheaderdeadline,
        lt_deadline_act TYPE TABLE OF bapishipmentheaderdeadlineact,
        ls_item         TYPE bapishipmentitem,
        ls_item_act     TYPE bapishipmentitemaction,
        ls_header       TYPE bapishipmentheader,
        ls_header_act   TYPE bapishipmentheaderaction,
        ls_deadline     TYPE bapishipmentheaderdeadline,
        ls_deadline_act TYPE bapishipmentheaderdeadlineact,
        ls_return       TYPE bapiret2,
        l_lines         TYPE i.

  clear( ).


* 1. Llenar la data
* Cabecera BAPI
  ls_header-shipment_num = i_tknum.

* Entrega BAPI
  ls_item-delivery = i_vbeln.
  ls_item-itenerary = '0001'.
  APPEND ls_item TO lt_item.

  ls_item_act-delivery = 'A'.
  ls_item_act-itenerary = 'A'.
  APPEND ls_item_act TO lt_item_act.


* 2. Vincular transporte a la entrega
  CALL FUNCTION 'BAPI_SHIPMENT_CHANGE'
    EXPORTING
      headerdata           = ls_header
      headerdataaction     = ls_header_act
    TABLES
      headerdeadline       = lt_deadline
      headerdeadlineaction = lt_deadline_act
      itemdata             = lt_item
      itemdataaction       = lt_item_act
      return               = gt_return.


* 3. Retorno
  DESCRIBE TABLE gt_return LINES l_lines.
  READ TABLE gt_return INTO ls_return INDEX l_lines.

  IF ls_return-type EQ 'E'.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE error.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.
    clear( ). APPEND ls_return TO gt_return.
  ENDIF.


ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->SHOW_RETURN
* +-------------------------------------------------------------------------------------------------+
* | [--->] IT_RETURN                      TYPE        BAPIRETTAB(optional)
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD show_return.

    CALL FUNCTION 'C14ALD_BAPIRET2_SHOW'
      TABLES
        i_bapiret2_tab = gt_return.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->UNLINK_TRANSPORTE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_VBELN                        TYPE        VBELN
* | [--->] I_TKNUM                        TYPE        TKNUM
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD unlink_transporte.

  DATA: ls_header     TYPE bapishipmentheader,
        ls_header_act TYPE bapishipmentheaderaction,
        ls_item       TYPE bapishipmentitem,
        ls_item_act   TYPE bapishipmentitemaction,
        lt_item       TYPE TABLE OF bapishipmentitem,
        lt_item_act   TYPE TABLE OF bapishipmentitemaction,
        ls_return     TYPE bapiret2,
        l_lines       TYPE i.

  clear( ).

* 1. Llena info
* Transporte
  ls_header-shipment_num   = i_tknum. "N° de transporte
  ls_header-status_plan    = space.   "Status de planificación de transporte
  ls_header-status_checkin = space.   "Status del registro

  ls_header_act-status_plan    = 'D'. "Delete
  ls_header_act-status_checkin = 'D'. "Delete

* Entrega
  ls_item-delivery  = i_vbeln.        "N° de entrega
  ls_item-itenerary = '0001'.         "Secuencia de posiciones de transporte
  APPEND ls_item TO lt_item.

  ls_item_act-delivery  = 'D'.        "Delete
  ls_item_act-itenerary = 'D'.        "Delete
  APPEND ls_item_act TO lt_item_act.


* 2. Disvincula el transporte de la entrega
  CALL FUNCTION 'BAPI_SHIPMENT_CHANGE'
    EXPORTING
      headerdata       = ls_header
      headerdataaction = ls_header_act
    TABLES
      itemdata         = lt_item
      itemdataaction   = lt_item_act
      return           = gt_return.


* 3. Retorno
  DESCRIBE TABLE gt_return LINES l_lines.
  READ TABLE gt_return INTO ls_return INDEX l_lines.

  IF ls_return-type EQ 'E'.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE error.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.
    clear( ). APPEND ls_return TO gt_return.
  ENDIF.

ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_SD->UPDATE_TRANSPORTE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_TKNUM                        TYPE        TKNUM
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD update_transporte.

  DATA: ls_header       TYPE bapishipmentheader,
        ls_headeract    TYPE bapishipmentheaderaction,
        lt_deadline     TYPE TABLE OF bapishipmentheaderdeadline,
        ls_deadline     LIKE LINE OF lt_deadline,
        lt_deadlineact  TYPE TABLE OF bapishipmentheaderdeadlineact,
        ls_deadlineact  LIKE LINE OF lt_deadlineact,
        ls_return       LIKE LINE OF gt_return,
        lw_datetime     TYPE char15.

  clear( ).

* 1. Llenar datos cabecera
  ls_header-shipment_num      = i_tknum.
  ls_header-status_plan       = abap_true.
  ls_header-status_checkin    = abap_true.
  ls_header-status_load_start = abap_true.
  ls_header-status_load_end   = abap_true.
  ls_headeract-status_plan       = gc_charc.
  ls_headeract-status_checkin    = gc_charc.
  ls_headeract-status_load_start = gc_charc.
  ls_headeract-status_load_end   = gc_charc.

* Fechas
  CONCATENATE sy-datum sy-uzeit INTO lw_datetime.
  ls_deadline-time_type = 'HDRSTCIPDT'.
  ls_deadline-time_stamp_utc = lw_datetime.
  ls_deadline-time_zone = 'UTC'.
  APPEND ls_deadline TO lt_deadline.
  ls_deadline-time_type = 'HDRSTCIADT'.
  ls_deadline-time_stamp_utc = lw_datetime.
  ls_deadline-time_zone = 'UTC'.
  APPEND ls_deadline TO lt_deadline.
  ls_deadline-time_type = 'HDRSTLSADT'.
  ls_deadline-time_stamp_utc = lw_datetime.
  ls_deadline-time_zone = 'UTC'.
  APPEND ls_deadline TO lt_deadline.
  ls_deadline-time_type = 'HDRSTLEADT'.
  ls_deadline-time_stamp_utc = lw_datetime.
  ls_deadline-time_zone = 'UTC'.
  APPEND ls_deadline TO lt_deadline.
  ls_deadline-time_type = 'HDRSTCADT'.
  ls_deadline-time_stamp_utc = lw_datetime.
  ls_deadline-time_zone = 'UTC'.
  APPEND ls_deadline TO lt_deadline.
  ls_deadline-time_type = 'HDRSTSSADT'.
  ls_deadline-time_stamp_utc = lw_datetime.
  ls_deadline-time_zone = 'UTC'.
  APPEND ls_deadline TO lt_deadline.

  ls_deadlineact-time_type      = gc_charc.
  ls_deadlineact-time_stamp_utc = gc_charc.
  ls_deadlineact-time_zone      = gc_charc.
  APPEND ls_deadlineact TO lt_deadlineact.
  APPEND ls_deadlineact TO lt_deadlineact.
  APPEND ls_deadlineact TO lt_deadlineact.
  APPEND ls_deadlineact TO lt_deadlineact.
  APPEND ls_deadlineact TO lt_deadlineact.
  APPEND ls_deadlineact TO lt_deadlineact.

* Llamar BAPI
  CALL FUNCTION 'BAPI_SHIPMENT_CHANGE'
    EXPORTING
      headerdata           = ls_header
      headerdataaction     = ls_headeract
    TABLES
      headerdeadline       = lt_deadline
      headerdeadlineaction = lt_deadlineact
      return               = gt_return.

* Evaluar
  READ TABLE gt_return INTO ls_return WITH KEY type = 'S'
                                                 id = 'VW'
                                             number = 488.
  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' EXPORTING wait = 'X'.

    liberar_tx( ).
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RAISE error.
  ENDIF.

ENDMETHOD.
ENDCLASS.