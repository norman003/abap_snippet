CLASS lcl_report DEFINITION DEFERRED.
DATA: go_report TYPE REF TO lcl_report.

*--------------------------------------------------------------------*
CLASS lcl_report DEFINITION.
  PUBLIC SECTION.

***--------------------------------------------------------------------*
*** Declaracion
***--------------------------------------------------------------------*
**    "Tipos
**    "Tipos tablas
**    "Estructura
**    TYPES: BEGIN OF gty_range,
**             bukrs TYPE RANGE OF bukrs,
**           END OF gty_range.
**    TYPES: BEGIN OF gty_table,
**             t001 TYPE TABLE OF t001 WITH DEFAULT KEY,
**           END OF gty_table.
**
*--------------------------------------------------------------------*
* Reporte
*--------------------------------------------------------------------*
    "Tipos
    TYPES: gty_param TYPE gty_param.
    TYPES: BEGIN OF gty_const,
              r_bukrs TYPE RANGE OF bukrs,
            END OF gty_const.

    TYPES: BEGIN OF gty_det.
        INCLUDE TYPE t001.
    TYPES:
**             "editable
**             icon      TYPE icon-id,
**             return    TYPE bapirettab,
**             selec     TYPE xfeld,
**             cellstyle TYPE lvc_t_styl,
**             cellcolor TYPE lvc_t_scol,
**             statu     TYPE char13,
**             message   TYPE char100,
            END OF gty_det.

    "Tipos tablas
    TYPES: gtt_det  TYPE TABLE OF gty_det WITH DEFAULT KEY.

    "Tablas internas
    DATA: gt_det  TYPE gtt_det.

    "Estructuras
    "Variables
    DATA: zconst TYPE gty_const,
          zparam TYPE gty_param.
    "Objetos
    DATA: ui TYPE REF TO lcl_util.

    "Methods
    METHODS a_report IMPORTING iparam TYPE gty_param EXCEPTIONS error.
    METHODS b_report_show CHANGING ct_table TYPE STANDARD TABLE.
    METHODS constructor.
**    DATA: go_100 TYPE REF TO cl_gui_alv_grid.
**    METHODS b_st CHANGING ct_excl TYPE slis_t_extab.
**    METHODS b_uc IMPORTING i_ucomm TYPE clike CHANGING cs_sel TYPE slis_selfield.
**    METHODS b_event.
**    METHODS b_changed FOR EVENT data_changed_finished OF cl_gui_alv_grid IMPORTING e_modified et_good_cells.
**
*--------------------------------------------------------------------*
*  Privada
*--------------------------------------------------------------------*
  PRIVATE SECTION.
    "Constantes
    "Proceso
**    METHODS a_report_text IMPORTING ir TYPE gty_range CHANGING ct_det TYPE gtt_det.
**    METHODS do_contabilizar EXCEPTIONS error.
**    METHODS do_mir7 IMPORTING is_det TYPE gty_det EXPORTING et_return TYPE bapirettab e_message TYPE char100 EXCEPTIONS error.
ENDCLASS.
*--------------------------------------------------------------------*
CLASS lcl_report IMPLEMENTATION. "'


  METHOD a_report. "'
**    DATA: ls_det LIKE LINE OF gt_det.
**    DATA: lr      TYPE gty_range.

*--------------------------------------------------------------------*
*   I. GET DATA"'
*--------------------------------------------------------------------*
    "'1 Clear
    CLEAR gt_det.

***--------------------------------------------------------------------*
**    "Costos
**    SELECT kokrs,belnr,buzei,perio,wogbtr,wkgbtr,mbgbtr,objnr,gjahr,wrttp,versn,kstar,hrkft,
**           vrgng,parob1,meinh,werks,matnr,ebeln,ebelp,bukrs,kostl,aufnr,autyp,pspnr
**      INTO TABLE @DATA(ltcovp)
**      FROM v_covp
**      WHERE kokrs = @zparam-kokrs
**        AND bukrs = @zparam-bukrs
**        AND gjahr = @zparam-gjahr
**        AND perio = @zparam-perio
**        AND budat IN @zparam-r_budat
**        AND wrttp EQ '04'
**        AND versn EQ '000'.
**
**    LOOP AT lt_covp ASSIGNING FIELD-SYMBOL(<fs>).
**      IF <fs>-aufnr IS NOT INITIAL. ls_aufnr-low = <fs>-aufnr. COLLECT ls_aufnr INTO lr-aufnr. ENDIF.
**    ENDLOOP.
**    SORT lr-aufnr BY low.
*--------------------------------------------------------------------*
    "'2 Data

*--------------------------------------------------------------------*
*   II. BUILD REPORT"'
*--------------------------------------------------------------------*
    IF gt_det IS INITIAL.
      MESSAGE e000(su) WITH 'No se encontraron datos para el reporte' RAISING error.
    ENDIF.

**    a_report_text( EXPORTING ir = lr CHANGING ct_det = gt_det  ).

    "'3 alv
    b_report_show( CHANGING ct_table = gt_det ).

  ENDMETHOD.
**
**
**  METHOD a_report_text.
**  ENDMETHOD.


  METHOD b_report_show. "'
    DATA: ls_layo TYPE lvc_s_layo,
          lt_fcat TYPE lvc_t_fcat,
          ls_vari TYPE disvariant,
          l_campo TYPE string.
    FIELD-SYMBOLS: <fs_fcat> LIKE LINE OF lt_fcat.

    "'1 Message
    DESCRIBE TABLE ct_table.
    MESSAGE s000(su) WITH 'Se visualizan' sy-tfill 'registros'.

    "'2 Layout
    ls_layo-zebra      = abap_on.
    ls_layo-cwidth_opt = abap_on.
    ls_layo-col_opt    = abap_on.
