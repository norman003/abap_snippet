*----------------------------------------------------------------------*
* BatchInput - Ejemplo de uso
*----------------------------------------------------------------------*
DATA: lo_bi TYPE REF TO clu_batchinput,
      ls_return LIKE LINE OF lo_bi->gt_return.

"1. Data
CREATE OBJECT lo_bi.
lo_bi->bdc_dynpro( i_program = 'SAPLIQS0' i_dynpro = '0100' i_key = '/00' ).
lo_bi->bdc_field( i_field = 'RIWO00-QMART' i_value = 'I9' ).

lo_bi->bdc_dynpro( i_program = 'SAPLIQS0' i_dynpro = '7200' i_key = '=BUCH' ).
lo_bi->bdc_field( i_field = 'VIQMEL-QMTXT' i_value = '' ).
lo_bi->bdc_field( i_field = 'RIWO1-EQUNR' i_value = '' ).
lo_bi->bdc_field( i_field = 'VIQMEL-VKORG' i_value = '' ).
lo_bi->bdc_field( i_field = 'VIQMEL-VTWEG' i_value = '' ).
lo_bi->bdc_field( i_field = 'VIQMEL-SPART' i_value = '' ).
lo_bi->bdc_field( i_field = 'VIQMEL-VKBUR' i_value = '' ).

"2. Ejecutar
lo_bi->gs_param-dismode = 'N'.
lo_bi->gs_param-updmode = 'S'.
lo_bi->call_tcode( i_tcode = 'IW51' is_param = lo_bi->gs_param ).

"3. Retorno
READ TABLE lo_bi->gt_return INTO ls_return WITH KEY type = 'E'.
IF sy-subrc = 0.
  CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  r_subrc = 1.
ELSE.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.
ENDIF.

"4. Mostrar
PERFORM _returnshow USING lo_bi->gt_return.
