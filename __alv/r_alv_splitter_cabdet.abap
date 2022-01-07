*----------------------------------------------------------------------*
* Alv - Splitter 2 alv
*----------------------------------------------------------------------*
FORM r_alv_splitter USING ct_cab TYPE STANDARD TABLE
                           ct_det TYPE STANDARD TABLE.

  DATA: lo_dock     TYPE REF TO cl_gui_docking_container,
        lo_split    TYPE REF TO cl_gui_splitter_container,

        lo_cont_cab TYPE REF TO cl_gui_container,
        lo_alv_cab  TYPE REF TO cl_salv_table,

        lo_cont_det TYPE REF TO cl_gui_container,
        lo_alv_det  TYPE REF TO cl_salv_table,

        lo_tt       TYPE REF TO clubap_tabledescr,
        lo_ty       TYPE REF TO clubap_structdescr,
        ls_comp     LIKE LINE OF lo_ty->components,
        lo_cols     TYPE REF TO cl_salv_columns_table,
        lo_col      TYPE REF TO cl_salv_column,
        l_short     TYPE scrtext_s,
        l_medium    TYPE scrtext_m,
        l_long      TYPE scrtext_l.

* Crear union(dock)
  CREATE OBJECT lo_dock
    EXPORTING
      repid     = sy-cprog
      dynnr     = '100'
      extension = 2000
      name      = 'C_0100'.


* Crear division(split)
  CREATE OBJECT lo_split
    EXPORTING
      parent  = lo_dock
      rows    = 2
      columns = 1.

  "Arriba cabecera, Abajo detalle
  lo_cont_cab = lo_split->get_container( row = 1 column = 1 ).
  lo_cont_det = lo_split->get_container( row = 2 column = 1 ).


* Crea alv
  "Cab
  cl_salv_table=>factory( EXPORTING r_container    = lo_cont_cab
                                    container_name = 'C_0100'
                          IMPORTING r_salv_table   = lo_alv_cab
                          CHANGING t_table        = ct_cab ).

  "Det
  cl_salv_table=>factory( EXPORTING r_container    = lo_cont_det
                                  container_name = 'C_0100'
                        IMPORTING r_salv_table   = lo_alv_det
                        CHANGING t_table        = ct_det ).

* Modificar catalogo
  "Cab
  lo_cols = lo_alv_cab->get_columns( ).
  lo_tt  ?= clubap_tabledescr=>describe_by_data( ct_cab ).
  lo_ty  ?= lo_tt->get_table_line_type( ).
  LOOP AT lo_ty->components INTO ls_comp.
    lo_col = lo_cols->get_column( ls_comp-name ).
    l_short = ls_comp-name.
    l_medium = ls_comp-name.
    l_long = ls_comp-name.
    lo_col->set_short_text( l_short ).
    lo_col->set_medium_text( l_medium ).
    lo_col->set_long_text( l_long ).
  ENDLOOP.

  "Det
  lo_cols = lo_alv_det->get_columns( ).
  lo_tt  ?= clubap_tabledescr=>describe_by_data( ct_det ).
  lo_ty  ?= lo_tt->get_table_line_type( ).
  LOOP AT lo_ty->components INTO ls_comp.
    lo_col = lo_cols->get_column( ls_comp-name ).
    l_short = ls_comp-name.
    l_medium = ls_comp-name.
    l_long = ls_comp-name.
    lo_col->set_short_text( l_short ).
    lo_col->set_medium_text( l_medium ).
    lo_col->set_long_text( l_long ).
  ENDLOOP.

* Show
  lo_alv_cab->display( ).
  lo_alv_det->display( ).

ENDFORM.                    "show_cab_det_alv