**    ls_layo-no_rowmark = abap_on.
**    ls_layo-box_fname  = 'BOX'.
**    ls_layo-ctab_fname = 'CELLCOLOR'.
**    ls_layo-stylefname = 'CELLSTYLE'.
**    ls_layo-info_fname = 'COLOR'.       ls_report-color = 'C700'.
**    ls_layo-grid_title = 'Reporte'.

    "'3 Variante
    ls_vari-username = sy-uname.
    ls_vari-report   = sy-repid.
    ls_vari-handle   = sy-dynnr.

    "'4 Catalogo
    CONCATENATE 'rsnum,rspos,bwart,zzerdat,xwaok,difer,message' ''
                INTO l_campo.
    ui->alv_fcatgen( IMPORTING et_fcat = lt_fcat CHANGING ct_table = ct_table c_campo = l_campo ).

    "'5 Fcat - Descripcion
    LOOP AT lt_fcat ASSIGNING <fs_fcat>.
      CASE <fs_fcat>-fieldname.
**        WHEN 'ICON'.       <fs_fcat>-hotspot = abap_on. <fs_fcat>-just = 'C'.
**        WHEN 'MESSAGE4'.   <fs_fcat>-tech = abap_on.
**        WHEN 'TEXT'.       <fs_fcat>-edit = abap_on.
**        WHEN 'STAT_USER'.  <fs_fcat>-outputlen = 4.
**        WHEN 'NETWR'.      <fs_fcat>-emphasize = 'C700'.
**        WHEN 'K0001'.      ui->alv_fcatname( EXPORTING i_unico = 'Observación' CHANGING cs_fcat = <fs_fcat> ).
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

    "'6 Alv
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
        i_bypassing_buffer = abap_on
        i_buffer_active    = abap_on
        i_callback_program = sy-repid
        is_layout_lvc      = ls_layo
        it_fieldcat_lvc    = lt_fcat
        i_save             = 'A'
**        i_callback_pf_status_set = 'B_ST'
**        i_callback_user_command  = 'B_UC'
        is_variant         = ls_vari
      TABLES
        t_outtab           = ct_table
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


**  METHOD b_st.
**    DATA: lt_fcode TYPE TABLE OF smp_dyntxt,
**          ls_fcode LIKE LINE OF lt_fcode.
**
**    ui->alvlvc_excludest( CHANGING ct_excl = ct_excl ).
**
**    "Añadir FC01
**    ls_fcode-icon_id   = icon_print.
**    ls_fcode-icon_text = 'Imprimir'.
**    ls_fcode-text      = 'Imprimir Formulario'.
**    APPEND ls_fcode TO lt_fcode.
**
**    PERFORM dynamic_report_fcodes IN PROGRAM rhteiln0 TABLES lt_fcode USING ct_excl '' ''.
***  SET PF-STATUS 'ALVLIST' EXCLUDING ct_excl OF PROGRAM 'RHTEILN0'.
**  ENDMETHOD.
**
**
**  METHOD b_uc.
**    CASE i_ucomm.
**      WHEN '&IC1'.
**        READ TABLE gt_det INTO DATA(ls_det) INDEX cs_sel-tabindex.
**        CASE cs_sel-fieldname.
**          WHEN 'ICON'. ui->return_show( ls_det-return ).
**          WHEN 'BELNR'.
**          WHEN OTHERS.
**        ENDCASE.
**      WHEN 'FC01'.
**      WHEN '/&REFRESH'. ui->alvlvc_refresh( CHANGING cs_sel = cs_sel ).
**      WHEN OTHERS.
**    ENDCASE.
**  ENDMETHOD.
**
**
**  METHOD b_event.
**    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
**      IMPORTING
**        e_grid = go_100.
**
**    SET HANDLER b_changed FOR go_100.
**    go_100->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
**    go_100->register_edit_event( cl_gui_alv_grid=>mc_evt_enter ).
**  ENDMETHOD.
**
**  METHOD b_changed.
**  ENDMETHOD.


  METHOD constructor. "'
    CREATE OBJECT ui.

    DATA: lt_const TYPE TABLE OF zostb_constantes,
          ls_const LIKE LINE OF lt_const.

    "'1 Get constantes
    SELECT * INTO TABLE lt_const
      FROM zostb_constantes
      WHERE programa = sy-repid.

    "'2 Build constantes
    LOOP AT lt_const INTO ls_const.
      CASE ls_const-campo.
**          WHEN 'BEGDA'.  ui->const_range_set( EXPORTING is_const = ls_const CHANGING cr_range = zconst-r_ ).
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.


ENDCLASS.
**
**FORM b_st CHANGING ct_excl TYPE slis_t_extab.
**  go_report->b_st( CHANGING ct_excl = ct_excl ).
**ENDFORM.                    "b_st
**
**FORM b_uc USING i_ucomm TYPE sy-ucomm cs_sel TYPE slis_selfield.
**  go_report->b_uc( EXPORTING i_ucomm = i_ucomm CHANGING cs_sel = cs_sel ).
**ENDFORM.                    "b_uc
**
**FORM b_event USING is_exit TYPE slis_data_caller_exit.
**  go_report->b_event( ).
**ENDFORM.
**
FORM create. "'
  CREATE OBJECT go_report.

**  go_report->zparam-r_bukrs = s_bukrs[].
ENDFORM.