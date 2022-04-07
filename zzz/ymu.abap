REPORT ymu MESSAGE-ID su.
*--------------------------------------------------------------------*
* Programa para subidas de ot
* Created  2016.05.27 - by norman tinco
* Modified 2019.05.27 - 100
*--------------------------------------------------------------------*
TYPE-POOLS: slis.
TABLES: sscrfields, e070.
DATA: ls_fk   TYPE smp_dyntxt.


SELECTION-SCREEN FUNCTION KEY 1.
SELECTION-SCREEN FUNCTION KEY 2.
SELECTION-SCREEN FUNCTION KEY 3.
SELECTION-SCREEN FUNCTION KEY 4.
SELECTION-SCREEN FUNCTION KEY 5.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (10) trkorr.
PARAMETERS: p_trkorr TYPE e070-trkorr MEMORY ID rf_korrnum.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN COMMENT (10) file.
PARAMETERS: p_file   TYPE char255 MEMORY ID dfd DEFAULT 'D:\ym\Otdata'.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF SCREEN 300.
PARAMETERS: p_ot2 TYPE e070v-trkorr.
SELECTION-SCREEN END OF SCREEN 300.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  DATA: l_file TYPE string.
  cl_gui_frontend_services=>directory_browse( CHANGING selected_folder = l_file ).
  p_file = l_file.


INITIALIZATION.
  IF sy-binpt = 'X'. CALL SELECTION-SCREEN 300. ENDIF.

  trkorr = 'Ot'.
  file   = 'Direccion'.

  sscrfields-functxt_01 = 'Lib & Down OT'.
  sscrfields-functxt_02 = 'Upload OT'.
  sscrfields-functxt_03 = 'Ver en se09'.
  sscrfields-functxt_04 = 'Ver log'.
  sscrfields-functxt_05 = 'YMT'.

  "PERFORM 000_checkversion USING sy-repid.

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'ONLI'.
    WHEN 'FC01'. PERFORM _executef8.
    WHEN 'FC02'. PERFORM subir_ot.
    WHEN 'FC03'.
      CALL FUNCTION 'TR_PRESENT_REQUEST'
        EXPORTING
          iv_trkorr = p_trkorr.
    WHEN 'FC04'. PERFORM _showlog USING p_trkorr.
    WHEN 'FC05'. SUBMIT ymt VIA SELECTION-SCREEN AND RETURN.
    WHEN 'CRET'. PERFORM agregar_transporte USING p_ot2.
  ENDCASE.

START-OF-SELECTION.
  DATA: bdcdata  TYPE TABLE OF bdcdata,
        bdcmsg   TYPE TABLE OF bdcmsgcoll,
        bdcopt   TYPE ctu_params.
  DATA: l_ot_dir  TYPE text255,
        l_ot_file TYPE char20.

  CHECK p_trkorr IS NOT INITIAL.

  PERFORM liberar_ot USING p_trkorr.
  CHECK sy-subrc = 0.

  MESSAGE i000 WITH 'Refrescar hasta ver linea Export'.

  "PERFORM bajar_descripcion_ot.

  PERFORM obtener_ot_dir CHANGING l_ot_dir.

  CONCATENATE p_trkorr+3(7) '.' p_trkorr(3) INTO l_ot_file.
  PERFORM descargar_archivo USING l_ot_dir 'cofiles' l_ot_file p_file.

  l_ot_file(1) = 'R'.
  PERFORM descargar_archivo USING l_ot_dir 'data' l_ot_file p_file.

  MESSAGE 'Ot descargada' TYPE 'S'.


*&---------------------------------------------------------------------*
*&      Form  subir_ot
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM subir_ot.

  DATA: l_ot_dir  TYPE text255,
        l_ot_file TYPE char20,
        lt_e071   TYPE TABLE OF e071.

  CHECK p_trkorr IS NOT INITIAL.

  "PERFORM _isconfirm USING 'Deseas subir_ot ot'.
  "CHECK sy-subrc = 0.

  PERFORM obtener_ot_dir CHANGING l_ot_dir.

  CONCATENATE p_trkorr+3(7) '.' p_trkorr(3) INTO l_ot_file.
  PERFORM cargar_archivo USING l_ot_dir 'cofiles' l_ot_file p_file.

  l_ot_file(1) = 'R'.
  PERFORM cargar_archivo USING l_ot_dir 'data' l_ot_file p_file.

  PERFORM transport_ot USING p_trkorr.
  MESSAGE 'Ot transportada' TYPE 'S'.

  PERFORM actualizar_srcsystem USING p_trkorr.

  SELECT * INTO TABLE lt_e071 FROM e071 WHERE trkorr = p_trkorr.

  CALL FUNCTION 'TR_REQUEST_CHOICE'
    EXPORTING
      it_e071 = lt_e071.

