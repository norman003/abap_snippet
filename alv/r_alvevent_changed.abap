METHODS r_alvevent_changed  FOR EVENT data_changed_finished OF cl_gui_alv_grid IMPORTING e_modified et_good_cells.

  "Eventos
  SET HANDLER me->r_alvevent_changed FOR go_alv.
  go_alv->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
  go_alv->register_edit_event( cl_gui_alv_grid=>mc_evt_enter ).
  
  "Variante

*----------------------------------------------------------------------*
* Changed
*----------------------------------------------------------------------*
  METHOD r_alvevent_changed.
*    FIELD-SYMBOLS: <fs_cell> TYPE lvc_s_modi,
*                   <fs_100>  LIKE LINE OF gt_det.
*
*    IF et_good_cells IS NOT INITIAL.
*      go_conta->save_contabilizar(
*        EXPORTING
*          i_test    = abap_on
*        CHANGING
*          ct_cab     = gt_det
*        EXCEPTIONS
*          error     = 1
*      ).
*
*      alv_refresh( ).
*    ENDIF.
  ENDMETHOD.