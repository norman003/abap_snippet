METHODS r_alvevent_changing FOR EVENT data_changed OF cl_gui_alv_grid IMPORTING er_data_changed.

*----------------------------------------------------------------------*
* Changing
*----------------------------------------------------------------------*
METHOD r_alvevent_changing.
*    DATA: ls_good TYPE lvc_s_modi.
*    FIELD-SYMBOLS <fs100> LIKE LINE OF gt_det.
*
*    LOOP AT er_data_changed->mt_good_cells INTO ls_good.
*      READ TABLE gt_det ASSIGNING <fs100> INDEX ls_good-row_id.
*      IF sy-subrc = 0.
*        "<fs100>-selec = ls_good-value.
*      ENDIF.
*    ENDLOOP.
ENDMETHOD.