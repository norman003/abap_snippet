METHODS r_alvevent_double FOR EVENT double_click OF cl_gui_alv_grid IMPORTING e_row e_column.

*----------------------------------------------------------------------*
* Double
*----------------------------------------------------------------------*
METHOD r_alvevent_double.
*  DATA: ls_contrato LIKE LINE OF gt_vbak_c.
*  READ TABLE gt_vbak_c INTO ls_contrato INDEX e_row-index.
*
*  "Limpiar TOP
*  CLEAR gs_top.
*
*  "Selección de Contrato Datos del contrato
*  gs_top-vgbel   = ls_contrato-vbeln.
*  gs_top-auart_c = ls_contrato-auart.
*
*  "Filtrar pedidos
*  set_filtro_dynpro( IMPORTING et_report = gt_det ).
*
*    "Refrescar ALV
*    alv_refresh( ).
ENDMETHOD.