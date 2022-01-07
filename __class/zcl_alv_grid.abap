*----------------------------------------------------------------------*
* DEFINICION
*----------------------------------------------------------------------*
CLASS lcr_100 DEFINITION.
  PUBLIC SECTION.
  
    "Alv
    DATA: go_container TYPE REF TO cl_gui_custom_container, "grid "cl_gui_docking_container, "dock
          go_alv TYPE REF TO cl_gui_alv_grid.
    METHODS: constructor.
    METHODS: r_alv_show. "grid
    
*----------------------------------------------------------------------*
* Declaracion
*----------------------------------------------------------------------*
    "Tipos
    "Tipos tablas
    "Tablas internas
    DATA: gt_det  TYPE clu_process=>gtt_det.
    
    "Estructuras
    "Variables
    "Constantes
           
    "Objetos
    "Public
    METHODS getdata.
    METHODS uc.

*----------------------------------------------------------------------*
* Protected
*----------------------------------------------------------------------*
  PROTECTED SECTION.
    METHODS r_alvevent_toolbar FOR EVENT toolbar OF cl_gui_alv_grid IMPORTING e_object e_interactive.
    METHODS r_alvevent_menu   FOR EVENT menu_button OF cl_gui_alv_grid IMPORTING e_object e_ucomm.
    METHODS r_alvevent_uc     FOR EVENT user_command OF cl_gui_alv_grid IMPORTING e_ucomm.
    METHODS r_alvevent_click  FOR EVENT hotspot_click OF cl_gui_alv_grid IMPORTING e_row_id e_column_id.
    METHODS r_alvevent_double FOR EVENT double_click OF cl_gui_alv_grid IMPORTING e_row e_column.
    METHODS r_alv_changing    FOR EVENT data_changed OF cl_gui_alv_grid IMPORTING er_data_changed,
    METHODS r_alv_changed     FOR EVENT data_changed_finished OF cl_gui_alv_grid IMPORTING e_modified et_good_cells,
    METHODS r_alv_f4          FOR EVENT onf4 OF cl_gui_alv_grid IMPORTING e_fieldname e_fieldvalue es_row_no er_event_data et_bad_cells e_display.

*----------------------------------------------------------------------*
* Privada
*----------------------------------------------------------------------*
  PRIVATE SECTION.
    "Alv
    DATA: gs_stable TYPE lvc_s_stbl VALUE 'XX',
          g_dynnr   TYPE sydynnr.
          "g_ratio   TYPE i. "dock
          "g_extension TYPE i. "dock
          "g_side    TYPE i. "dock
    "METHODS r_alv_show. "dock
    
ENDCLASS.

*----------------------------------------------------------------------*
* IMPLEMENTACION
*----------------------------------------------------------------------*
CLASS lcr_100 IMPLEMENTATION.

*----------------------------------------------------------------------*
* Constructor
*----------------------------------------------------------------------*
  METHOD constructor.
    g_dynnr = 100. "sy-dynnr.
    "g_ratio = 50.
    "g_extension = 2000.
    "g_side  = cl_gui_docking_container=>dock_at_left.
  ENDMETHOD.                    "constructor

*----------------------------------------------------------------------*
* Alv show
*----------------------------------------------------------------------*
  METHOD r_alv_show.
    DATA: ls_layo TYPE lvc_s_layo,
          lt_fcat TYPE lvc_t_fcat,
          ls_vari TYPE disvariant.
          "lt_excl TYPE lvc_t_excl,
          "lt_f4   TYPE lvc_t_f4,
          "ls_f4   LIKE LINE OF lt_f4.
          "lt_sort TYPE lvc_t_sort,
          "ls_sort LIKE LINE OF lt_sort.
    FIELD-SYMBOLS: <fs_fcat> TYPE lvc_s_fcat.

    IF go_alv IS NOT BOUND.

      "Objetos
      CREATE OBJECT go_container
        EXPORTING
          container_name = g_dynnr.

      " CREATE OBJECT go_container "dock
      "   EXPORTING
      "     repid = sy-cprog
      "     dynnr = g_dynnr
      "     "side  = g_side
      "     ratio = g_ratio
      "     extension = g_extension
      "     name  = 'DOCK'.

      CREATE OBJECT go_alv
        EXPORTING
          i_parent = go_container.

      "Layout
      ls_layo-zebra       = abap_on.
      "ls_layo-cwidth_opt = abap_on.
      "ls_layo-col_opt    = abap_on.
      "ls_layo-no_rowmark = abap_on.
      "ls_layo-box_fname  = 'SELEC'.
      "ls_layo-ctab_fname = 'CELLCOLOR'.
      "ls_layo-stylefname = 'CELLSTYLE'.
      "ls_layo-info_fname = 'COLOR'.       ls_report-color = 'C700'.
      "ls_layo-grid_title = 'Reporte'.
      "ls_layo-sel_mode   = 'A'.

      "Variante
      "ls_vari-username = sy-uname.
      "ls_vari-report   = sy-repid.
      "ls_vari-handle   = g_dynnr.

      "Catalogo
      "CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      "  EXPORTING
      "    i_structure_name = sy-repid(30)
      "  CHANGING
      "    ct_fieldcat      = lt_fcat.
      PERFORM u_alv_fcatgen CHANGING gt_det lt_fcat.

