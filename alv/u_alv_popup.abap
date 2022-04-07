*----------------------------------------------------------------------*
* Alv - Show popup
*----------------------------------------------------------------------*
FORM u_alv_popup USING i_ini_row  TYPE i
                        i_end_row  TYPE i
                        i_ini_col  TYPE i
                        i_end_col  TYPE i
                        i_title TYPE clike
                  CHANGING ct_table TYPE STANDARD TABLE.
  DATA: lo_alv       TYPE REF TO cl_salv_table,
        lo_columns   TYPE REF TO cl_salv_columns_table,
        lo_functions TYPE REF TO cl_salv_functions_list,
        lo_display   TYPE REF TO cl_salv_display_settings.
  DATA: l_end_row TYPE i,
        l_ini_row TYPE i,
        l_ini_col TYPE i,
        l_end_col TYPE i.

  "Validar
  CHECK ct_table IS NOT INITIAL.

  "Crear Alv
  cl_salv_table=>factory( IMPORTING r_salv_table = lo_alv
                          CHANGING t_table       = ct_table ).

  "Funciones
  lo_functions = lo_alv->get_functions( ).
  lo_functions->set_default( abap_on ).
  lo_columns = lo_alv->get_columns( ).
  lo_columns->set_optimize( abap_on ).
  lo_display = lo_alv->get_display_settings( ).
  lo_display->set_list_header( i_title ).

  "Alv as Popup
  l_ini_row = i_ini_row.
  l_end_row = i_end_row.
  l_ini_col = i_ini_col.
  l_end_col = i_end_col.
  IF l_ini_row IS INITIAL. l_ini_row = 3.   ENDIF.
  IF l_end_row IS INITIAL. l_end_row = 10.  ENDIF.
  IF l_ini_col IS INITIAL. l_ini_col = 5.   ENDIF.
  IF l_end_col IS INITIAL. l_end_col = 100. ENDIF.
  
  lo_alv->set_screen_popup(
    start_column = l_ini_col
    end_column   = l_end_col
    start_line   = l_ini_row
    end_line     = l_end_row ).

  "Display
  lo_alv->display( ).
ENDFORM.