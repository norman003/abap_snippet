METHODS r_alvevent_uc FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm.

*----------------------------------------------------------------------*
* UC
*----------------------------------------------------------------------*
  METHOD r_alvevent_uc.
*    alvedit_ischanged( ).
*
*    CASE e_ucomm.
*      WHEN 'CONTA'.
*
*        go_conta->save_contabilizar(
*          EXPORTING
*            i_test    = abap_off
*          CHANGING
*            ct_cab     = gt_det
*          EXCEPTIONS
*            error     = 1
*        ).
*    ENDCASE.
*
*    "Refresca ALV
*    alv_refresh( ).
  ENDMETHOD.