*      "Fcat - Descripción
*      LOOP AT lt_fcat ASSIGNING <fs_fcat>.
*       CASE <fs_fcat>-fieldname.
*      "WHEN 'ICON'.       <fs_fcat>-hotspot = abap_on. <fs_fcat>-just = 'C'.
*      "WHEN 'MESSAGE4'.   <fs_fcat>-tech = abap_on.
*      "WHEN 'TEXT'.       <fs_fcat>-edit = abap_on.
*      "WHEN 'STAT_USER'.  <fs_fcat>-outputlen = 4.
*      "WHEN 'NETWR'.      <fs_fcat>-emphasize = 'C700'.
*      "WHEN 'K0001'.      PERFORM r_alv_fcatname USING 'Observación' '' CHANGING <fs_fcat>.
*       ENDCASE.
*      ENDLOOP.

      "Eventos
      "SET HANDLER me->q_alvevent_toolbar  FOR go_alv.
      "SET HANDLER me->q_alvevent_menu     FOR go_alv.
      "SET HANDLER me->q_alvevent_uc       FOR go_alv.
      "SET HANDLER me->q_alvevent_click    FOR go_alv.
      "SET HANDLER me->q_alvevent_double   FOR go_alv.
      "SET HANDLER me->q_alvevent_changed  FOR go_alv.
      "go_alv->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
      "go_alv->register_edit_event( cl_gui_alv_grid=>mc_evt_enter ).

      "Toolbar
      "q_alv_toolbarexclude( IMPORTING et_excl = lt_excl ).

      "F4
      "ls_f4-register = abap_on.
      "ls_f4-fieldname = 'EQUNR'.
      "INSERT ls_f4 INTO TABLE lt_f4.
      "ls_f4-fieldname = 'ACTIVIDAD'.
      "INSERT ls_f4 INTO TABLE lt_f4.
      "SET HANDLER me->_f4       FOR go_alv.
      "go_alv->register_f4_for_fields( it_f4 = lt_f4 ).

      "Sort
      "ls_sort-fieldname = 'PGMID'.
      "ls_sort-up        = 'X'.
      "APPEND ls_sort TO lt_sort.
    
      go_alv->set_table_for_first_display(
        EXPORTING
          i_bypassing_buffer    = abap_on
          i_buffer_active       = abap_on
          is_layout             = ls_layo
          "it_toolbar_excluding  = lt_excl
          is_variant            = ls_vari
          i_save                = 'A'
        CHANGING
          it_outtab             = gt_det
          it_fieldcatalog       = lt_fcat
          "it_filter            = ct_filter
          "it_sort              = lt_sort
      ).
    ELSE.
      "go_alv->set_filter_criteria( ct_filter ).
      go_alv->refresh_table_display( is_stable = gs_stable ).
    ENDIF.

  ENDMETHOD.                    "alvshow
  
*----------------------------------------------------------------------*
* Get data
*----------------------------------------------------------------------*
  METHOD getdata.
    
    r_alv_show( ).      "dock
    "CALL SCREEN g_dynnr. "dock
  ENDMETHOD.                    "get_data
  
*----------------------------------------------------------------------*
* Lee cambios de alv
*----------------------------------------------------------------------*
  METHOD _ischangeddata.
    DATA: lo_alv  TYPE REF TO cl_gui_alv_grid,
        l_valid TYPE c.

    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
    IMPORTING
      e_grid = lo_alv.

    "Verifica la consistencia de los datos
    lo_alv->check_changed_data( IMPORTING e_valid = l_valid ).

    IF l_valid IS INITIAL.
      RAISE error.
    ENDIF.
  ENDMETHOD.

*----------------------------------------------------------------------*
* Selected
*----------------------------------------------------------------------*
  METHOD _isselected.

    DATA: lt_row TYPE lvc_t_row,
          ls_row LIKE LINE OF lt_row.

        "Clear select
        LOOP AT gt_100 ASSIGNING FIELD-SYMBOL(<fs_100>).
          CLEAR <fs_100>-selec.
        ENDLOOP.

        "Set select
        go_alv->get_selected_rows( IMPORTING et_index_rows = lt_row ).
    IF lt_row IS INITIAL AND ls_layo-sel_mode <> 'A'.
      go_alv->get_current_cell( IMPORTING es_row_id = ls_row ).
      APPEND ls_row TO lt_row.
    ENDIF.
    LOOP AT lt_row INTO ls_row.
      READ TABLE gt_100 ASSIGNING <fs_100> INDEX ls_row-index.
      IF sy-subrc = 0.
        <fs_100>-selec = abap_on.
      ENDIF.
    ENDLOOP.

    IF lt_row IS INITIAL.
      r_subrc = 1.
    ENDIF.
  ENDMETHOD.

