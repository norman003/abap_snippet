REPORT ysalv.

*----------------------------------------------------------------------*
*       CLASS cl_event_handler DEFINITION
*----------------------------------------------------------------------*
CLASS zcl_alv DEFINITION.
  PUBLIC SECTION.
    DATA: gt_usr   TYPE TABLE OF usr02,
          gs_usr   TYPE usr02.

    METHODS alv_show CHANGING ct_table TYPE STANDARD TABLE.
    METHODS alv_uc     FOR EVENT if_salv_events_functions~added_function   OF cl_salv_events_table IMPORTING e_salv_function.
    METHODS alv_double FOR EVENT if_salv_events_actions_table~double_click OF cl_salv_events_table IMPORTING row column.
    METHODS alv_click  FOR EVENT if_salv_events_actions_table~link_click   OF cl_salv_events_table IMPORTING row column.
ENDCLASS.                    "cl_event_handler DEFINITION

*----------------------------------------------------------------------*
*       CLASS cl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS zcl_alv IMPLEMENTATION.

  METHOD alv_show.
    DATA: lo_alv        TYPE REF TO cl_salv_table,
          lo_functions  TYPE REF TO cl_salv_functions_list,
          lo_display    TYPE REF TO cl_salv_display_settings,
          lo_events     TYPE REF TO cl_salv_events_table,
          lo_cols       TYPE REF TO cl_salv_columns_table,
          lo_col        TYPE REF TO cl_salv_column_list,
          lo_tt         TYPE REF TO cl_abap_tabledescr,
          lo_ty         TYPE REF TO cl_abap_structdescr,
          ls_comp       LIKE LINE OF lo_ty->components,
          l_short       TYPE scrtext_s,
          l_medium      TYPE scrtext_m,
          l_long        TYPE scrtext_l.

    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = ct_table ).

        "Layout
        lo_functions = lo_alv->get_functions( ).
        lo_functions->set_default( abap_on ).
        lo_cols = lo_alv->get_columns( ).
        lo_cols->set_optimize( abap_on ).
        "lo_display = lo_alv->get_display_settings( ).
        "lo_display->set_list_header( i_title ).

        "Fcat
        lo_tt  ?= cl_abap_tabledescr=>describe_by_data( ct_table ).
        lo_ty  ?= lo_tt->get_table_line_type( ).
        LOOP AT lo_ty->components INTO ls_comp.
          lo_col ?= lo_cols->get_column( ls_comp-name ).
          l_short = ls_comp-name.
          l_medium = ls_comp-name.
          l_long = ls_comp-name.
          lo_col->set_short_text( l_short ).
          lo_col->set_medium_text( l_medium ).
          lo_col->set_long_text( l_long ).
          CASE ls_comp-name.
            WHEN 'VAL'.
              lo_col->set_cell_type( if_salv_c_cell_type=>hotspot ).
            WHEN OTHERS.
          ENDCASE.
        ENDLOOP.

        "Eventos
        lo_events = lo_alv->get_event( ).
        SET HANDLER alv_uc FOR lo_events.
        SET HANDLER alv_double FOR lo_events.
        SET HANDLER alv_click FOR lo_events.

        "Display
        lo_alv->display( ).

      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.                    "alv_show

  METHOD alv_click.
  ENDMETHOD.

  METHOD alv_double.
  ENDMETHOD.

  METHOD alv_uc.
  ENDMETHOD.

ENDCLASS.                    "cl_event_handler IMPLEMENTATION

*&---------------------------------------------------------------------*
*&      START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  DATA alv TYPE REF TO zcl_alv.
  CREATE OBJECT alv.
  SELECT * FROM usr02 UP TO 30 ROWS APPENDING CORRESPONDING FIELDS OF TABLE alv->gt_usr ORDER BY bname.
  alv->alv_show( ct_table = alv->gt_usr ).