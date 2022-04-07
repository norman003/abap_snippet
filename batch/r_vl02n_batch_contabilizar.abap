*----------------------------------------------------------------------*
* Vl02n - Contabilizar
*----------------------------------------------------------------------*
FORM u_vl02n_contabilizar USING i_vbeln TYPE vbeln
                                 i_budat TYPE datum.
 
  DATA: lo_bi TYPE REF TO zosge_batch_input.

  CREATE OBJECT lo_bi.

  lo_bi->bdc_dynpro( i_program = 'SAPMV50A' i_dynpro = '4004' ).
  lo_bi->bdc_field( i_field = 'BDC_OKCODE' i_value = '/00').
  lo_bi->bdc_field( i_field = 'LIKP-VBELN' i_value = i_vbeln ).

  lo_bi->bdc_dynpro( i_program = 'SAPMV50A' i_dynpro = '1000' ).
  lo_bi->bdc_field( i_field = 'BDC_OKCODE' i_value = '=T\06' ).
  lo_bi->bdc_field( i_field = 'LIKP-BLDAT' i_value = i_budat ).
  lo_bi->bdc_field( i_field = 'BDC_OKCODE' i_value = '=WABU_T').

  lo_bi->gs_param-dismode = 'E'.
  lo_bi->gs_param-updmode = 'S'.
  lo_bi->call_transaccion( i_tran = 'VL02N' i_params = lo_bi->gs_param ).
  
ENDFORM.