*----------------------------------------------------------------------*
* Excluir
*----------------------------------------------------------------------*
  METHOD _toolexclude.
    APPEND cl_gui_alv_grid=>mc_fc_refresh           TO rt_excl.  "Refresh
    "APPEND cl_gui_alv_grid=>mc_fc_loc_append_row    TO rt_excl.  "Añadir   fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_insert_row    TO rt_excl.  "Insertar fila
    "APPEND cl_gui_alv_grid=>mc_fc_loc_delete_row    TO rt_excl.  "Borrar   fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_copy_row      TO rt_excl.  "Copiar fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_paste_new_row TO rt_excl.  "Pegar  fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_move_row      TO rt_excl.  "Mover  fila
    APPEND cl_gui_alv_grid=>mc_fc_loc_copy          TO rt_excl.  "Copiar
    APPEND cl_gui_alv_grid=>mc_fc_loc_cut           TO rt_excl.  "Cortar
    APPEND cl_gui_alv_grid=>mc_fc_loc_paste         TO rt_excl.  "Pegar
    APPEND cl_gui_alv_grid=>mc_fc_loc_undo          TO rt_excl.  "Deshacer
    APPEND cl_gui_alv_grid=>mc_fc_check             TO rt_excl.  "Check
    APPEND cl_gui_alv_grid=>mc_fc_graph             TO rt_excl.  "Graph
    APPEND cl_gui_alv_grid=>mc_fc_info              TO rt_excl.  "Info
    APPEND cl_gui_alv_grid=>mc_fc_views             TO rt_excl.  "Views
  ENDMETHOD.

*----------------------------------------------------------------------*
* Refrescar alv
*----------------------------------------------------------------------*
  METHOD _alvrefresh.
    go_alv->refresh_table_display( is_stable = gs_stable ).
  ENDMETHOD.
  
************************************************************************
* EVENTOS
************************************************************************
*----------------------------------------------------------------------*
* Click
*----------------------------------------------------------------------*
  METHOD r_alv_click.
    FIELD-SYMBOLS <fs_100> LIKE LINE OF gt_100.

    READ TABLE gt_100 ASSIGNING <fs_100> INDEX e_row_id-index.
    CASE e_column_id.
      WHEN 'RECNR'.
          "Mostrar detalle
          IF go_101 IS NOT BOUND.
            CREATE OBJECT go_101.
          ENDIF.

          go_101->gt_101 = <fs_100>-t_det.
          CALL SCREEN 101.
          <fs_100>-t_det = go_101->gt_101.

          _alvrefresh( ).

        ENDIF.

      WHEN 'BTN_STATUS'. _returnshow( <fs_100>-t_status ).
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

*----------------------------------------------------------------------*
* Double
*----------------------------------------------------------------------*
  METHOD r_alv_double.
    DATA: ls_contrato LIKE LINE OF gt_vbak_c.
    READ TABLE gt_vbak_c INTO ls_contrato INDEX e_row-index.

    "Limpiar TOP
    CLEAR gs_top.

    "Selección de Contrato Datos del contrato
    gs_top-vgbel   = ls_contrato-vbeln.
    gs_top-auart_c = ls_contrato-auart.

    "Filtrar pedidos
    set_filtro_dynpro( IMPORTING et_report = gt_100 ).

    "Refrescar ALV
    go_alv->refresh_table_display( is_stable = gs_stable ).
  ENDMETHOD.

*----------------------------------------------------------------------*
* Changing
*----------------------------------------------------------------------*
  METHOD r_alv_changing.
    DATA: ls_good TYPE lvc_s_modi.
    FIELD-SYMBOLS <fs100> LIKE LINE OF gt_100.

    LOOP AT er_data_changed->mt_good_cells INTO ls_good.
      READ TABLE gt_100 ASSIGNING <fs100> INDEX ls_good-row_id.
      IF sy-subrc = 0.
        <fs100>-box = ls_good-value.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

