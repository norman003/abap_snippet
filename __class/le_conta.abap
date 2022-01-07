*----------------------------------------------------------------------*
* DEFINICION
*----------------------------------------------------------------------*
CLASS clu_contabilizar DEFINITION.
  PUBLIC SECTION.

*----------------------------------------------------------------------*
* Report
*----------------------------------------------------------------------*
    TYPES: BEGIN OF gty_cab,
             selec      TYPE char01,
             btn_status TYPE icon-id,
             recnr      TYPE numc4.
        INCLUDE TYPE zostb_noma_cab.
    TYPES: t_status   TYPE bapirettab,
           t_cellcol  TYPE lvc_t_scol,
           t_celltyl  TYPE lvc_t_styl,
           message    TYPE bapi_msg,
           END OF gty_cab.

*----------------------------------------------------------------------*
* Types
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Contantes
*----------------------------------------------------------------------*
    DATA: gc_atinn_claseaactividad TYPE atinn.
    CONSTANTS: gc_chare TYPE char1 VALUE 'E',
               gc_charw TYPE char1 VALUE 'W'.
    CONSTANTS: gc_green  TYPE char4 VALUE '@08@',
               gc_red    TYPE char4 VALUE '@0A@',
               gc_gray   TYPE char4 VALUE '@EB@',
               gc_yellow TYPE char4 VALUE '@09@'.
    CONSTANTS: gc_knttp_grafo TYPE knttp VALUE 'N'.

*----------------------------------------------------------------------*
* Contantes
*----------------------------------------------------------------------*
    DATA: BEGIN OF zconst,
            r_frgke     TYPE RANGE OF ekko-frgke,
          END OF zconst.

*----------------------------------------------------------------------*
* Data
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Publicos
*----------------------------------------------------------------------*
    METHODS constructor.
    METHODS save_contabilizar IMPORTING i_test TYPE xfeld
                              EXPORTING et_return TYPE bapirettab
                              CHANGING ct_cab TYPE gtt_cab EXCEPTIONS error.

*----------------------------------------------------------------------*
* Privados
*----------------------------------------------------------------------*
  PRIVATE SECTION.

*----------------------------------------------------------------------*
* Contabilizar
*----------------------------------------------------------------------*
    METHODS getconstantes.

    "Validar
    METHODS validar_contabilizar EXPORTING et_return TYPE bapirettab
                                 CHANGING ct_cab TYPE gtt_cab EXCEPTIONS error.
    "Contabilizar
    METHODS do_contabilizar EXPORTING et_return TYPE bapirettab
                            CHANGING ct_cab TYPE gtt_cab EXCEPTIONS error.

*----------------------------------------------------------------------*
* Anular
*----------------------------------------------------------------------*

*----------------------------------------------------------------------*
* Lib
*----------------------------------------------------------------------*
    METHODS _setrange IMPORTING i_sign   TYPE clike
                                i_option TYPE clike
                                i_low    TYPE clike
                                i_high   TYPE clike OPTIONAL
                      CHANGING  cr_range TYPE  table.
    METHODS _isconfirm IMPORTING i_question TYPE clike EXCEPTIONS cancel.
    METHODS _returnfromsy RETURNING VALUE(rs_return) TYPE bapiret2.
    METHODS _returnshow IMPORTING it_return TYPE bapirettab.
    METHODS _printmessage IMPORTING is_return TYPE bapiret2 OPTIONAL.
    METHODS _getcolor IMPORTING i_campo TYPE clike i_color TYPE i DEFAULT 6 RETURNING VALUE(rs_cell) TYPE lvc_s_scol.
    METHODS _getstyle IMPORTING i_campo        TYPE clike i_style TYPE lvc_style DEFAULT cl_gui_alv_grid=>mc_style_disabled
                      RETURNING VALUE(rs_cell) TYPE lvc_s_styl.
    METHODS _bapidatax IMPORTING is_data TYPE any CHANGING cs_datax TYPE any .
