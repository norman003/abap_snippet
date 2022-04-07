METHODS r_alvevent_f4 FOR EVENT onf4 OF cl_gui_alv_grid IMPORTING e_fieldname e_fieldvalue es_row_no er_event_data et_bad_cells e_display.

*----------------------------------------------------------------------*
* F4
*----------------------------------------------------------------------*
  METHOD r_alvevent_f4.
*    CASE e_fieldname.
*      WHEN 'ACTIVIDAD'.
*        f4_actividad( es_row_no  ).
*        alv_refresh( ).
*        er_event_data->m_event_handled = abap_on.
*      WHEN OTHERS.
*    ENDCASE.
  ENDMETHOD.
  
*    METHODS: f4_actividad IMPORTING es_row_no TYPE lvc_s_roid.
  
**----------------------------------------------------------------------*
** F4 Ayuda
**----------------------------------------------------------------------*
*  METHOD f4_actividad.
*    TYPES: BEGIN OF ty_f4,
*             actividad TYPE zostb_actfundo-actividad,
*             ltxa1     TYPE zostb_actfundo-ltxa1,
*           END OF ty_f4.
*
*    DATA: lt_f4     TYPE TABLE OF ty_f4,
*          lt_return TYPE ism_ddshretval,
*          ls_return LIKE LINE OF lt_return.
*
*    "Get
*    SELECT actividad ltxa1
*      INTO TABLE lt_f4
*      FROM zostb_actfundo
*      WHERE id_equi = abap_on.
*
*    SORT lt_f4 BY actividad.
*    DELETE ADJACENT DUPLICATES FROM lt_f4 COMPARING actividad.
*    IF lt_f4 IS INITIAL.
*      MESSAGE s000(su) WITH 'Sin entradas...'.
*      EXIT.
*    ENDIF.
*
*    "Show
*    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*      EXPORTING
*        retfield     = 'ACTIVIDAD'
*        window_title = 'Actividades Fundo'
*        value_org    = 'S'
*      TABLES
*        value_tab    = lt_f4
*        return_tab   = lt_return.
*
*    "Return
*    READ TABLE lt_return INTO ls_return INDEX 1.
*    IF sy-subrc = 0.
*      FIELD-SYMBOLS: <fs_100> LIKE LINE OF gt_det.
*
*      READ TABLE gt_det ASSIGNING <fs_100> INDEX es_row_no-row_id.
*      IF sy-subrc = 0.
*        "<fs_100>-actividad = ls_return-fieldval.
*      ENDIF.
*    ELSE.
*      MESSAGE s000(su) WITH 'Accion cancelada...' DISPLAY LIKE 'E'.
*    ENDIF.
*  ENDMETHOD.                    "f4_actividad