*----------------------------------------------------------------------*
* Changed
*----------------------------------------------------------------------*
  METHOD r_alv_changed.
    FIELD-SYMBOLS: <fscell> TYPE lvc_s_modi,
                   <fs100>  LIKE LINE OF gt_100.

    IF et_good_cells IS NOT INITIAL.
      go_conta->save_contabilizar(
        EXPORTING
          i_test    = abap_on
        CHANGING
          ct_cab     = gt_100
        EXCEPTIONS
          error     = 1
      ).

      _alvrefresh( ).
    ENDIF.
  ENDMETHOD.

*----------------------------------------------------------------------*
* Toolbar
*----------------------------------------------------------------------*
  METHOD r_alv_toolbar.
    DATA: ls_tool TYPE stb_button.

    ls_tool-function  = 'CONTA'.
    ls_tool-icon      = '@39@'.
    ls_tool-quickinfo = 'Contabilizar'.
    ls_tool-text      = 'Contabilizar'.
    APPEND ls_tool TO e_object->mt_toolbar. CLEAR ls_tool.
  ENDMETHOD.

*----------------------------------------------------------------------*
* UC
*----------------------------------------------------------------------*
  METHOD r_alv_uc.
    _isselected( ).

    CASE e_ucomm.
      WHEN 'CONTA'.

        go_conta->save_contabilizar(
          EXPORTING
            i_test    = abap_off
          CHANGING
            ct_cab     = gt_100
          EXCEPTIONS
            error     = 1
        ).
    ENDCASE.

    "Refresca ALV
    _alvrefresh( ).
  ENDMETHOD.

*----------------------------------------------------------------------*
* F4
*----------------------------------------------------------------------*
  METHOD r_alv_f4.
    CASE e_fieldname.
      WHEN 'ACTIVIDAD'.
        f4_actividad( es_row_no ).
        _alvrefresh( ).
        er_event_data->m_event_handled = abap_on.
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.

*----------------------------------------------------------------------*
* F4 Ayuda
*----------------------------------------------------------------------*
  METHOD f4_actividad.
    TYPES: BEGIN OF ty_f4,
             actividad TYPE zostb_actfundo-actividad,
             ltxa1     TYPE zostb_actfundo-ltxa1,
           END OF ty_f4.

    DATA: lt_f4     TYPE TABLE OF ty_f4,
          lt_return TYPE ism_ddshretval,
          ls_return LIKE LINE OF lt_return.

    "Get
    SELECT actividad ltxa1
      INTO TABLE lt_f4
      FROM zostb_actfundo
      WHERE id_equi = abap_on.

    SORT lt_f4 BY actividad.
    DELETE ADJACENT DUPLICATES FROM lt_f4 COMPARING actividad.
    IF lt_f4 IS INITIAL.
      MESSAGE s000(su) WITH 'Sin entradas...'.
      EXIT.
    ENDIF.

    "Show
    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
        retfield     = 'ACTIVIDAD'
        window_title = 'Actividades Fundo'
        value_org    = 'S'
      TABLES
        value_tab    = lt_f4
        return_tab   = lt_return.

    "Return
    READ TABLE lt_return INTO ls_return INDEX 1.
    IF sy-subrc = 0.
      READ TABLE gt_100 ASSIGNING FIELD-SYMBOL(<fs_100>) INDEX es_row_no-row_id.
      IF sy-subrc = 0.
        <fs_100>-actividad = ls_return-fieldval.
      ENDIF.
    ELSE.
      MESSAGE s000(su) WITH 'Accion cancelada...' DISPLAY LIKE 'E'.
    ENDIF.
  ENDMETHOD.

*----------------------------------------------------------------------*
* Get color
*----------------------------------------------------------------------*
  METHOD cell_getcolor.
    rs_cell-fname     = i_campo.
    rs_cell-color-col = i_color.
    
    "APPEND _getcolor('EQUNR') TO <fs_cab>-t_cellcol.
  ENDMETHOD.

*----------------------------------------------------------------------*
* Get style
*----------------------------------------------------------------------*
  METHOD cell_getstyle.
    rs_cell-fieldname = i_campo.
    rs_cell-style     = i_style.

    "INSERT _getstyle('SELEC') INTO TABLE lt_celltyl.
    "cs_det-t_celltyl[] = lt_celltyl[].
  ENDMETHOD.
  
ENDCLASS.

"*----------------------------------------------------------------------*
"* OUTPUT
"*----------------------------------------------------------------------*
"MODULE status_0100 OUTPUT.
"  go_100->r_alv_show( ).
"
"  SET PF-STATUS '100_ST'.
"  SET TITLEBAR '100_TI'.
"ENDMODULE.
"
"*----------------------------------------------------------------------*
"* INPUT
"*----------------------------------------------------------------------*
"MODULE user_command_0100 INPUT.
"  go_100->go_alv->check_changed_data( ).
"
"  CASE sy-ucomm.
"    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
"      SET SCREEN 0.
"      LEAVE SCREEN.
"  ENDCASE.
"ENDMODULE.