ENDCLASS.


*----------------------------------------------------------------------*
* IMPLEMENTACION
*----------------------------------------------------------------------*
CLASS clu_contabilizar IMPLEMENTATION.

*----------------------------------------------------------------------*
* Constructor
*----------------------------------------------------------------------*
  METHOD constructor.
    getconstantes( ).
  ENDMETHOD.


*----------------------------------------------------------------------*
* Lee constantes
*----------------------------------------------------------------------*
  METHOD getconstantes.
    DATA: lt_const TYPE TABLE OF zostb_constantes,
          ls_const LIKE LINE OF lt_const.

    "Get
    IMPORT zconst = zconst FROM MEMORY ID sy-repid.
    IF zconst IS INITIAL.
      SELECT * INTO TABLE lt_const
        FROM zostb_constantes
        WHERE programa = sy-repid.

      "Read
      LOOP AT lt_const INTO ls_const.
        CASE ls_const-campo.
          WHEN 'FRGKE'.
            _setrange( EXPORTING i_sign   = ls_const-signo
                                 i_option = ls_const-opcion
                                 i_low    = ls_const-valor1
                                 i_high   = ls_const-valor2
                       CHANGING cr_range = zconst-r_frgke ).
        ENDCASE.
      ENDLOOP.

      EXPORT zconst = zconst TO MEMORY ID sy-repid.
    ENDIF.
  ENDMETHOD.

*----------------------------------------------------------------------*
* Set range
*----------------------------------------------------------------------*
  METHOD _setrange.
    DATA: lo_type         TYPE REF TO clubap_structdescr,
          lt_comp         TYPE abap_component_tab,
          ls_comp         LIKE LINE OF lt_comp,
          lo_elem         TYPE REF TO  clubap_elemdescr,
          l_function_conv TYPE string.
    FIELD-SYMBOLS: <fs_range> TYPE  table,
                   <ls_line>  TYPE any,
                   <fs_field> TYPE any.

    ASSIGN cr_range TO <fs_range>.
    APPEND INITIAL LINE TO <fs_range> ASSIGNING <ls_line>.

    lo_type ?= clubap_typedescr=>describe_by_data( <ls_line> ).
    lt_comp = lo_type->get_components( ).
    READ TABLE lt_comp INTO ls_comp WITH KEY name = 'LOW'.
    lo_elem ?= ls_comp-type.
    IF lo_elem->edit_mask IS NOT INITIAL.
      CONCATENATE 'CONVERSION_EXIT_'  lo_elem->edit_mask '_INPUT' INTO l_function_conv.
      REPLACE '==' IN l_function_conv WITH ''.
    ENDIF.

    ASSIGN COMPONENT 'SIGN' OF STRUCTURE <ls_line> TO <fs_field>.
    IF <fs_field> IS ASSIGNED. <fs_field> = i_sign. ENDIF.
    ASSIGN COMPONENT 'OPTION' OF STRUCTURE <ls_line> TO <fs_field>.
    IF <fs_field> IS ASSIGNED. <fs_field> = i_option. ENDIF.
    ASSIGN COMPONENT 'LOW' OF STRUCTURE <ls_line> TO <fs_field>.
    IF <fs_field> IS ASSIGNED.
      <fs_field> = i_low.
      IF l_function_conv IS NOT INITIAL.
        CALL FUNCTION l_function_conv
          EXPORTING
            input  = <fs_field>
          IMPORTING
            output = <fs_field>.
      ENDIF.
    ENDIF.
    IF i_high IS NOT INITIAL.
      ASSIGN COMPONENT 'HIGH' OF STRUCTURE <ls_line> TO <fs_field>.
      IF <fs_field> IS ASSIGNED.
        <fs_field> = i_high.
        IF l_function_conv IS NOT INITIAL.
          CALL FUNCTION l_function_conv
            EXPORTING
              input  = <fs_field>
            IMPORTING
              output = <fs_field>.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


