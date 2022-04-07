METHODS r_alvevent_toolbar FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object e_interactive.

*----------------------------------------------------------------------*
* Toolbar
*----------------------------------------------------------------------*
  METHOD r_alvevent_toolbar.
*    DATA: ls_tool TYPE stb_button.
*
*    ls_tool-function  = 'CONTA'.
*    ls_tool-icon      = '@39@'.
*    ls_tool-quickinfo = 'Contabilizar'.
*    ls_tool-text      = 'Contabilizar'.
*    ls_tool-butn_type = 2.               "0,2,3
*    APPEND ls_tool TO e_object->mt_toolbar. CLEAR ls_tool.
  ENDMETHOD.