ENDFORM.                    "subir_ot

*&---------------------------------------------------------------------*
*&      Form  obtener_ot_dir
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->E_OT_DIR   text
*----------------------------------------------------------------------*
FORM obtener_ot_dir CHANGING e_ot_dir.

  CALL FUNCTION 'RSPO_R_SAPGPARAM'
    EXPORTING
      name   = 'DIR_TRANS'
    IMPORTING
      value  = e_ot_dir
    EXCEPTIONS
      error  = 0
      OTHERS = 0.

ENDFORM.                    "obtener_ot_dir

*&---------------------------------------------------------------------*
*&      Form  descargar_archivo
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM descargar_archivo USING l_ot_dir i_file i_ot_file i_destino.
  DATA: l_destino_file TYPE string,
        l_origen_file  TYPE eseftappl,
        l_error        TYPE c,
        l_message      TYPE c,
        l_separador    TYPE c.

  CASE l_ot_dir(1).
    WHEN '/'. l_separador = '/'.
    WHEN '\'. l_separador = '\'.
    WHEN OTHERS.
  ENDCASE.

  CONCATENATE l_ot_dir i_file i_ot_file INTO l_origen_file SEPARATED BY l_separador.
  CONCATENATE i_destino p_trkorr i_ot_file INTO l_destino_file SEPARATED BY '\'.

  sy-cprog = 'RC1TCG3Y'.

  CALL FUNCTION 'C13Z_FILE_DOWNLOAD_BINARY'
    EXPORTING
      i_file_front_end    = l_destino_file
      i_file_appl         = l_origen_file
      i_file_overwrite    = abap_on
    IMPORTING
      e_flg_open_error    = l_error
      e_os_message        = l_message
    EXCEPTIONS
      fe_file_open_error  = 1
      fe_file_exists      = 2
      fe_file_write_error = 3
      ap_no_authority     = 4
      ap_file_open_error  = 5
      ap_file_empty       = 6
      OTHERS              = 7.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.                    "descargar_archivo

*&---------------------------------------------------------------------*
*&      Form  cargar_archivo
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM cargar_archivo USING l_ot_dir l_file l_ot_file l_origen.
  DATA: l_origen_file  TYPE string,
        l_destino_file TYPE eseftappl,
        l_error        TYPE c,
        l_message      TYPE c,
        l_separador    TYPE c.

  CASE l_ot_dir(1).
    WHEN '/'. l_separador = '/'.
    WHEN '\'. l_separador = '\'.
    WHEN OTHERS.
  ENDCASE.

  CONCATENATE l_origen p_trkorr l_ot_file INTO l_origen_file SEPARATED BY '\'.
  CONCATENATE l_ot_dir l_file l_ot_file INTO l_destino_file SEPARATED BY l_separador.

  PERFORM file_check_exist USING l_origen_file.

  sy-cprog = 'RC1TCG3Z'.

  CALL FUNCTION 'C13Z_FILE_UPLOAD_BINARY'
    EXPORTING
      i_file_front_end   = l_origen_file
      i_file_appl        = l_destino_file
      i_file_overwrite   = abap_on
    IMPORTING
      e_flg_open_error   = l_error
      e_os_message       = l_message
    EXCEPTIONS
      fe_file_not_exists = 1
      fe_file_read_error = 2
      ap_no_authority    = 3
      ap_file_open_error = 4
      ap_file_exists     = 5
      ap_convert_error   = 6
      OTHERS             = 7.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.                    "cargar_archivo
*&---------------------------------------------------------------------*
*&      Form  AGREGAR_TRANSPORTE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM agregar_transporte  USING i_ot TYPE trkorr.
  DATA: l_sistema TYPE tmscsys-sysnam.