*----------------------------------------------------------------------*
* Contabilizar
*----------------------------------------------------------------------*
  METHOD save_contabilizar.


    "1. Validar datos
    validar_contabilizar(
      IMPORTING
        et_return = et_return
      CHANGING
        ct_cab = ct_cab
      EXCEPTIONS
        error = 1
    ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.


    CHECK i_test IS INITIAL.

    LOOP AT ct_cab TRANSPORTING NO FIELDS WHERE selec = abap_on AND statu <> gc_statu-activo.
    ENDLOOP.
    IF sy-subrc <> 0.
      MESSAGE e200 WITH 'Seleccion(e) registro(s) contabilizable(s)' RAISING error.
    ENDIF.


    "2. Mensaje de confirmacion
    _isconfirm(
      EXPORTING
        i_question = '¿Desea contabilizar?'
      EXCEPTIONS
        cancel     = 1
    ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.


    "3. Contabilizar
    do_contabilizar(
      IMPORTING
        et_return = et_return
      CHANGING
        ct_cab = ct_cab
      EXCEPTIONS
        error  = 1
    ).
    IF sy-subrc <> 0.
      _returnshow( et_return ).
    ENDIF.

  ENDMETHOD.


*----------------------------------------------------------------------*
* Validar contabilizar
*----------------------------------------------------------------------*
  METHOD validar_contabilizar.
    FIELD-SYMBOLS <fs_cab> LIKE LINE OF ct_cab.

    LOOP AT ct_cab ASSIGNING <fs_cab>.
      CLEAR: <fs_cab>-t_cellcol, <fs_cab>-t_status

      READ TABLE <fs_cab>-t_status WITH KEY type = gc_chare TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        <fs_cab>-btn_status = gc_red.
      ELSE.
        IF <fs_cab>-belnr IS INITIAL AND <fs_cab>-ebeln IS INITIAL AND <fs_cab>-lblni IS INITIAL.
          <fs_cab>-btn_status = gc_gray.
        ENDIF.
      ENDIF.
      APPEND LINES OF <fs_cab>-t_status TO et_return.
    ENDLOOP.


    "Resultado
    READ TABLE et_return INTO DATA(ls_return) INDEX 1.
    IF sy-subrc = 0.
      _printmessage( ls_return ).
    ELSE.
      MESSAGE s200 WITH 'Todo esta OK'.
    ENDIF.

    "Retorno final
    IF et_return IS NOT INITIAL.
      RAISE error.
    ENDIF.

  ENDMETHOD.

*----------------------------------------------------------------------*
* Contabilizar
*----------------------------------------------------------------------*
  METHOD do_contabilizar.

    "Resultado
    READ TABLE et_return WITH KEY type = gc_chare TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      RAISE error.
    ELSE.
      MESSAGE s200 WITH 'Documento(s) contabilizado(s) correctamente'.
    ENDIF.

  ENDMETHOD.

************************************************************************
* Lib
************************************************************************
*----------------------------------------------------------------------*
* ==> Mensaje de confirmación
* <== sy-subrc
*----------------------------------------------------------------------*
  METHOD _isconfirm.
    DATA: l_answer TYPE char01.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        titlebar              = 'Confirmación'  "text-c01
        text_question         = i_question
        icon_button_1         = '@2K@'
        icon_button_2         = '@2O@'
        display_cancel_button = space
      IMPORTING
        answer                = l_answer.

    IF l_answer = '1'.
      sy-subrc = 0.
    ELSE.
      MESSAGE e000(su) WITH 'Acción cancelada...' RAISING cancel.
    ENDIF.
  ENDMETHOD.


*----------------------------------------------------------------------*
* Return sy
*----------------------------------------------------------------------*
  METHOD _returnfromsy.
    MOVE: sy-msgv1 TO rs_return-message_v1,
          sy-msgv2 TO rs_return-message_v2,
          sy-msgv3 TO rs_return-message_v3,
          sy-msgv4 TO rs_return-message_v4,
          sy-msgid TO rs_return-id,
          sy-msgno TO rs_return-number,
          sy-msgty TO rs_return-type.
    "i_row    TO rs_return-row.
    MESSAGE ID rs_return-id TYPE 'S' NUMBER  rs_return-number
    WITH rs_return-message_v1 rs_return-message_v2 rs_return-message_v3 rs_return-message_v4
    INTO rs_return-message.

    CLEAR: sy-msgid, sy-msgty, sy-msgno,
           sy-msgv1, sy-msgv2, sy-msgv3, sy-msgv4.
    
    "APPEND _returnfromsy( ) TO <fs_cab>-t_status.
  ENDMETHOD.


*----------------------------------------------------------------------*
* Show return
*----------------------------------------------------------------------*
  METHOD _returnshow.
    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = it_return.
  ENDMETHOD.

*----------------------------------------------------------------------*
* Print message
*----------------------------------------------------------------------*
  METHOD _printmessage.
    IF is_return IS NOT INITIAL.
      MOVE: is_return-message_v1 TO sy-msgv1,
            is_return-message_v2 TO sy-msgv2,
            is_return-message_v3 TO sy-msgv3,
            is_return-message_v4 TO sy-msgv4,
            is_return-id         TO sy-msgid,
            is_return-number     TO sy-msgno,
            is_return-type       TO sy-msgty.
    ENDIF.

    IF sy-msgty = 'E'.
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    ELSE.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
             WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.

*----------------------------------------------------------------------*
* Get color
*----------------------------------------------------------------------*
  METHOD _getcolor.
    rs_cell-fname     = i_campo.
    rs_cell-color-col = i_color.
    
    "APPEND _getcolor('EQUNR') TO <fs_cab>-t_cellcol.
  ENDMETHOD.


*----------------------------------------------------------------------*
* Get style
*----------------------------------------------------------------------*
  METHOD _getstyle.
    rs_cell-fieldname = i_campo.
    rs_cell-style     = i_style.

    "INSERT _getstyle('SELEC') INTO TABLE lt_celltyl.
    "cs_det-t_celltyl[] = lt_celltyl[].
  ENDMETHOD.

*----------------------------------------------------------------------*
* Get bapi data x
*----------------------------------------------------------------------*
  METHOD _bapidatax.
    DATA: lo_struct  TYPE REF TO clubap_structdescr,
          lo_structx TYPE REF TO clubap_structdescr,
          ls_comps   LIKE LINE OF lo_struct->components,
          ls_compsx  LIKE LINE OF lo_struct->components.

    FIELD-SYMBOLS: <fs_campo>  TYPE any,
                   <fs_campox> TYPE any.

    lo_struct ?= clubap_structdescr=>describe_by_data( is_data ).
    lo_structx ?= clubap_structdescr=>describe_by_data( cs_datax ).

    LOOP AT lo_struct->components INTO ls_comps.
      ASSIGN COMPONENT ls_comps-name OF STRUCTURE is_data TO <fs_campo>.
      ASSIGN COMPONENT ls_comps-name OF STRUCTURE cs_datax TO <fs_campox>.
      IF sy-subrc = 0.
        IF <fs_campo> IS NOT INITIAL.
          READ TABLE lo_structx->components INTO ls_compsx WITH KEY name = ls_comps-name.
          IF ls_compsx-length EQ 1.
            <fs_campox> = abap_true.
          ELSE.
            <fs_campox> = <fs_campo>.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    ASSIGN COMPONENT 'UPDATEFLAG' OF STRUCTURE cs_datax TO <fs_campox>.
    IF sy-subrc = 0.
      <fs_campox> = 'X'.
    ENDIF.
  ENDMETHOD.

ENDCLASS.