*--------------------------------------------------------------------*
* Ml89
*--------------------------------------------------------------------*
FORM r_ml89.
  DATA: lt_return  TYPE bapiret2_tab,
        ls_return  TYPE bapiret2,
        lo_batch   TYPE REF TO clu_batch_input.

    CREATE OBJECT lo_batch.

    lo_batch->bdc_dynpro( EXPORTING i_program = 'SAPMV13A'  i_dynpro = '1096' ).
    lo_batch->bdc_field(  EXPORTING i_field = 'BDC_CURSOR'  i_value = 'KOMG-SRVPOS(01)' ).
    lo_batch->bdc_field(  EXPORTING i_field = 'BDC_OKCODE'  i_value = '/00' ).
    lo_batch->bdc_field(  EXPORTING i_field = 'KOMG-EKORG'  i_value = <fs_tarifas>-ekorg ).
    lo_batch->bdc_field(  EXPORTING i_field = 'KOMG-LIFNR'  i_value = <fs_tarifas>-lifnr ).
    lo_batch->bdc_field(  EXPORTING i_field = 'KOMG-SRVPOS(01)'  i_value = <fs_tarifas>-srvpos ).
*
    lo_batch->bdc_dynpro( EXPORTING i_program = 'SAPMV13A'  i_dynpro = '1096' ).
    lo_batch->bdc_field(  EXPORTING i_field = 'BDC_CURSOR'  i_value = 'RV13A-DATAB(01)' ).
    lo_batch->bdc_field(  EXPORTING i_field = 'BDC_OKCODE'  i_value = '/00' ).
    lo_batch->bdc_field(  EXPORTING i_field = 'KONP-KBETR(01)'   i_value = lv_kbetr ).
    lo_batch->bdc_field(  EXPORTING i_field = 'KONP-KONWA(01)'   i_value = <fs_tarifas>-konwa ).
    lo_batch->bdc_field(  EXPORTING i_field = 'KONP-KMEIN(01)'   i_value = <fs_tarifas>-kmein ).
    lo_batch->bdc_field(  EXPORTING i_field = 'RV13A-DATAB(01)'  i_value = lv_fecha ).
    lo_batch->bdc_field(  EXPORTING i_field = 'RV13A-DATBI(01)'  i_value = '31129999' ).
*
    lo_batch->bdc_dynpro( EXPORTING i_program = 'SAPMV13A'  i_dynpro = '1096' ).
    lo_batch->bdc_field(  EXPORTING i_field = 'BDC_CURSOR'  i_value = 'KOMG-SRVPOS(01)' ).
    lo_batch->bdc_field(  EXPORTING i_field = 'BDC_OKCODE'  i_value = '=SICH' ).
*
    lo_batch->call_transaccion( EXPORTING i_tran    = 'ML39'
                                          i_modo    = p_dmode
                                RECEIVING rt_return = lt_return
                                EXCEPTIONS error    = 1 ).

*   Leer resultado
    READ TABLE lo_batch->gt_return INTO ls_return WITH KEY id = 'VK'
                                                       number = '023'.
    IF sy-subrc = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      DELETE lo_batch->gt_return WHERE type = 'W'.
    ENDIF.
ENDFORM.