* Check authority to add request to the import queue
  CALL FUNCTION 'TR_AUTHORITY_CHECK_ADMIN'
    EXPORTING
      iv_adminfunction = 'TADD'
    EXCEPTIONS
      e_no_authority   = 1
      e_invalid_user   = 2
      OTHERS           = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  l_sistema = sy-sysid.

  CALL FUNCTION 'TMS_UI_APPEND_TR_REQUEST'
    EXPORTING
      iv_system             = l_sistema
      iv_request            = i_ot
      iv_expert_mode        = 'X'
      iv_ctc_active         = 'X'
    EXCEPTIONS
      cancelled_by_user     = 1
      append_request_failed = 2
      OTHERS                = 3.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  CALL FUNCTION 'TMS_UI_IMPORT_TR_REQUEST'
    EXPORTING
      iv_system             = l_sistema
      iv_request            = i_ot
    EXCEPTIONS
      cancelled_by_user     = 1
      import_request_denied = 2
      import_request_failed = 3
      OTHERS                = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.                    " AGREGAR_TRANSPORTE

**&---------------------------------------------------------------------*
**&      Form  bajar_descripcion_ot
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*FORM bajar_descripcion_ot.
*
*  DATA: lt_e070v TYPE TABLE OF e070v,
*        lt_e071  TYPE TABLE OF e071,
*        lt_doktl TYPE TABLE OF doktl,
*        ls_e070v LIKE LINE OF lt_e070v,
*        ls_doktl LIKE LINE OF lt_doktl,
*        l_desc   TYPE string,
*        l_fecha  TYPE string.
*
** Nombre de licencia
**  PERFORM _uploadym.
*
** Creando descripcion de la ot con los objetos adjuntados
*  SELECT * INTO TABLE lt_e070v FROM e070v WHERE strkorr = p_trkorr.
*  SELECT * INTO TABLE lt_e070v FROM e070v WHERE trkorr = p_trkorr.    "I-NTP180518-3000009382
*  IF lt_e070v IS NOT INITIAL.
*    SELECT * INTO TABLE lt_e071 FROM e071 FOR ALL ENTRIES IN lt_e070v WHERE trkorr = lt_e070v-trkorr.
*  ELSE.
*    SELECT * INTO TABLE lt_e071 FROM e071 WHERE trkorr = p_trkorr.
*  ENDIF.
*
** Obtener informacion del comentario
**  SELECT * INTO TABLE lt_doktl FROM doktl WHERE id = 'TA' AND object = p_trkorr AND langu = sy-langu AND typ = 'T' AND dokversion = '1'.
*  LOOP AT lt_doktl INTO ls_doktl.
*    IF l_desc IS INITIAL.
*      l_desc = ls_doktl-doktext.
*    ELSE.
*      CONCATENATE l_desc ls_doktl-doktext INTO l_desc SEPARATED BY space.
*    ENDIF.
*  ENDLOOP.
**{I-NTP180518-3000009382
*  IF sy-subrc <> 0.
*    READ TABLE lt_e070v INTO ls_e070v INDEX 1.
*    IF sy-subrc = 0.
*      l_desc = ls_e070v-as4text.
*    ENDIF.
*  ENDIF.
**}I-NTP180518-3000009382
*
*  "Limpiar caracteres no permitidos
*  REPLACE '/' IN l_desc WITH ''. REPLACE '\' IN l_desc WITH ''. REPLACE ':' IN l_desc WITH ''.
*  REPLACE '?' IN l_desc WITH ''. REPLACE '"' IN l_desc WITH ''. REPLACE '>' IN l_desc WITH ''.
*  REPLACE '<' IN l_desc WITH ''.
*
**  l_fecha = sy-datum+2(6).
*
*  "Dir
*  REPLACE ':' IN l_desc WITH '_'.
**  CONCATENATE p_file '\' p_trkorr '-' zym-empresa '-' l_desc '-' l_fecha '.txt' INTO zym-empresa.  "E-NTP180518-3000009382
*  CONCATENATE p_file '\' zym-empresa '-' p_trkorr '-' l_desc '.txt' INTO zym-empresa.               "I-NTP180518-3000009382
*
** Down
*  PERFORM _downtable USING zym-empresa lt_e071.
*
*ENDFORM.                    "bajar_descripcion_ot

