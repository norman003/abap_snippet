*----------------------------------------------------------------------*
* Alv - Set top HTML
*----------------------------------------------------------------------*
FORM r_100_tophtml USING co_doc TYPE REF TO cl_dd_document.

  DATA:  lo_tab  TYPE REF TO cl_dd_table_element,
         lo_col1 TYPE REF TO cl_dd_area,
         lo_col2 TYPE REF TO cl_dd_area,
         lo_col3 TYPE REF TO cl_dd_area,
         lo_col4 TYPE REF TO cl_dd_area,
         lo_col5 TYPE REF TO cl_dd_area,
         lo_col6 TYPE REF TO cl_dd_area.

  PERFORM get_top_0100.
  co_doc->add_text(
      text          = 'Resumen'
      sap_fontsize  = cl_dd_area=>large
      sap_emphasis  = 'Strong'
  ).

  co_doc->add_table(
    EXPORTING
      no_of_columns = 6
      width         = '50%'
      border        = '0'
    IMPORTING
      table         = lo_tab
  ).

  lo_tab->add_column( IMPORTING column = lo_col1 ).
  lo_tab->add_column( IMPORTING column = lo_col2 ).
  lo_tab->add_column( IMPORTING column = lo_col3 ).
  lo_tab->add_column( IMPORTING column = lo_col4 ).
  lo_tab->add_column( IMPORTING column = lo_col5 ).
  lo_tab->add_column( IMPORTING column = lo_col6 ).


  PERFORM r_html_setline USING '' 00 'Cant de B.Pesaje' 'Strong' 'cl_dd_area=>medium' CHANGING lo_col1.
  PERFORM r_html_setline USING '' 00 gs_top-cant_ped    ''       'cl_dd_area=>medium' CHANGING lo_col2.

  PERFORM r_html_setline USING '' 00 'Cant de Viajes'   'Strong' 'cl_dd_area=>medium' CHANGING lo_col3.
  PERFORM r_html_setline USING '' 00 gs_top-cant_via    ''       'cl_dd_area=>medium' CHANGING lo_col4.

  PERFORM r_html_setline USING '' 00 'Tarifa'           'Strong' 'cl_dd_area=>medium' CHANGING lo_col5.
  PERFORM r_html_setline USING '' 00 gs_top-tarifa      ''       'cl_dd_area=>medium' CHANGING lo_col6.

  PERFORM r_html_setline USING 'X' 00 'UM'               'Strong' 'cl_dd_area=>medium' CHANGING lo_col1.
  PERFORM r_html_setline USING 'X' 00 gs_top-meins       ''       'cl_dd_area=>medium' CHANGING lo_col2.

  PERFORM r_html_setline USING 'X' 00 'Peso'             'Strong' 'cl_dd_area=>medium' CHANGING lo_col3.
  PERFORM r_html_setline USING 'X' 00 gs_top-peso        ''       'cl_dd_area=>medium' CHANGING lo_col4.

  PERFORM r_html_setline USING 'X' 00 'Valor'            'Strong' 'cl_dd_area=>medium' CHANGING lo_col5.
  PERFORM r_html_setline USING 'X' 00 gs_top-valor       ''       'cl_dd_area=>medium' CHANGING lo_col6.

  PERFORM r_html_setline USING 'X' 00 'Monto'            'Strong' 'cl_dd_area=>medium' CHANGING lo_col1.
  PERFORM r_html_setline USING 'X' 00 gs_top-monto       ''       'cl_dd_area=>medium' CHANGING lo_col2.

ENDFORM.

*----------------------------------------------------------------------*
* Html - Set line
*----------------------------------------------------------------------*
FORM u_html_setline USING i_new      TYPE check
                             i_width    TYPE i
                             i_text     TYPE any
                             i_emphasis TYPE sdydo_attribute
                             i_fontsize TYPE sdydo_attribute
                       CHANGING co_doc  TYPE REF TO cl_dd_area.

  DATA: l_text TYPE sdydo_text_element.

  IF i_new IS NOT INITIAL.
    co_doc->new_line( ).
  ENDIF.

  co_doc->add_gap( width = i_width ).

  l_text = i_text.

  co_doc->add_text(
   text         = l_text
   fix_lines    = abap_true
   sap_emphasis = i_emphasis
   sap_fontsize = i_fontsize
   ).

ENDFORM.