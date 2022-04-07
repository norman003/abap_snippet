*--------------------------------------------------------------------*
* Batch - dynpro
*--------------------------------------------------------------------*
FORM batch_dynpro USING i_program TYPE clike
                        i_dynpro  TYPE clike
                        i_key     TYPE clike
                  CHANGING ct_batch TYPE tab_bdcdata.
  DATA: ls_batch TYPE bdcdata.
  ls_batch-program = i_program.
  ls_batch-dynpro  = i_dynpro.
  ls_batch-dynbegin = abap_on.
  APPEND ls_batch  TO ct_batch.
  CLEAR ls_batch.

  IF i_key IS NOT INITIAL.
    ls_batch-fnam = 'BDC_OKCODE'.
    ls_batch-fval = i_key.
    APPEND ls_batch  TO ct_batch.
  ENDIF.
ENDFORM.

*--------------------------------------------------------------------*
* Batch - field
*--------------------------------------------------------------------*
FORM batch_field USING i_field TYPE clike
                       i_value TYPE any
                 CHANGING ct_batch TYPE tab_bdcdata.
  DATA: ls_batch TYPE bdcdata.
  ls_batch-fnam = i_field.
  WRITE i_value TO ls_batch-fval.
  CONDENSE ls_batch-fval.
  APPEND ls_batch  TO ct_batch.
ENDFORM.

*--------------------------------------------------------------------*
* Batch - call
*--------------------------------------------------------------------*
FORM batch_call USING i_tcode TYPE tcode
                      i_number TYPE numc3
                CHANGING ct_batch TYPE tab_bdcdata
                         ct_return TYPE bapirettab
                         e_subrc TYPE sy-subrc.
  DATA: lt_bdcret TYPE TABLE OF bdcmsgcoll,
        ls_param  TYPE ctu_params,
        lt_return TYPE bapirettab.

  ls_param-dismode = 'E'.
  ls_param-updmode = 'S'.

  CALL TRANSACTION i_tcode USING ct_batch
                   OPTIONS FROM ls_param
                  MESSAGES INTO lt_bdcret.

  CALL FUNCTION 'CONVERT_batchMSGCOLL_TO_BAPIRET2'
    TABLES
      imt_bdcmsgcoll = lt_bdcret
      ext_return     = lt_return.

  REFRESH ct_batch.

  PERFORM bapi_save USING lt_return i_number CHANGING ct_return e_subrc.

ENDFORM.

*----------------------------------------------------------------------*
* Bapi_save
*----------------------------------------------------------------------*
FORM bapi_save USING it_return TYPE bapirettab
                     i_number TYPE numc3
               CHANGING ct_return TYPE bapirettab
                        e_subrc TYPE sy-subrc.
  DATA: lt_return TYPE bapirettab,
        ls_return LIKE LINE OF lt_return,
        l_number  TYPE sy-subrc.

  "Resultado
  lt_return = it_return.
  SORT lt_return BY type.

  READ TABLE lt_return INTO ls_return INDEX 1.
  READ TABLE lt_return INTO ls_return WITH KEY number = i_number.
  IF sy-subrc <> 0 AND i_number IS NOT INITIAL.
    l_number = 1.
  ENDIF.
  IF ls_return-type <> 'E' AND l_number = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_on.

    IF ls_return-message IS NOT INITIAL.
      APPEND ls_return TO ct_return.
    ENDIF.
  ELSE.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    APPEND LINES OF it_return TO ct_return.
    e_subrc = 1.
  ENDIF.
ENDFORM.

*----------------------------------------------------------------------*
* Return show
*----------------------------------------------------------------------*
FORM return_show USING it_return TYPE bapirettab.
  CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = it_return.
ENDFORM.