*&---------------------------------------------------------------------*
*&      Form  transport_ot
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->I_OT       text
*----------------------------------------------------------------------*
FORM transport_ot USING i_ot TYPE trkorr.

  DATA lic_ TYPE string.

  CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER'
    IMPORTING
      license_number = lic_.

  REFRESH: bdcdata, bdcmsg.
  PERFORM bdc_dynpro      USING 'SAPLWBABAP' '0100'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=STRT'.
  PERFORM bdc_field       USING 'RS38M-PROGRAMM'      sy-repid.   "Programa actualizador
  PERFORM bdc_dynpro      USING sy-repid '0300'.                  "Programa actualizador
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=CRET'.
  PERFORM bdc_field       USING 'P_OT2'          i_ot.
  PERFORM bdc_dynpro      USING 'SAPLTMSU' '0240'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=OKAY'.
  PERFORM bdc_field       USING 'WTMSU-CLIENT'    sy-mandt.
  PERFORM bdc_field       USING 'WTMSU-IMP_AGAIN'    'X'.
  PERFORM bdc_dynpro      USING 'SAPLSPO1' '0100'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=YES'.
  PERFORM bdc_dynpro      USING 'SAPLTMSU' '0220'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=IOPT'.
  PERFORM bdc_field       USING 'WTMSU-CLIENT'    sy-mandt.
  PERFORM bdc_dynpro      USING 'SAPLTMSU' '0220'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=OKAY'.
  PERFORM bdc_field       USING 'GS_DYN220-IMP_AGAIN' 'X'.
  PERFORM bdc_field       USING 'GS_DYN220-IGN_ORIG' 'X'.
  PERFORM bdc_field       USING 'GS_DYN220-IGN_REP' 'X'.
  PERFORM bdc_field       USING 'GS_DYN220-IGN_TYP' 'X'.
  PERFORM bdc_field       USING 'GS_DYN220-IGN_TAB' 'X'.
  PERFORM bdc_field       USING 'GS_DYN220-IGN_PRE' 'X'.
  IF lic_ = '0020673876'    "Beta
    OR lic_ = '0020729594'  "Austral
    "OR numb = '0020311006'  "Aib     "I-240518
    OR lic_ = '0020181230'  "c2e2    "I-040618
    OR lic_ = '0020241712'. "Exalmar "I-NTP120618-120618
    PERFORM bdc_field       USING 'GS_DYN220-IGN_CVERS' 'X'.
  ENDIF.
  PERFORM bdc_dynpro      USING 'SAPLSPO1' '0600'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=OPT1'.
  PERFORM bdc_dynpro      USING sy-repid '1000'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '/EE'.
  PERFORM bdc_dynpro      USING 'SAPLWBABAP' '0100'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=BACK'.

  CALL TRANSACTION 'SE38' USING  bdcdata MODE 'N' UPDATE 'S' MESSAGES INTO bdcmsg.

  WAIT UP TO 120 SECONDS. "2 Minutos
ENDFORM.                    "transport_ot

