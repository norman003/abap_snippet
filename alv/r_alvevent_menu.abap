METHODS r_alvevent_menu FOR EVENT menu_button OF cl_gui_alv_grid IMPORTING e_object e_ucomm.

*----------------------------------------------------------------------*
* Menu
*----------------------------------------------------------------------*
  METHOD r_alvevent_menu.
*    CASE e_ucomm.
*      WHEN 'MENUIMPRI'.
*        e_object->add_function( fcode = 'IMPLETRA' text  = 'Imprimir letra' ).
*    ENDCASE.
  ENDMETHOD.