METHODS r_alvevent_click FOR EVENT hotspot_click OF cl_gui_alv_grid IMPORTING e_row_id e_column_id.

*----------------------------------------------------------------------*
* Alv Click
*----------------------------------------------------------------------*
  METHOD r_alvevent_click.
*    FIELD-SYMBOLS <fs_det> LIKE LINE OF gt_det.
*
*    READ TABLE gt_det ASSIGNING <fs_det> INDEX e_row_id-index.
*    CASE e_column_id.
*      WHEN 'RECNR'.
*        "Mostrar detalle
*        IF go_g101 IS NOT BOUND.
*          CREATE OBJECT go_g101.
*        ENDIF.
*
*        go_g101->gt_det = <fs_det>-t_det.
*        CALL SCREEN go_g101->g_dynnr.
*        <fs_det>-t_det = go_g101->gt_det.
*
*        alv_refresh( ).
*
*      WHEN 'BTN_STATUS'.
*      return_show( <fs_det>-t_status ).
*      WHEN OTHERS.
*    ENDCASE.
  ENDMETHOD.                    "q_alvevent_click