*&---------------------------------------------------------------------*
*&      Form  file_check_exist
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->L_FILE     text
*----------------------------------------------------------------------*
FORM file_check_exist USING l_file TYPE string.

  DATA l_result TYPE string.

  cl_gui_frontend_services=>file_exist(
    EXPORTING
      file                 = l_file
    RECEIVING
      result               = l_result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5
  ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    "file_check_exist

*&---------------------------------------------------------------------*
*&      Form  upd_srcsystem
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM upd_srcsystem USING i_paq TYPE tadir-devclass.
  DATA: l_prog TYPE progname.
  REFRESH: bdcdata, bdcmsg.

  l_prog = 'YMR'.
  PERFORM bdc_dynpro      USING 'SAPLWBABAP' '0100'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=STRT'.
  PERFORM bdc_field       USING 'RS38M-PROGRAMM'      l_prog.

  PERFORM bdc_dynpro      USING l_prog '0300'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '/ECBAC'.

  PERFORM bdc_dynpro      USING l_prog '1000'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=FC03'.
  PERFORM bdc_field       USING 'S_PAQ-LOW'           i_paq.
  PERFORM bdc_field       USING 'P_TICKET'            ''.
  PERFORM bdc_field       USING 'S_TRKORR-LOW'        ''.

  PERFORM bdc_dynpro      USING 'SAPLSPO1' '0500'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=OPT1'.

  PERFORM bdc_dynpro      USING l_prog '1000'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '/EE'.

  PERFORM bdc_dynpro      USING 'SAPLWBABAP' '0100'.
  PERFORM bdc_field       USING 'BDC_OKCODE'          '=BACK'.

  CALL TRANSACTION 'SE38' USING  bdcdata MODE 'N' UPDATE 'S' MESSAGES INTO bdcmsg.

ENDFORM.                    "upd_srcsystem

*----------------------------------------------------------------------*
* Liberar ot
*----------------------------------------------------------------------*
FORM liberar_ot USING i_trkorr TYPE e070-trkorr.

  DATA: lt_e070  TYPE TABLE OF e070,
        ls_e070  LIKE LINE OF lt_e070,
        lt_doktl TYPE TABLE OF doktl.

  SELECT * INTO TABLE lt_e070 FROM e070 WHERE strkorr = i_trkorr AND trstatus = 'D'.
  SELECT * APPENDING TABLE lt_e070 FROM e070 WHERE trkorr = i_trkorr AND trstatus = 'D'.
  SELECT * INTO TABLE lt_doktl FROM doktl WHERE id = 'TA' AND object = i_trkorr AND langu = sy-langu AND typ = 'T' AND dokversion = '1'.

  IF lt_doktl IS INITIAL.
    PERFORM _isconfirmall USING 'Ot no tiene descripcion, desea continuar'.
    IF sy-subrc = 2.
      STOP.
    ELSEIF sy-subrc <> 0.
      sy-subrc = 1.
      EXIT.
    ENDIF.
  ENDIF.

  LOOP AT lt_e070 INTO ls_e070.
    CALL FUNCTION 'TR_RELEASE_REQUEST'
      EXPORTING
        iv_trkorr                  = ls_e070-trkorr
        iv_dialog                  = 'X'
        iv_success_message         = ''
        iv_display_export_log      = ''
      EXCEPTIONS
        cts_initialization_failure = 1
        enqueue_failed             = 2
        no_authorization           = 3
        invalid_request            = 4
        request_already_released   = 5
        repeat_too_early           = 6
        error_in_export_methods    = 7
        object_check_error         = 8
        docu_missing               = 9
        db_access_error            = 10
        action_aborted_by_user     = 11
        export_failed              = 12
        OTHERS                     = 13.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDLOOP.
  IF lt_e070 IS NOT INITIAL.
    DO.
      WAIT UP TO 1 SECONDS.
      SELECT COUNT(*) FROM e070 WHERE trkorr = i_trkorr AND trstatus = 'R'.
      IF sy-subrc = 0.
        EXIT.
        MESSAGE s000(su) WITH 'Ot liberada...'.
      ENDIF.
    ENDDO.

    PERFORM _showlog USING i_trkorr.
  ELSE.
    sy-subrc = 0.
  ENDIF.

ENDFORM.                    "pasar_a_qas

*----------------------------------------------------------------------*
* show log
*----------------------------------------------------------------------*
FORM _showlog USING i_trkorr TYPE trkorr.
  CALL FUNCTION 'TRINT_TDR_USER_COMMAND'
    EXPORTING
      iv_object  = i_trkorr
      iv_type    = 'REQU'
      iv_command = 'TAST'.
ENDFORM.                    "_showlog

*----------------------------------------------------------------------*
* enviar ot a clipboard
*----------------------------------------------------------------------*
FORM _setotclipboard.
  "Envio de ot a memoria
  DATA: lt_data TYPE TABLE OF char255,
        ls_data LIKE LINE OF lt_data.

  ls_data = p_trkorr.
  APPEND ls_data TO lt_data.
  cl_gui_frontend_services=>clipboard_export( IMPORTING data = lt_data CHANGING rc = sy-windi ).
ENDFORM.                    "_setotclipboard

*--------------------------------------------------------------------*
* Actualizar origen
*--------------------------------------------------------------------*
FORM actualizar_srcsystem USING i_trkorr TYPE e070v-trkorr.

  DATA: lt_e071  TYPE TABLE OF e071,
        lt_tadir TYPE TABLE OF tadir,
        ls_tadir LIKE LINE OF lt_tadir.
  DATA lv_trobj_name TYPE trobj_name.
  FIELD-SYMBOLS: <fs_e071> LIKE LINE OF lt_e071.

  SELECT * INTO TABLE lt_e071 FROM e071 WHERE trkorr = i_trkorr.
  IF lt_e071 IS NOT INITIAL.
    LOOP AT lt_e071 ASSIGNING <fs_e071>.
      IF <fs_e071>-object = 'LIMU'.
        CALL FUNCTION 'GET_R3TR_OBJECT_FROM_LIMU_OBJ'
          EXPORTING
            p_limu_objtype = <fs_e071>-object
            p_limu_objname = <fs_e071>-obj_name
          IMPORTING
            p_r3tr_objtype = <fs_e071>-object
            p_r3tr_objname = lv_trobj_name
          EXCEPTIONS
            no_mapping     = 1
            OTHERS         = 2.

        <fs_e071>-obj_name = lv_trobj_name.
      ENDIF.
    ENDLOOP.

    SELECT * INTO TABLE lt_tadir FROM tadir FOR ALL ENTRIES IN lt_e071 WHERE pgmid = lt_e071-pgmid AND object = lt_e071-object AND obj_name = lt_e071-obj_name(40).
    SORT lt_tadir BY devclass.
    DELETE ADJACENT DUPLICATES FROM lt_tadir COMPARING devclass.

    LOOP AT lt_tadir INTO ls_tadir.
      PERFORM upd_srcsystem USING ls_tadir-devclass.
    ENDLOOP.

    MESSAGE 'Update de srcsystem' TYPE 'S'.
  ENDIF.

ENDFORM.                    "actualizar_srcsystem

*----------------------------------------------------------------------*
* dynpro
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  DATA: ls_bdcdata LIKE LINE OF bdcdata.
  ls_bdcdata-program  = program.
  ls_bdcdata-dynpro   = dynpro.
  ls_bdcdata-dynbegin = 'X'.
  APPEND ls_bdcdata TO bdcdata.
ENDFORM.                    "bdc_dynpro

*----------------------------------------------------------------------*
* field
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  DATA: ls_bdcdata LIKE LINE OF bdcdata.
  IF fval <> ''.
    ls_bdcdata-fnam = fnam.
    ls_bdcdata-fval = fval.
    APPEND ls_bdcdata TO bdcdata.
  ENDIF.
ENDFORM.                    "bdc_field

*--------------------------------------------------------------------*
* Ejecutar f8
*--------------------------------------------------------------------*
FORM _executef8.
  CALL FUNCTION 'SAPGUI_SET_FUNCTIONCODE'
    EXPORTING
      functioncode           = '=ONLI'
    EXCEPTIONS
      function_not_supported = 1
      OTHERS                 = 2.
ENDFORM.                    "_executef8

*----------------------------------------------------------------------*
* Confirmar
*----------------------------------------------------------------------*
FORM _isconfirmall USING i_question TYPE string.
  PERFORM _isconfirmsel USING i_question abap_on.
ENDFORM.                    "_get_confirm

*----------------------------------------------------------------------*
* Confirmar
*----------------------------------------------------------------------*
FORM _isconfirmsel USING i_question TYPE string
                         i_cancel TYPE xfeld.
  DATA: l_answer TYPE char01.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      titlebar              = 'Confirmación'
      text_question         = i_question
      display_cancel_button = i_cancel
    IMPORTING
      answer                = l_answer
    EXCEPTIONS
      text_not_found        = 1
      OTHERS                = 2.

  IF l_answer = 'A'.
    MESSAGE 'Acción cancelada...' TYPE 'S' DISPLAY LIKE 'E'.
    sy-subrc = 2.
  ELSEIF l_answer <> '1'.
    MESSAGE 'Acción cancelada...' TYPE 'S' DISPLAY LIKE 'E'.
    sy-subrc = 1.
  ENDIF.
ENDFORM.                    "_get_confirm