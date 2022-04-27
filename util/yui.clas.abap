class YUI definition
  public
  create public .

public section.

  types:
    BEGIN OF gtty_mail_attach,
        titulo     TYPE so_obj_des,
        tipo       TYPE so_obj_tp,
        attach     TYPE bcsy_text,
        attach_hex TYPE solix_tab,
      END OF gtty_mail_attach .
  types:
    BEGIN OF gtty_mail_cab,
        subject     TYPE so_obj_des,
        sender      TYPE uname,
        sender_mail TYPE ad_smtpadr,
        inmediato   TYPE xfeld,
      END OF gtty_mail_cab .
  types:
    BEGIN OF gtty_mail_desti,
        uname   TYPE uname,
        name    TYPE name_text,
        email   TYPE ad_smtpadr,
        unamedb TYPE uname,
        urgent  TYPE boolean,
        copia   TYPE boolean,
        cco     TYPE boolean,
      END OF gtty_mail_desti .
  types:
    BEGIN OF gtty_mail_so10,
        name  TYPE dstring,
        tline TYPE tline_t,
        text  TYPE dstring,
      END OF gtty_mail_so10 .
  types:
    BEGIN OF gtty_mail_data,
        so10_asunto  TYPE gtty_mail_so10,
        so10_cuerpo1 TYPE gtty_mail_so10,
        so10_cuerpo2 TYPE gtty_mail_so10,
        so10_cuerpo3 TYPE gtty_mail_so10,
        cab          TYPE gtty_mail_cab,
        desti        TYPE TABLE OF gtty_mail_desti WITH DEFAULT KEY,
        cuerpo       TYPE bcsy_text,
        attach       TYPE TABLE OF gtty_mail_attach WITH DEFAULT KEY,
      END OF gtty_mail_data .
  types:
    gtt_mail_attach TYPE TABLE OF gtty_mail_attach WITH DEFAULT KEY .
  types:
    gtt_mail_desti  TYPE TABLE OF gtty_mail_desti WITH DEFAULT KEY .

  constants GC_GRAY type CHAR4 value '@EB@' ##NO_TEXT.
  constants GC_GREEN type CHAR4 value '@08@' ##NO_TEXT.
  constants GC_RED type CHAR4 value '@0A@' ##NO_TEXT.
  constants GC_YELLOW type CHAR4 value '@09@' ##NO_TEXT.
  data GS_MAIL type GTTY_MAIL_DATA .
  data GT_BATCH type BDCDATA_TAB .
  data GT_BATCHRET type BAPIRET2_TAB .

  methods ALVFAST_SHOW
    changing
      !CT_TABLE type STANDARD TABLE
      !CT_FCAT type LVC_T_FCAT .
  methods ALVGRID_SHOW .
  methods ALVLVC_EXCLUDEST
    changing
      !CT_EXCL type SLIS_T_EXTAB .
  methods ALVLVC_REFRESH
    changing
      !CS_SEL type SLIS_SELFIELD .
  methods ALVLVC_SETTOP
    importing
      !I_TYP type STRING
      !I_KEY type STRING
      !I_INFO type ANY
    changing
      !CT_HEAD type SLIS_T_LISTHEADER .
  methods ALVLVC_SHOW
    changing
      !CT_TABLE type STANDARD TABLE .
  methods ALVSALV_SHOW
    changing
      !CT_FCAT type LVC_T_FCAT
      !CT_TABLE type STANDARD TABLE .
  methods ALV_COLOR
    importing
      !I_CAMPO type CLIKE
      !I_COLOR type I default 3
    returning
      value(RT_CELL) type LVC_T_SCOL .
  methods ALV_FCATGEN
    exporting
      !ET_FCAT type LVC_T_FCAT
    changing
      !CT_TABLE type STANDARD TABLE
      !C_CAMPO type CLIKE optional .
  methods ALV_FCATNAME
    importing
      !I_UNICO type CLIKE
      !I_LARGE type CLIKE optional
    changing
      !CS_FCAT type LVC_S_FCAT .
  methods ALV_STYLE
    importing
      !I_CAMPO type CLIKE optional
      !I_STYLE type LVC_STYLE default CL_GUI_ALV_GRID=>MC_STYLE_DISABLED
    changing
      !CT_CELL type LVC_T_STYL .
  methods AMP_ME21N
    importing
      !IO_ITEM type ref to IF_PURCHASE_ORDER_ITEM_MM .
  methods BAPI_DATAX .
  methods BAPI_SAVE
    importing
      !IT_RETURN type BAPIRETTAB
      !I_NUMBER type I optional
    exporting
      !E_ICON type ICON-ID
      !E_MESSAGE type STRING
    changing
      !CT_RETURN type BAPIRETTAB optional
    exceptions
      ERROR .
  methods BATCH_CALL
    importing
      !I_TCODE type CLIKE
      !IS_PARAM type CTU_PARAMS optional
      !I_NUMBER type I optional
    exporting
      !E_ICON type ICON-ID
      !E_MESSAGE type STRING
    changing
      !CT_RETURN type BAPIRETTAB optional
    exceptions
      ERROR .
  methods BATCH_DYNPRO
    importing
      !I_PROGRAM type CLIKE
      !I_DYNPRO type CLIKE
      !I_KEY type CLIKE optional .
  methods BATCH_FIELD
    importing
      !I_FIELD type CLIKE
      !I_INDEX type ANY optional
      !I_VALUE type ANY .
  methods BATCH_RUTINA .
  methods CONST_RANGE_SET
    importing
      !IS_CONST type ANY
    changing
      !CR_RANGE type STANDARD TABLE .
  methods CONVERT_CURRENCY
    importing
      !I_DATE type DATS
      !I_WAERS_IN type WAERS
      !I_MONTO_IN type DMBTR
      !I_WAERS_OU type WAERS
    exporting
      !E_MONTO_OU type DMBTR .
  methods CONVERT_TO_STRING
    importing
      !IN type ANY
    returning
      value(OUT) type STRING .
  methods CURSOR_PARALLEL .
  methods CURSOR_SELECT .
  methods DATE_FROMCHAR
    importing
      !I_FECHA type CLIKE
    changing
      !E_DATUM type DATUM .
  methods DATE_INTERVAL
    importing
      !I_DATUM type SY-DATUM
      !I_DAY type NUMC2 optional
      !I_MONTH type NUMC2 optional
      !I_SIGN type CHAR01 default '+'
      !I_YEAR type NUMC2 optional
    returning
      value(E_DATUM) type SY-DATUM .
  methods DATE_STARTEND
    importing
      !I_DATE type DATUM
    changing
      !E_FECINI type DATUM optional
      !E_FECFIN type DATUM optional .
  methods DYNAMIC_SELECT .
  methods DYNPRO .
  methods DYNPRO_FORZAR_PBO .
  methods DYNPRO_HELP .
  methods EXCEL_UPLOAD .
  methods EXCEL_UPLOADEASY
    importing
      !I_FILENAME type CLIKE
    changing
      !RT_DATA type STANDARD TABLE .
  methods F4_FIELD .
  methods FIELD_GETDYNAMIC
    importing
      !I_FIELD type CLIKE
      !IS_LINE type ANY
    changing
      !E_OUT type ANY .
  methods FILE_BROWSER
    changing
      !C_DIR type CLIKE
    exceptions
      ERROR .
  methods FILE_EXIST
    importing
      !I_FILE type CLIKE
    changing
      !E_SUBRC type SY-SUBRC
    exceptions
      ERROR .
  methods FIND_REGEX .
  methods FOLDER_LISTFILES
    importing
      !I_DIR type CLIKE
    changing
      !ET_FILE type DB2_T_STRING .
  methods GOS_DOWNLOAD
    importing
      !I_FOLDER type STRING
      !I_OBJECT type CLIKE
      !I_OBJ_NAME type CLIKE
    exceptions
      ERROR .
  methods GUI_BROWSE
    returning
      value(R_FOLDER) type STRING
    exceptions
      ERROR .
  methods GUI_DOWNLOAD_BIN
    importing
      !I_FILE type STRING
    changing
      !CT_DATA type STANDARD TABLE
    exceptions
      ERROR .
  methods GUI_DOWNLOAD_TXT
    importing
      !I_FILE type CLIKE
      !I_SEPARATOR type XFELD
      !I_APPEND type XFELD optional
    changing
      !CT_DATA type STANDARD TABLE
    exceptions
      ERROR .
  methods GUI_UPLOAD_TXT
    importing
      !I_FILENAME type CLIKE
      !I_SEPARATOR type CLIKE
    changing
      !RT_DATA type STANDARD TABLE
    exceptions
      ERROR .
  methods HANA_RANGE .
  methods HANA_SELECT .
  methods INPUT_DATA
    importing
      !I_TITLE type CLIKE
      !I_TAB type CLIKE
      !I_FIELD type CLIKE
    exporting
      !E_VALUE type CLIKE
    exceptions
      CANCEL .
  methods ISAUTHORITHY_VKORG
    importing
      !I_VKORG type VKORG
      !I_VTWEG type VTWEG
      !I_SPART type SPART
      !I_ACTVT type CLIKE
    exceptions
      ERROR .
  methods ISAUTHORITY_AUART
    importing
      !I_AUART type AUART
    exceptions
      ERROR .
  methods ISCONFIRM
    importing
      !I_QUESTION type STRING
      !I_CANCEL type XFELD optional
    exceptions
      CANCEL .
  methods IS_HANA .
  methods IS_NUMERIC .
  methods JOB .
  methods LIST_CLASES .
  methods LIST_FUNCTIONS .
  methods LIST_PROGRAMS .
  methods MAIL_BODYFROMTLINE
    importing
      !IT_LINE type TLINE_TAB
    changing
      !CT_BODY type BCSY_TEXT .
  methods MAIL_HTMLFROMTABLE
    importing
      !I_CAMPOS type CLIKE
      !IT_DET type TABLE
      !I_COLOR type ANY optional
    changing
      !CT_BODY type BCSY_TEXT .
  methods MAIL_READCONSTEXT
    importing
      !I_FORMAT type CLIKE
      !I_PROGRAM type CLIKE
    exporting
      !ES_MAIL type GTTY_MAIL_DATA .
  methods MAIL_REPLACEVALUE
    importing
      !REPLACE type CLIKE
      !WITH type ANY
    changing
      !INTO type CLIKE .
  methods MAIL_SEND
    importing
      !IS_MAIL type GTTY_MAIL_DATA
      !I_TYPE type SO_OBJ_TP default 'RAW'
      !I_INMEDIATO type XFELD optional
      !I_COMMIT type XFELD optional
    exceptions
      ERROR .
  methods MEMORY
    importing
      !I_TIPO type CHAR01
      !I_PROCESS type CLIKE
    changing
      !C_DATA type ANY .
  methods MEMORY_BUFFER
    importing
      !I_TIPO type CHAR01
      !I_PROCESS type CLIKE
    changing
      !C_DATA type ANY .
  methods MEMORY_GET .
  methods MESSAGE_SHOW .
  methods MONTH_RANGE
    importing
      !I_DATE type DATUM
    returning
      value(R_DATE) type TRGR_DATE .
  methods READTEXT
    importing
      !I_SO10 type CLIKE optional
      !IS_THEAD type THEAD optional
    exporting
      !E_LINES type TLINE_TAB
      !E_TEXT type STRING .
  methods RETURN_FROMMESSAGE
    changing
      !CT_RETURN type BAPIRETTAB .
  methods RETURN_FROMTEXT
    importing
      !V1 type CLIKE
      !V2 type CLIKE
      !V3 type CLIKE optional
      !V4 type CLIKE optional
      !V42 type CLIKE optional
    changing
      !CT_RETURN type BAPIRETTAB .
  methods RETURN_SHOW
    importing
      !IT_RETURN type BAPIRETTAB .
  methods RETURN_SHOWMESSAGE
    importing
      !IS_RETURN type BAPIRET2 optional .
  methods SCREEN_BASIC .
  methods SCREEN_BUTTON .
  methods SCREEN_CHECKBOX .
  methods SCREEN_GETFIELD
    importing
      !I_FIELD type CLIKE
      !I_DYNNR type CLIKE
    changing
      !E_VALUE type ANY .
  methods SCREEN_LISTBOX .
  methods SCREEN_PF_STATUS .
  methods SCREEN_REQUIRED .
  methods SCREEN_TOOLBAR .
  methods SCREEN_UPDATE
    importing
      !I_FIELD type CLIKE
      !I_VALUE type CLIKE .
  methods SERVER_UPLOAD_TXT
    importing
      !I_FILENAME type STRING
    changing
      !CT_DATA type STANDARD TABLE
    exceptions
      ERROR .
  methods SMARTFORMS
    importing
      !I_FORMNAME type TDSFNAME
      !I_PREVIEW type TDPREVIEW default 'X'
      !I_TDDEST type RSPOPNAME default 'LP01'
      !IT_CAB type STANDARD TABLE
    exceptions
      ERROR .
  methods SMARTFORM_TO_PDF
    importing
      !IT_OTF type SSFCRESCL-OTFDATA
    returning
      value(RT_DATA) type SOLIX_TAB
    exceptions
      ERROR .
  methods SNRO_NEXT
    importing
      !IS_INRI type INRI
    changing
      !R_NUMBER type CLIKE
    exceptions
      ERROR .
  methods SUBMIT .
  methods TABLE_DOWNLOAD .
  methods TABLE_MODIFY .
  methods TCODE_CJ13
    importing
      !I_POSID type POSID .
  methods TCODE_FB03
    importing
      !I_BUKRS type BKPF-BUKRS
      !I_BELNR type BKPF-BELNR
      !I_GJAHR type BKPF-GJAHR .
  methods TCODE_IE03
    importing
      !I_EQUNR type EQUNR .
  methods TCODE_MB03
    importing
      !I_MBLNR type MBLNR
      !I_MJAHR type MJAHR .
  methods TCODE_ME53N
    importing
      !I_BANFN type BANFN .
  methods TCODE_ME23N
    importing
      !I_EBELN type EBELN .
  methods TCODE_MIR4
    changing
      !CT_TABLE type STANDARD TABLE .
  methods TCODE_VA03
    importing
      !I_VBELN type VBAK-VBELN .
  methods TLINE_SAVE
    importing
      !IS_THEAD type THEAD
      !I_TEXTO type CLIKE
    exceptions
      ERROR .
  methods UNIT_CONVERTMATERIAL
    importing
      !I_MATNR type MATNR
      !I_MEINS_IN type MEINS
      !I_MEINS_OU type MEINS
      !I_MENGE_IN type MENGE_D
    changing
      !R_MENGE_OU type MENGE_D .
  methods VALUE_DYNAMIC_GET
    importing
      !INPUT type CLIKE
    changing
      !OUT type ANY
    exceptions
      ERROR .
  methods VIEW_CALL .
  methods VIEW_CALLCLUSTER .
  methods VIEW_CALLCONST .
  methods VL02N_DELETE .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YUI IMPLEMENTATION.


  METHOD screen_pf_status.
  ENDMETHOD.


  METHOD screen_listbox.
  ENDMETHOD.


  METHOD screen_getfield.
    DATA l_value TYPE char20.

    CALL FUNCTION 'GET_DYNP_VALUE'
      EXPORTING
        i_field      = i_field
        i_repid      = sy-repid
        i_dynnr      = i_dynnr
        i_conv_input = abap_on
      CHANGING
        o_value      = l_value.
    IF l_value CP '++.++.++++'.
      CONCATENATE l_value+6(4)
                  l_value+3(2)
                  l_value+0(2)
                  INTO e_value.
    ELSEIF l_value IS NOT INITIAL.
      e_value = l_value.
    ELSE.
      CLEAR e_value.
    ENDIF.
    "01. Screen_getfield IMPORTING 'GS_TOP101-AUDAT_L' '0101' gs_top101-audat_l.
  ENDMETHOD.


  METHOD screen_checkbox.
  ENDMETHOD.


  METHOD screen_button.
  ENDMETHOD.


  METHOD screen_basic.
*----------------------------------------------------------------------*
* SCREEN OUTPUT
*----------------------------------------------------------------------*
*AT SELECTION-SCREEN OUTPUT.
*  PERFORM 1000_output.

*----------------------------------------------------------------------*
* 1000 Output
*----------------------------------------------------------------------*
*FORM 1000_output.
    DATA: l_active TYPE i.

    "CASE abap_on.
    "  WHEN r_old. l_active = 1. "Mostrar Param.
    "  WHEN r_new. l_active = 0. "Ocultar Param.
    "ENDCASE.
    LOOP AT SCREEN.
      IF screen-group1 EQ 'B02'.
        screen-active = l_active.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
*ENDFORM.

*----------------------------------------------------------------------*
* 1000 UC
*----------------------------------------------------------------------*
*AT SELECTION-SCREEN.
*  PERFORM 1000_uc.

*FORM inicializa.
*sscrfields-functxt_01 = 'Copy with SCC1'.
*ENDFORM.
  ENDMETHOD.


  METHOD return_showmessage.
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


  METHOD return_show.
    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = it_return.
  ENDMETHOD.


  METHOD return_fromtext.
    DATA: lv2       TYPE char50,
          lv4       TYPE char50,
          l_message TYPE string.
    DATA: ls_return LIKE LINE OF ct_return.

    "Prepare
    WRITE v2 TO lv2. CONDENSE lv2.
    WRITE v42 TO lv4. CONDENSE lv4.
    CONCATENATE v42 lv4 INTO lv4 SEPARATED BY space.

    "Build
    MESSAGE e000(su) WITH v1 lv2 v3 lv4 INTO l_message.
    MOVE: sy-msgv1 TO ls_return-message_v1,
          sy-msgv2 TO ls_return-message_v2,
          sy-msgv3 TO ls_return-message_v3,
          sy-msgv4 TO ls_return-message_v4,
          sy-msgid TO ls_return-id,
          sy-msgno TO ls_return-number,
          sy-msgty TO ls_return-type,
          l_message TO ls_return-message.

    "Return
    APPEND ls_return TO ct_return.
  ENDMETHOD.


  METHOD return_frommessage.
    DATA: ls_return LIKE LINE OF ct_return.

    MOVE: sy-msgv1 TO ls_return-message_v1,
          sy-msgv2 TO ls_return-message_v2,
          sy-msgv3 TO ls_return-message_v3,
          sy-msgv4 TO ls_return-message_v4,
          sy-msgid TO ls_return-id,
          sy-msgno TO ls_return-number,
          sy-msgty TO ls_return-type.
    APPEND ls_return TO ct_return.
  ENDMETHOD.


  METHOD readtext.
    DATA: ls_thead TYPE thead.

    FIELD-SYMBOLS: <fs_lines> LIKE LINE OF e_lines.

    ls_thead = is_thead.

    IF i_so10 <> space.
      ls_thead-tdid     = 'ST'.
      ls_thead-tdobject = 'TEXT'.
      ls_thead-tdname   = i_so10.
      ls_thead-tdspras  = sy-langu.
    ENDIF.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = ls_thead-tdid
        language                = ls_thead-tdspras
        name                    = ls_thead-tdname
        object                  = ls_thead-tdobject
      TABLES
        lines                   = e_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    LOOP AT e_lines ASSIGNING <fs_lines>.
      AT FIRST.
        e_text = <fs_lines>-tdline.
        CONTINUE.
      ENDAT.
      CONCATENATE e_text <fs_lines>-tdline INTO e_text SEPARATED BY space.
    ENDLOOP.
  ENDMETHOD.                    "readtext


  METHOD month_range.
    DATA: l_ini   TYPE datum,
          l_fin   TYPE datum,
          ls_date LIKE LINE OF r_date VALUE 'IBT'.

    date_startend(
     EXPORTING
       i_date   = i_date
     CHANGING
       e_fecini = l_ini
       e_fecfin = l_fin
   ).

    ls_date-low = l_ini.
    ls_date-high = l_fin.
    APPEND ls_date TO r_date.
  ENDMETHOD.


  METHOD message_show.
    CHECK sy-msgid IS NOT INITIAL.

    IF sy-msgty = 'E'.
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    ELSE.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.


  METHOD memory_get.
  ENDMETHOD.


  METHOD memory_buffer.
    DATA: l_process TYPE indx-srtfd.
    CONCATENATE i_process sy-uname INTO l_process.
    CASE i_tipo.
      WHEN 'E' OR 1.
        DELETE FROM SHARED BUFFER indx(zz) ID l_process.
        EXPORT c_data = c_data TO SHARED BUFFER indx(zz) ID l_process.
      WHEN 'I' OR 2.
        IMPORT c_data = c_data FROM SHARED BUFFER indx(zz) ID l_process.
        DELETE FROM SHARED BUFFER indx(zz) ID l_process.
      WHEN 'Y' OR 3.
        IMPORT c_data = c_data FROM SHARED BUFFER indx(zz) ID l_process.
      WHEN 'D' OR 4.
        DELETE FROM SHARED BUFFER indx(zz) ID l_process.
        CLEAR c_data.
    ENDCASE.
  ENDMETHOD.


  METHOD memory.
    DATA: l_process TYPE indx-srtfd.
    CONCATENATE i_process sy-uname INTO l_process.
    CASE i_tipo.
      WHEN 'E' OR 1.
        FREE MEMORY ID l_process.
        EXPORT c_data = c_data TO MEMORY ID l_process.
      WHEN 'I' OR 2.
        IMPORT c_data = c_data FROM MEMORY ID l_process.
        FREE MEMORY ID l_process.
      WHEN 'Y' OR 3.
        IMPORT c_data = c_data FROM MEMORY ID l_process.
      WHEN 'D' OR 4.
        FREE MEMORY ID l_process.
        CLEAR c_data.
    ENDCASE.
  ENDMETHOD.


  METHOD mail_send.
    CLASS cl_cam_address_bcs DEFINITION LOAD.

    DATA: lo_mail   TYPE REF TO cl_bcs,
          lo_doc    TYPE REF TO cl_document_bcs,
          lo_attach TYPE REF TO cl_document_bcs,
          lo_desti  TYPE REF TO if_recipient_bcs,
          lo_remi   TYPE REF TO cl_sapuser_bcs,
          lo_remi_e TYPE REF TO cl_cam_address_bcs,
          lo_exc    TYPE REF TO cx_bcs,
          l_message TYPE string.

    DATA: lt_desti  TYPE gtt_mail_desti,
          lt_desti2 TYPE gtt_mail_desti.
    DATA: ls_desti       TYPE gtty_mail_desti,
          ls_attach      TYPE gtty_mail_attach,
          l_address_name TYPE adr6-smtp_addr,
          l_desti        TYPE xfeld.

    FIELD-SYMBOLS: <fs_desti> LIKE LINE OF lt_desti.

    "Validaciones
    IF is_mail-desti IS INITIAL.
      MESSAGE 'No hay destinarios' TYPE 'E' RAISING error.
    ENDIF.


    "Build y Envio de Mail
    TRY.
        "1. Instancia
        lo_mail = cl_bcs=>create_persistent( ).

        "1.0 Remitente
        "Otro usuario
        IF is_mail-cab-sender <> space.
          lo_remi = cl_sapuser_bcs=>create( is_mail-cab-sender ).
          lo_mail->set_sender( lo_remi ).
        ENDIF.

        "Otro email
        IF is_mail-cab-sender_mail <> space.
          lo_remi_e = cl_cam_address_bcs=>create_internet_address( is_mail-cab-sender_mail ).
          lo_mail->set_sender( lo_remi_e ).
        ENDIF.

        "1.1 Adjunta titulo de correo y cuerpo
        lo_doc = cl_document_bcs=>create_document( i_type    = i_type                 "RAW, HTM
                                                   i_text    = is_mail-cuerpo         "Mensaje
                                                   i_subject = is_mail-cab-subject ). "Titulo

        "1.2 Adjunta archivos
        LOOP AT is_mail-attach INTO ls_attach.
          "Adjunto tipo1
          IF ls_attach-attach IS NOT INITIAL.
            lo_attach = cl_document_bcs=>create_document( i_type    = ls_attach-tipo
                                                          i_text    = ls_attach-attach
                                                          i_subject = ls_attach-titulo ).
            "Adjunto tipo2
          ELSEIF ls_attach-attach_hex IS NOT INITIAL.
            lo_attach = cl_document_bcs=>create_document( i_type    = ls_attach-tipo
                                                          i_hex     = ls_attach-attach_hex
                                                          i_subject = ls_attach-titulo ).
          ENDIF.
          lo_doc->add_document_as_attachment( lo_attach ).
        ENDLOOP.


        "1.3 Adjunta al objeto principal
        lo_mail->set_document( lo_doc ).


        "2. Adjunta destinatarios
        lt_desti = is_mail-desti.
        LOOP AT lt_desti INTO ls_desti.

          "2.1. Direccion de email
          IF ls_desti-email IS NOT INITIAL.
            l_address_name = ls_desti-name.
            lo_desti = cl_cam_address_bcs=>create_internet_address(
               i_address_string = ls_desti-email
               i_address_name   = l_address_name
            ).

            "2.2. Usuario sap obtener mail por clase
          ELSEIF ls_desti-uname IS NOT INITIAL.
            TRY.
                lo_desti = cl_sapuser_bcs=>create( ls_desti-uname ).
              CATCH cx_address_bcs.
            ENDTRY.

            "2.3. Usuario sap obtener mail por select
          ELSEIF ls_desti-unamedb IS NOT INITIAL.
            FREE lt_desti2.

            SELECT a~bname AS uname c~name_text AS name b~smtp_addr AS email
              INTO TABLE lt_desti2
              FROM usr21 AS a INNER JOIN adr6 AS b ON b~addrnumber = a~addrnumber
                                                   AND b~persnumber = a~persnumber
                              INNER JOIN adrp AS c ON c~persnumber = a~persnumber
              WHERE a~bname = ls_desti-unamedb
                AND b~flg_nouse = space.

            SORT lt_desti2 BY uname email.
            DELETE ADJACENT DUPLICATES FROM lt_desti2 COMPARING uname email.

            "Heradar datos de envio
            LOOP AT lt_desti2 ASSIGNING <fs_desti>.
              <fs_desti>-urgent = ls_desti-urgent.
              <fs_desti>-copia = ls_desti-copia.
              <fs_desti>-cco = ls_desti-cco.
            ENDLOOP.

            APPEND LINES OF lt_desti2 TO lt_desti.
            CONTINUE.
          ENDIF.

          IF lo_desti IS BOUND.
            l_desti = abap_on.
            lo_mail->add_recipient( i_recipient = lo_desti
                                    i_express   = ls_desti-urgent
                                    i_copy      = ls_desti-copia
                                    i_blind_copy = ls_desti-cco ).
            FREE lo_desti.
          ENDIF.
        ENDLOOP.
        IF l_desti IS INITIAL.
          MESSAGE 'No hay destinarios' TYPE 'E' RAISING error.
        ENDIF.


        "3. Envio de mail
        lo_mail->send_request->set_link_to_outbox( 'X' ).
        lo_mail->send( ).

        "Commit Work
        IF i_commit <> space.
          COMMIT WORK.
        ENDIF.

        "Forzar envio inmediato
        IF i_inmediato <> space.
          SUBMIT rsconn01 WITH mode = 'INT' AND RETURN.
        ENDIF.

        "Manejo de excepcion
      CATCH cx_bcs INTO lo_exc.
        l_message = lo_exc->get_text( ).
        MESSAGE l_message TYPE 'E' RAISING error.
    ENDTRY.
  ENDMETHOD.                    "mail_send


  METHOD mail_replacevalue.
    DATA: l_char   TYPE char30,
          l_string TYPE string,
          l_type   TYPE char01,
          l_len    TYPE i.

    IF into CS replace.
      DESCRIBE FIELD with TYPE l_type.
      DESCRIBE FIELD with LENGTH l_len IN CHARACTER MODE.

      "Convertir
      IF l_type = 'D'.
        WRITE with TO l_char USING EDIT MASK '__/__/____'.
        l_string = l_char.
      ELSEIF l_len <= 30.
        WRITE with TO l_char.
        CONDENSE l_char.
        l_string = l_char.
      ELSE.
        l_string = with.
      ENDIF.

      REPLACE replace WITH l_string INTO into.
    ENDIF.
  ENDMETHOD.                    "mail_replacevalue


  METHOD mail_readconstext.
    TYPES: BEGIN OF ty_const,
             secue TYPE string,
             name  TYPE string,
             texto TYPE string,
           END OF ty_const.
    DATA: lt_const TYPE TABLE OF ty_const,
          ls_const LIKE LINE OF lt_const.

    "1. Textos so10
    SELECT * INTO CORRESPONDING FIELDS OF TABLE lt_const
      FROM ('ZOSTB_TEXTCONST')
      WHERE aplic = i_format
        AND formn = i_program.

    LOOP AT lt_const INTO ls_const.
      CASE ls_const-secue.
        WHEN 1. es_mail-so10_asunto-name = ls_const-texto.
        WHEN 2. es_mail-so10_cuerpo1-name = ls_const-texto.
        WHEN 3. es_mail-so10_cuerpo2-name = ls_const-texto.
        WHEN 4. es_mail-so10_cuerpo3-name = ls_const-texto.
      ENDCASE.
    ENDLOOP.

    "Read textos
    readtext( EXPORTING i_so10 = es_mail-so10_asunto-name IMPORTING e_text = es_mail-so10_asunto-text ).
    readtext( EXPORTING i_so10 = es_mail-so10_cuerpo1-name IMPORTING e_lines = es_mail-so10_cuerpo1-tline ).
    readtext( EXPORTING i_so10 = es_mail-so10_cuerpo2-name IMPORTING e_lines = es_mail-so10_cuerpo2-tline ).
    readtext( EXPORTING i_so10 = es_mail-so10_cuerpo3-name IMPORTING e_lines = es_mail-so10_cuerpo3-tline ).
  ENDMETHOD.                    "mail_readconstext


  METHOD mail_htmlfromtable.
    "Detalle
    DATA: ld_det   TYPE REF TO data,
          lt_campo TYPE TABLE OF string,
          ls_campo LIKE LINE OF lt_campo,
          l_char   TYPE char255.

    DATA: ls_body   TYPE soli.

    "Lectura dinamica
    DATA: lo_ref          TYPE REF TO cl_abap_structdescr,
          lt_comp         TYPE abap_component_tab,
          ls_comp         LIKE LINE OF lt_comp,
          lo_elem         TYPE REF TO  cl_abap_elemdescr,
          l_function_conv TYPE string.

    FIELD-SYMBOLS: <fs_det> TYPE any,
                   <fs>     TYPE any.


    "Obtener campos de la tabla input
    CREATE DATA ld_det LIKE LINE OF it_det.
    ASSIGN ld_det->* TO <fs_det>.
    lo_ref ?= cl_abap_structdescr=>describe_by_data( <fs_det> ).
    lt_comp = lo_ref->get_components( ).

    "Si contiene estructuras incluidas
    LOOP AT lt_comp INTO ls_comp WHERE as_include = abap_on.
      lo_ref ?= ls_comp-type.
      APPEND LINES OF lo_ref->get_components( ) TO lt_comp.
    ENDLOOP.


    "Campos a devolver en html
    SPLIT i_campos AT space INTO TABLE lt_campo.

    "Armar tabla html
    LOOP AT it_det ASSIGNING <fs_det>.

      "Abrir fila
      APPEND '<tr>' TO ct_body.

      "Campos de la columna
      LOOP AT lt_campo INTO ls_campo.
        CLEAR ls_body.

        "Leer valor
        ASSIGN COMPONENT ls_campo OF STRUCTURE <fs_det> TO <fs>.
        IF sy-subrc = 0.
          "Determinar tipo de dato
          READ TABLE lt_comp INTO ls_comp WITH KEY name = ls_campo.
          IF sy-subrc = 0.
            lo_elem ?= ls_comp-type.
            IF lo_elem->edit_mask IS NOT INITIAL.
              "Conversion
              CONCATENATE 'CONVERSION_EXIT_'  lo_elem->edit_mask '_OUTPUT' INTO l_function_conv.
              REPLACE '==' IN l_function_conv WITH ''.

              CALL FUNCTION l_function_conv
                EXPORTING
                  input  = <fs>
                IMPORTING
                  output = l_char.
            ELSE.
              CASE ls_comp-type->type_kind.
                  "Montos a la derecha
                WHEN 'P'.
                  WRITE <fs> TO l_char. CONDENSE l_char.
                  CONCATENATE '<div align="right">' l_char '</div>' INTO l_char.

                  "Fechas
                WHEN 'D'.
                  WRITE <fs> TO l_char USING EDIT MASK '__/__/____'.
                  "Numero
                WHEN 'N'.
                  IF <fs> IS NOT INITIAL.
                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                      EXPORTING
                        input  = <fs>
                      IMPORTING
                        output = l_char.
                  ENDIF.
                  "Char
                WHEN OTHERS. l_char = <fs>.
              ENDCASE.
            ENDIF.
          ENDIF.
        ENDIF.

        "Agregar columna
        IF i_color IS NOT INITIAL.
          CONCATENATE i_color l_char '</span>' INTO l_char.
        ENDIF.

        CONCATENATE '<td>' l_char '</td>' INTO ls_body.
        CLEAR l_char.

        APPEND ls_body TO ct_body.
      ENDLOOP.

      "Cerrar fila
      APPEND '</tr>' TO ct_body.
    ENDLOOP.

    IF i_color IS NOT INITIAL.
      APPEND '</div>' TO ct_body.
    ENDIF.
  ENDMETHOD.                    "mail_htmlfromtable


  METHOD mail_bodyfromtline.
    DATA: ls_line TYPE tline.

    LOOP AT it_line INTO ls_line.
      APPEND ls_line-tdline TO ct_body.
    ENDLOOP.
  ENDMETHOD.                    "mail_bodyfromtline


  METHOD list_programs.
  ENDMETHOD.


  METHOD list_functions.
  ENDMETHOD.


  METHOD list_clases.
  ENDMETHOD.


  METHOD job.
  ENDMETHOD.


  METHOD vl02n_delete.
  ENDMETHOD.


  METHOD view_callconst.
  ENDMETHOD.


  METHOD view_callcluster.
  ENDMETHOD.


  METHOD view_call.
  ENDMETHOD.


  METHOD value_dynamic_get.
    DATA: l_type TYPE char10,
          l_mask TYPE string.

    DESCRIBE FIELD out TYPE l_type EDIT MASK l_mask.
    IF l_mask IS NOT INITIAL.
      REPLACE '==' IN l_mask WITH ''.
      CONCATENATE 'CONVERSION_EXIT_'  l_mask '_INPUT' INTO l_mask.

      CALL FUNCTION l_mask
        EXPORTING
          input  = input
        IMPORTING
          output = out
        EXCEPTIONS
          OTHERS = 1.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
      ENDIF.
    ELSE.
      CASE l_type.
        WHEN 'N' OR 'P' OR 'I'.
          TRY .
              out = input.
            CATCH cx_sy_conversion_no_number.
          ENDTRY.
        WHEN 'D'. CONCATENATE input+6(4) input+3(2) input+0(2) INTO out.
        WHEN 'C'. out = input.
        WHEN OTHERS. out = input.
      ENDCASE.
    ENDIF.
  ENDMETHOD.                    "setvalue


  METHOD unit_convertmaterial.
    CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
      EXPORTING
        i_matnr              = i_matnr
        i_in_me              = i_meins_in
        i_out_me             = i_meins_ou
        i_menge              = 1
      IMPORTING
        e_menge              = r_menge_ou
      EXCEPTIONS
        error_in_application = 1
        error                = 2
        OTHERS               = 3.


    r_menge_ou = i_menge_in * r_menge_ou.
  ENDMETHOD.


  METHOD tline_save.
    DATA:lt_tline TYPE TABLE OF tline,
         ls_tline LIKE LINE OF lt_tline.

    ls_tline-tdformat = '*'.
    ls_tline-tdline   = i_texto.
    APPEND ls_tline TO lt_tline.

    CALL FUNCTION 'SAVE_TEXT'
      EXPORTING
        header          = is_thead
        savemode_direct = 'X'
      TABLES
        lines           = lt_tline
      EXCEPTIONS
        id              = 1
        language        = 2
        name            = 3
        object          = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD tcode_va03.
    SET PARAMETER ID 'AUN'  FIELD i_vbeln.
    CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
  ENDMETHOD.


  METHOD tcode_mir4.
    DATA: lo_alv       TYPE REF TO cl_salv_table,
          lo_functions TYPE REF TO cl_salv_functions_list,
          lo_columns   TYPE REF TO cl_salv_columns_table,
          lo_root      TYPE REF TO cx_root.

    CHECK ct_table IS NOT INITIAL.

    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = lo_alv
                                CHANGING t_table       = ct_table ).

        lo_functions = lo_alv->get_functions( ).
        lo_functions->set_default( abap_on ).
        lo_columns = lo_alv->get_columns( ).
        lo_columns->set_optimize( abap_on ).
        lo_alv->display( ).
      CATCH cx_salv_msg INTO lo_root.

    ENDTRY.
  ENDMETHOD.


  METHOD TCODE_ME53N.
    SET PARAMETER ID: 'BAN' FIELD i_banfn.
    CALL TRANSACTION 'ME53N' AND SKIP FIRST SCREEN.
  ENDMETHOD.


  METHOD tcode_me23n.
    SET PARAMETER ID: 'BES' FIELD i_ebeln.
    CALL TRANSACTION 'ME23N' AND SKIP FIRST SCREEN.
  ENDMETHOD.


  METHOD tcode_mb03.
    SET PARAMETER ID: 'MBN' FIELD i_mblnr,
                      'MJA' FIELD i_mjahr.
    CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.
  ENDMETHOD.


  METHOD tcode_ie03.
    SET PARAMETER ID: 'EQN' FIELD i_equnr.
    CALL TRANSACTION 'IE03' AND SKIP FIRST SCREEN.
  ENDMETHOD.


  METHOD tcode_fb03.
    SET PARAMETER ID: 'BLN' FIELD i_belnr,
                      'BUK' FIELD i_bukrs,
                      'GJR' FIELD i_gjahr.
    CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
  ENDMETHOD.


  METHOD tcode_cj13.
    SET PARAMETER ID: 'PRO' FIELD i_posid.
    CALL TRANSACTION 'CJ13' AND SKIP FIRST SCREEN.
  ENDMETHOD.


  METHOD table_modify.
  ENDMETHOD.


  METHOD table_download.
  ENDMETHOD.


  METHOD submit.
  ENDMETHOD.


  METHOD snro_next.
**----------------------------------------------------------------------*
** Proceso
**  1. Bloquea el rango
**  2. Obtiene el numero siguiente
**  3. Libera el rango
**----------------------------------------------------------------------*
** Ayuda
**  ls_inri-object    = 'ZSD_SHIP'.  "Nombre
**  ls_inri-nrrangenr = '01'.        "Posicion
**  ls_inri-subobject = ''.          "Opcional
**  ls_inri-toyear    = '2015'.      "Como Doc. FI
**  l_nro = go_util->get_next_snro( is_inri = ls_inri ).
**----------------------------------------------------------------------*
    CALL FUNCTION 'NUMBER_RANGE_ENQUEUE'
      EXPORTING
        object           = is_inri-object
      EXCEPTIONS
        foreign_lock     = 1
        object_not_found = 2
        system_failure   = 3
        OTHERS           = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = is_inri-nrrangenr     "N° Rango
        object                  = is_inri-object        "
        subobject               = is_inri-subobject     "
        toyear                  = is_inri-toyear        "Año opcional
      IMPORTING
        number                  = r_number
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.

    CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
      EXPORTING
        object           = is_inri-object
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD smartform_to_pdf.
**----------------------------------------------------------------------*
*** EXAMPLE
**    DATA: l_fn_name TYPE rs38l_fnam,
**          ls_control  TYPE ssfctrlop,
**          ls_options  TYPE ssfcompop,
**          ls_return   TYPE ssfcrescl.
**
*** 1. Obtiene OTF de formulario
**    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
**      EXPORTING
**        formname           = p_fname         "'ZOSFISF_SEND_DEU_CLI_V'
**      IMPORTING
**        fm_name            = l_fn_name
**      EXCEPTIONS
**        no_form            = 1
**        no_function_module = 2
**        OTHERS             = 3.
**
*** Parametro de impresion
**    ls_control-getotf    = abap_on.
**    ls_control-no_dialog = abap_on.
**
*** Opcion para control spool
**    ls_options-tddest    = 'LP01'.       "Constante
**    ls_options-tdnoprev  = abap_on.
**    ls_options-tdnewid   = abap_on.
**
**    CALL FUNCTION l_fn_name
**      EXPORTING
**        control_parameters = ls_control
**        output_options     = ls_options
**      IMPORTING
**        job_output_info    = ls_return
**      EXCEPTIONS
**        formatting_error   = 1
**        internal_error     = 2
**        send_error         = 3
**        user_canceled      = 4
**        OTHERS             = 5.
**
***    2. convierte a pdf
**    lt_pdf = go_util->smartform_to_pdf( ls_return ).
**
**    APPEND LINES OF go_util->mail_pdffromsmartform( ls_return ) TO lt_pdf.
**----------------------------------------------------------------------*
    DATA: lt_otf  TYPE TABLE OF itcoo,
          lt_line TYPE TABLE OF tline,
          l_data  TYPE xstring.

    "1. Convierte a pdf
    lt_otf = it_otf.

    CALL FUNCTION 'CONVERT_OTF'
      EXPORTING
        format                = 'PDF'
      IMPORTING
        bin_file              = l_data
      TABLES
        otf                   = lt_otf
        lines                 = lt_line
      EXCEPTIONS
        err_max_linewidth     = 1
        err_format            = 2
        err_conv_not_possible = 3
        OTHERS                = 4.
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "2. Retornar
    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = l_data
      TABLES
        binary_tab = rt_data.

  ENDMETHOD.                    "mail_pdffromsmartform


  METHOD smartforms.
    DATA: ls_control_param TYPE ssfctrlop,
          ls_output_param  TYPE ssfcompop,
          l_fn_name        TYPE rs38l_fnam.
    FIELD-SYMBOLS: <fs_cab> TYPE any.

    "1. Creacion de la funcion
    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = i_formname
      IMPORTING
        fm_name            = l_fn_name
      EXCEPTIONS
        no_method          = 1
        no_function_module = 2
        OTHERS             = 3.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.

    "2. Abrir
    "Parametro de impresion
    ls_control_param-preview  = i_preview.    "Mostrar preview
    ls_control_param-no_open  = 'X'.          "Abrir
    ls_control_param-no_close = 'X'.          "No cerrar
**    ls_control_param-no_dialog = i_no_dialog. "No ventana impresora

    "Opcion para control SPOOL
    ls_output_param-tdimmed   = abap_on.      "Salida inmediata
    ls_output_param-tdnewid   = abap_on.      "Nueva orden spool
    ls_output_param-tddest    = i_tddest.     "Impresora setteado en constantes LP01
**    ls_output_param-tdtitle   = ''.           "Titulo ventana impresora
**    ls_output_param-tddelete  = abap_on.      "Borrado inmediato
**    ls_output_param-tdcovtitle = ''.          "Titulo de spool
**    ls_output_param-tdnoprev  = space.        "No mostrar Formulario
**    ls_output_param-tdcopies  = 1.            "Nro copias

    CALL FUNCTION 'SSF_OPEN'
      EXPORTING
        user_settings      = space
        output_options     = ls_output_param
        control_parameters = ls_control_param
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.

    "3. Mostrar Formulario
    LOOP AT it_cab ASSIGNING <fs_cab>.
      CALL FUNCTION l_fn_name
        EXPORTING
          control_parameters = ls_control_param
          output_options     = ls_output_param
          user_settings      = space
          is_cab             = <fs_cab>
**          it_det             = it_det
        EXCEPTIONS
          methodatting_error = 1
          internal_error     = 2
          send_error         = 3
          user_canceled      = 4
          OTHERS             = 5.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
      ENDIF.
    ENDLOOP.

    "4. Cerrar
    CALL FUNCTION 'SSF_CLOSE'
      EXCEPTIONS
        methodatting_error = 1
        internal_error     = 2
        send_error         = 3
        OTHERS             = 4.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD server_upload_txt.
    DATA: l_message TYPE text100.
    DATA: lo_data   TYPE REF TO data.
    FIELD-SYMBOLS: <fs_data> TYPE any.

    CREATE DATA lo_data LIKE LINE OF ct_data.
    ASSIGN lo_data->* TO <fs_data>.

    OPEN DATASET i_filename FOR INPUT IN TEXT MODE ENCODING NON-UNICODE
                        IGNORING CONVERSION ERRORS
                        MESSAGE l_message.
    IF sy-subrc = 0.
      DO.
        READ DATASET i_filename INTO <fs_data>.
        CASE sy-subrc.
          WHEN '0'.
            APPEND <fs_data> TO ct_data.
          WHEN '4'.
            EXIT.
          WHEN '8'.
            MESSAGE e000(su) WITH 'Error en lectura de archivo' RAISING error.
        ENDCASE.
      ENDDO.
    ELSE.
      MESSAGE s000(su) WITH l_message RAISING error.
    ENDIF.

    CLOSE DATASET i_filename.
  ENDMETHOD.


  METHOD screen_update.
    DATA: lt_dynp TYPE TABLE OF dynpread,
          ls_dynp TYPE dynpread.

    ls_dynp-fieldname = i_field.
    ls_dynp-fieldvalue = i_value.
    APPEND ls_dynp TO lt_dynp.

    CALL FUNCTION 'DYNP_VALUES_UPDATE'
      EXPORTING
        dyname               = sy-repid
        dynumb               = sy-dynnr
      TABLES
        dynpfields           = lt_dynp
      EXCEPTIONS
        invalid_abapworkarea = 1
        invalid_dynprofield  = 2
        invalid_dynproname   = 3
        invalid_dynpronummer = 4
        invalid_request      = 5
        no_fielddescription  = 6
        undefind_error       = 7
        OTHERS               = 8.
  ENDMETHOD.


  METHOD screen_toolbar.
  ENDMETHOD.


  METHOD screen_required.
  ENDMETHOD.


  METHOD is_numeric.
  ENDMETHOD.


  METHOD date_interval.
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = i_datum
        days      = i_day
        months    = i_month
        signum    = i_sign
        years     = i_year
      IMPORTING
        calc_date = e_datum.
  ENDMETHOD.


  METHOD date_fromchar.
    DATA: l_length TYPE i,
          l_year   TYPE gjahr,
          l_datum  TYPE datum.

    "01. Clear
    CLEAR e_datum.

    "02. Extraer y convertir
    l_length = strlen( i_fecha ).

    CASE l_length.
      WHEN 10. "formato DD/MM/AAAA
        CONCATENATE i_fecha+6(4) i_fecha+3(2) i_fecha+0(2) INTO l_datum.

      WHEN 8. "formato DD/MM/AA, DD*MM*AA
        l_year = i_fecha+6(2).
        CALL FUNCTION 'CONVERSION_EXIT_GJAHR_INPUT'
          EXPORTING
            input       = l_year
          IMPORTING
            output      = l_year
          EXCEPTIONS
            wrong_input = 1.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.
        CONCATENATE l_year i_fecha+3(2) i_fecha+0(2) INTO l_datum.

      WHEN 6. "formato DDMMAA
        l_year = i_fecha+4(2).
        CALL FUNCTION 'CONVERSION_EXIT_GJAHR_INPUT'
          EXPORTING
            input       = l_year
          IMPORTING
            output      = l_year
          EXCEPTIONS
            wrong_input = 1.
        IF sy-subrc <> 0.
          EXIT.
        ENDIF.

        CONCATENATE l_year i_fecha+2(2) i_fecha+0(2) INTO l_datum.
      WHEN OTHERS.
        "formato no considerado
    ENDCASE.

    "03. Validar
    CALL FUNCTION 'RP_CHECK_DATE'
      EXPORTING
        date         = l_datum
      EXCEPTIONS
        date_invalid = 1
        OTHERS       = 2.

    IF sy-subrc = 0.
      e_datum = l_datum.
    ENDIF.
  ENDMETHOD.


  METHOD cursor_select.
  ENDMETHOD.


  METHOD cursor_parallel.
  ENDMETHOD.


  METHOD convert_to_string.
    DATA l_char TYPE char20.

    WRITE in TO l_char.
    CONDENSE l_char.
    out = l_char.

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value = out.
  ENDMETHOD.


  METHOD convert_currency.
    IF i_waers_in <> i_waers_ou.
      CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
        EXPORTING
          date             = i_date
          foreign_currency = i_waers_in
          foreign_amount   = i_monto_in
          local_currency   = i_waers_ou
        IMPORTING
          local_amount     = e_monto_ou
        EXCEPTIONS
          no_rate_found    = 1
          overflow         = 2
          no_factors_found = 3
          no_spread_found  = 4
          derived_2_times  = 5.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ELSE.
      e_monto_ou = i_monto_in.
    ENDIF.
  ENDMETHOD.


  METHOD const_range_set.
    DATA: BEGIN OF ls_const,
            signo  TYPE string,
            opcion TYPE string,
            valor1 TYPE string,
            valor2 TYPE string,
          END OF ls_const.
    DATA: l_mask   TYPE string.
    FIELD-SYMBOLS: <line>   TYPE any,
                   <sign>   TYPE any,
                   <option> TYPE any,
                   <low>    TYPE any,
                   <high>   TYPE any.

    MOVE-CORRESPONDING is_const TO ls_const.
    APPEND INITIAL LINE TO cr_range ASSIGNING <line>.

    TRY.
        "Sign & Option
        ASSIGN COMPONENT 'SIGN' OF STRUCTURE <line> TO <sign>.
        ASSIGN COMPONENT 'OPTION' OF STRUCTURE <line> TO <option>.
        <sign> = ls_const-signo.
        <option> = ls_const-opcion.

        "Low & High
        ASSIGN COMPONENT 'LOW' OF STRUCTURE <line> TO <low>.
        ASSIGN COMPONENT 'HIGH' OF STRUCTURE <line> TO <high>.
        DESCRIBE FIELD <low> EDIT MASK l_mask.
        IF l_mask IS NOT INITIAL.
          CONCATENATE 'CONVERSION_EXIT_'  l_mask '_INPUT' INTO l_mask.
          REPLACE '==' IN l_mask WITH ''.
          CALL FUNCTION l_mask
            EXPORTING
              input  = ls_const-valor1
            IMPORTING
              output = <low>.
          CALL FUNCTION l_mask
            EXPORTING
              input  = ls_const-valor2
            IMPORTING
              output = <high>.
        ELSE.
          <low> = ls_const-valor1.
          <high> = ls_const-valor2.
        ENDIF.
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD batch_rutina.
  ENDMETHOD.


  METHOD batch_field.
    DATA: ls_batch TYPE bdcdata,
          l_field  TYPE string,
          l_index  TYPE numc2.

    l_field = i_field.
    l_index = i_index.
    IF i_index IS NOT INITIAL. REPLACE 'XX' IN l_field WITH l_index. ENDIF.
    ls_batch-fnam = l_field.
    WRITE i_value TO ls_batch-fval.
    CONDENSE ls_batch-fval.
    APPEND ls_batch  TO gt_batch.
  ENDMETHOD.


  METHOD batch_dynpro.
    DATA: ls_batch TYPE bdcdata.
    ls_batch-program = i_program.
    ls_batch-dynpro  = i_dynpro.
    ls_batch-dynbegin = abap_on.
    APPEND ls_batch  TO gt_batch.
    CLEAR ls_batch.

    IF i_key IS NOT INITIAL.
      ls_batch-fnam = 'BDC_OKCODE'.
      ls_batch-fval = i_key.
      APPEND ls_batch  TO gt_batch.
    ENDIF.
  ENDMETHOD.


  METHOD batch_call.
    DATA: lt_bdcret TYPE TABLE OF bdcmsgcoll,
          ls_param  TYPE ctu_params.

    FREE gt_batchret.

    IF is_param IS INITIAL.
      ls_param-dismode = 'N'.
      ls_param-updmode = 'S'.
      "ls_param-nobinpt = 'X'. "Casos especificos
    ELSE.
      ls_param = is_param.
    ENDIF.

    CALL TRANSACTION i_tcode USING gt_batch
                    OPTIONS FROM ls_param
                   MESSAGES INTO lt_bdcret.

    CALL FUNCTION 'CONVERT_BDCMSGCOLL_TO_BAPIRET2'
      TABLES
        imt_bdcmsgcoll = lt_bdcret
        ext_return     = gt_batchret.

    FREE gt_batch.

    bapi_save(
      EXPORTING
        it_return = gt_batchret
        i_number  = i_number
      IMPORTING
        e_icon    = e_icon
        e_message = e_message
      CHANGING
        ct_return = ct_return
      EXCEPTIONS
        error     = 1
    ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

  ENDMETHOD.


  METHOD bapi_save.
    DATA: lt_return TYPE bapirettab,
          ls_return LIKE LINE OF lt_return,
          l_number  TYPE sy-subrc.

    "Resultado
    lt_return = it_return.
    SORT lt_return BY type.

    READ TABLE lt_return INTO ls_return INDEX 1.
    READ TABLE lt_return INTO ls_return WITH KEY number = i_number.
    IF sy-subrc <> 0 AND i_number IS NOT INITIAL.
      l_number = 1.
    ENDIF.
    IF ls_return-type <> 'E' AND l_number = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_on.

      e_icon = gc_green.
      IF ls_return-message IS NOT INITIAL.
        e_message = ls_return-message.
        APPEND ls_return TO ct_return.
      ENDIF.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      e_icon = gc_red.
      e_message = ls_return-message.
      APPEND LINES OF it_return TO ct_return.
      RAISE error.
    ENDIF.
  ENDMETHOD.


  METHOD bapi_datax.
  ENDMETHOD.


  METHOD amp_me21n.

    DATA: ls_item TYPE mepoitem.
    DATA: ls_header TYPE mepoheader.

    "Edición
    ls_item = io_item->get_data( ).
    ls_header = io_item->get_header( )->get_data( ).
*    IF io_item->get_header( )->is_changeable( ) = abap_on AND
*       ls_header-bsart IN zconst-r_bsart AND
*       ls_item-knttp IN zconst-r_knttp.
*      zamp-is_edicion = abap_on.
*    ENDIF.

  ENDMETHOD.


  METHOD alv_style.
    DATA: ls_cell LIKE LINE OF ct_cell.
    FIELD-SYMBOLS: <fs_cell> LIKE LINE OF ct_cell.

    LOOP AT ct_cell ASSIGNING <fs_cell> WHERE fieldname = i_campo.
      ADD i_style TO <fs_cell>-style.
    ENDLOOP.
    IF sy-subrc <> 0.
      ls_cell-fieldname = i_campo.
      ls_cell-style     = i_style.
      INSERT ls_cell INTO TABLE ct_cell.
    ENDIF.
  ENDMETHOD.


  METHOD alv_fcatname.
    DATA: l_large TYPE string.

    "01. Inicializa
    CLEAR: cs_fcat-rollname, cs_fcat-scrtext_s, cs_fcat-scrtext_m.
    l_large = i_large.
    IF l_large IS INITIAL.
      l_large = i_unico.
    ENDIF.

    "02. Asigna textos
    cs_fcat-coltext = i_unico.      "40
    cs_fcat-reptext = i_unico.      "55
    IF strlen( i_unico ) <= 10.
      cs_fcat-scrtext_s = i_unico.  "10
    ENDIF.
    IF strlen( i_unico ) <= 20.
      cs_fcat-scrtext_m = i_unico.  "20
    ENDIF.
    cs_fcat-seltext   = l_large.    "40
    cs_fcat-scrtext_l = l_large.    "40
  ENDMETHOD.


  METHOD alv_fcatgen.
    TYPES: BEGIN OF ty_campo,
             name TYPE fieldname,
           END OF ty_campo.
    DATA: lo_alv  TYPE REF TO cl_salv_table,
          lo_cols TYPE REF TO cl_salv_columns_table,
          lo_aggr TYPE REF TO cl_salv_aggregations.
    DATA: lt_campo TYPE TABLE OF ty_campo,
          ls_campo LIKE LINE OF lt_campo,
          lt_fcat  TYPE lvc_t_fcat,
          ls_fcat  LIKE LINE OF lt_fcat.

    "01. Reordenamiento
    IF c_campo IS NOT INITIAL.
      TRANSLATE c_campo TO UPPER CASE.
      SPLIT c_campo AT ',' INTO TABLE lt_campo.
    ENDIF.

    "02. Catalogo
    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = lo_alv CHANGING t_table = ct_table ).
        lo_cols = lo_alv->get_columns( ).
        lo_aggr = lo_alv->get_aggregations( ).
        lt_fcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns = lo_cols r_aggregations = lo_aggr ).

        LOOP AT lt_fcat INTO ls_fcat.
          CLEAR: ls_fcat-col_pos, ls_fcat-no_sign.
          IF c_campo IS NOT INITIAL.
            READ TABLE lt_campo WITH KEY name = ls_fcat-fieldname TRANSPORTING NO FIELDS.
            IF sy-subrc = 0.
              ls_fcat-col_pos = sy-tabix.
              APPEND ls_fcat TO et_fcat.
            ENDIF.
          ELSE.
            APPEND ls_fcat TO et_fcat.
          ENDIF.
        ENDLOOP.
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD alv_color.
    DATA: ls_cell LIKE LINE OF rt_cell.

    ls_cell-fname     = i_campo.
    ls_cell-color-col = i_color.
    APPEND ls_cell TO rt_cell.
  ENDMETHOD.


  METHOD alvsalv_show.

    DATA: lo_alv  TYPE REF TO cl_salv_table,
          lo_disp TYPE REF TO cl_salv_display_settings,
          lo_cols TYPE REF TO cl_salv_columns_table,
          lo_func TYPE REF TO cl_salv_functions_list,
          lo_layo TYPE REF TO cl_salv_layout,
          lo_aggr TYPE REF TO cl_salv_aggregations,
          lo_even TYPE REF TO cl_salv_events_table,
          ls_key  TYPE salv_s_layout_key.
**
**    DATA: lt_fcat TYPE lvc_t_fact,
**          l_campo TYPE string.
**    FIELD-SYMBOLS: <fs_fcat> LIKE LINE OF lt_fcat.
**
**      "01. Campos
**      CONCATENATE '' ''
**                  INTO l_campo.
**      alv_fcatgen( IMPORTING et_fcat = lt_fcat CHANGING ct_table = ct_table c_campo = l_campo ).
**
**    "02. Fcat - Descripcion
**    LOOP AT lt_fcat ASSIGNING <fs_fcat>.
**      CASE <fs_fcat>-fieldname.
**        WHEN 'EQUNR'. <fs_fcat>-col_pos = 1. <fs_fcat>-key = abap_on.
**        WHEN 'EQKTX'. <fs_fcat>-col_pos = 2.
**        WHEN 'EQFNR'. <fs_fcat>-col_pos = 3.
**        WHEN 'EQTYP'. <fs_fcat>-col_pos = 4.
**        WHEN 'CLASS'. <fs_fcat>-col_pos = 5.
**        WHEN 'EQART'.
**          <fs_fcat>-col_pos = 6.
**          ui->alv_fcatname( EXPORTING i_unico = 'Clase Vehículo' CHANGING cs_fcat = <fs_fcat> ).
**        WHEN 'IWERK'. <fs_fcat>-col_pos = 7.
**        WHEN 'STAT'.
**          <fs_fcat>-col_pos = 8.
**          ui->alv_fcatname( EXPORTING i_unico = 'Estatus' CHANGING cs_fcat = <fs_fcat> ).
**        WHEN OTHERS.
**          "03.111. Columna que no sea caracteristica inicie con 0 ocultar
**          IF <fs_fcat>-fieldname(1) <> '0'.
**            <fs_fcat>-tech = abap_on.
**          ENDIF.
**      ENDCASE.
**    ENDLOOP.

    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = lo_alv CHANGING t_table = ct_table ).

        "01. Inicializa
        lo_disp = lo_alv->get_display_settings( ).
        lo_cols = lo_alv->get_columns( ).
        lo_layo = lo_alv->get_layout( ).
        lo_func = lo_alv->get_functions( ).
        lo_aggr = lo_alv->get_aggregations( ).
        lo_even = lo_alv->get_event( ).

        "02. Layout
        lo_disp->set_striped_pattern( abap_on ). "zebra
        lo_cols->set_optimize( abap_on ).        "optimizar

        "03. Variante
        ls_key-report = sy-repid.
        ls_key-handle = sy-dynnr.
        lo_func->set_all( ).
        lo_layo->set_key( ls_key ).
        lo_layo->set_save_restriction( if_salv_c_layout=>restrict_none ).

        "04. Fcat
        cl_salv_controller_metadata=>set_lvc_fieldcatalog( t_fieldcatalog = ct_fcat r_columns = lo_cols r_aggregations = lo_aggr ).

**        "05. Eventos
**        SET HANDLER alv_click FOR lo_even.
**        METHODS: r100_click  FOR EVENT if_salv_events_actions_table~link_click OF cl_salv_events_table IMPORTING i_row i_column.

        lo_alv->display( ).
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD alvlvc_show.
    DATA: ls_layo TYPE lvc_s_layo,
          lt_fcat TYPE lvc_t_fcat,
          ls_vari TYPE disvariant,
          l_campo TYPE string.
**          ls_print TYPE lvc_s_prnt.
**          lt_event TYPE slis_t_event,
**          ls_event LIKE LINE OF lt_event.
**          lt_sort  TYPE lvc_t_sort,
**          ls_sort  LIKE lvc_s_sort.
    FIELD-SYMBOLS: <fs_fcat> LIKE LINE OF lt_fcat.

    "Layout
    ls_layo-zebra      = abap_on.
    ls_layo-cwidth_opt = abap_on.
    ls_layo-col_opt    = abap_on.
**    ls_layo-no_rowmark = abap_on.
**    ls_layo-box_fname  = 'BOX'.
**    ls_layo-ctab_fname = 'CELLCOLOR'.
**    ls_layo-stylefname = 'CELLSTYLE'.
**    ls_layo-info_fname = 'COLOR'.       ls_report-color = 'C700'.
**    ls_layo-grid_title = 'Reporte'.

    "Variante
    ls_vari-username = sy-uname.
    ls_vari-report   = sy-repid.
    ls_vari-handle   = sy-dynnr.

    "Catalogo
**    CONCATENATE 'kstar,kostl,wogbtr,ktext,gasto' ''
**    INTO l_campo.
*    alv_fcatgen( IMPORTING et_fcat = lt_fcat CHANGING ct_table = ct_table c_campo = l_campo ).

    "Fcat - Descripcion
    LOOP AT lt_fcat ASSIGNING <fs_fcat>.
      CASE <fs_fcat>-fieldname.
**      WHEN 'ICON'.       <fs_fcat>-hotspot = abap_on. <fs_fcat>-just = 'C'.
**      WHEN 'MESSAGE4'.   <fs_fcat>-tech = abap_on.
**      WHEN 'TEXT'.       <fs_fcat>-edit = abap_on.
**      WHEN 'STAT_USER'.  <fs_fcat>-outputlen = 4.
**      WHEN 'NETWR'.      <fs_fcat>-emphasize = 'C700'.
**      WHEN 'K0001'.      alv_fcatname( EXPORTING i_unico = 'Observación' i_large = '' CHANGING cs_fcat = <fs_fcat> ).
        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

**    "Eventos
**    ls_event-name = 'TOP_OF_PAGE'.
**    ls_event-form = 'R100_TOP'.
**    APPEND ls_event TO lt_event.
**    ls_event-name = 'CALLER_EXIT'.
**    ls_event-form = 'R100_EVENT'.
**    APPEND ls_event TO lt_event.
**
**    "Imprimir
**    ls_print-prntselinf = 'X'.
**    ls_print-prntlstinf = 'X'.
**
**    "Sort
**    ls_sort-fieldname = 'PGMID'.
**    ls_sort-up        = 'X'.
**    APPEND ls_sort TO lt_sort.

    "Alv
    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
      EXPORTING
        i_bypassing_buffer = abap_on
        i_buffer_active    = abap_on
        i_callback_program = sy-repid
        is_layout_lvc      = ls_layo
**        is_print_lvc             = ls_print
        it_fieldcat_lvc    = lt_fcat
**        it_events                = lt_event
**        it_sort_lvc              = lt_sort
        i_save             = 'A'
**        i_callback_pf_status_set = 'R100_ST'
**        i_callback_user_command  = 'R100_UC'
        is_variant         = ls_vari
**        i_screen_start_column    = 50
**        i_screen_start_line      = 1
**        i_screen_end_column      = 120
**        i_screen_end_line        = 5
      TABLES
        t_outtab           = ct_table
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

**    "Alv no lvc only for editable check
**    FIELD-SYMBOLS: <fs_fcat2> LIKE LINE OF lt_fcat2.
**
**    CALL FUNCTION 'LVC_TRANSFER_TO_SLIS'
**      EXPORTING
**        it_fieldcat_lvc = lt_fcat
**        is_layout_lvc   = ls_layo
**      IMPORTING
**        et_fieldcat_alv = lt_fcat2
**        es_layout_alv   = ls_layo2.
**
**    LOOP AT lt_fcat ASSIGNING <fs_fcat>.
**      READ TABLE lt_fcat2 ASSIGNING <fs_fcat2> WITH KEY fieldname = <fs_fcat>-fieldname.
**      IF <fs_fcat>-convexit IS NOT INITIAL.
**        CONCATENATE '==' <fs_fcat>-convexit INTO <fs_fcat2>-edit_mask.
**      ENDIF.
**    ENDLOOP.
**
**    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
**      EXPORTING
**        i_bypassing_buffer       = abap_on
**        i_buffer_active          = abap_on
**        i_callback_program       = sy-repid
**        is_layout                = ls_layo2
**        it_fieldcat              = lt_fcat2
**        i_save                   = 'A'
**        it_events                = lt_event
**        i_callback_pf_status_set = 'R100_ST'
**        i_callback_user_command  = 'R100_UC'
**        is_variant               = ls_vari
**      TABLES
**        t_outtab                 = ct_table
**      EXCEPTIONS
**        program_error            = 1
**        OTHERS                   = 2.
**    IF sy-subrc <> 0.
**      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
**         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
**    ENDIF.
**
***----------------------------------------------------------------------*
*** Alv - Status
***----------------------------------------------------------------------*
**FORM r100_st CHANGING ct_excl TYPE slis_t_extab.
**  go_report->r100_st( CHANGING ct_excl = ct_excl ).
**ENDFORM.                    "r100_st
**
***----------------------------------------------------------------------*
*** Alv - Uc
***----------------------------------------------------------------------*
**FORM r100_uc USING i_ucomm TYPE sy-ucomm
**                   cs_sel  TYPE slis_selfield.
**  go_report->r100_uc( EXPORTING i_ucomm = i_ucomm CHANGING cs_sel = cs_sel ).
**ENDFORM.                    "r100_uc
**
***----------------------------------------------------------------------*
*** Alv - Event
***----------------------------------------------------------------------*
**FORM r100_event USING is_exit TYPE slis_data_caller_exit.
**  go_report->r100_event( ).
**ENDFORM.
**
***----------------------------------------------------------------------*
*** Alv - Top
***----------------------------------------------------------------------*
**FORM r100_top.
**  DATA: lt_head TYPE slis_t_listheader.
**
***  PERFORM get_top100.       "Obtener datos y construir top
***  "H = Titulo, S = Texto
***  PERFORM u_top_set USING 'H' '' 'Resumen' CHANGING lt_head.
***  PERFORM u_top_set USING 'S' 'Cant de B.Pesaje' gs_top-cant_ped CHANGING lt_head.
**
**  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
**    EXPORTING
**      it_list_commentary = lt_head.
**ENDFORM.
**
**----------------------------------------------------------------------*
**  Metodos a implementar
**----------------------------------------------------------------------*
**    "Lvc
**    DATA: go_100 TYPE REF TO cl_gui_alv_grid.
**    METHODS: r100_st CHANGING ct_excl TYPE slis_t_extab.
**    METHODS: r100_uc IMPORTING i_ucomm TYPE clike CHANGING cs_sel TYPE slis_selfield.
**    METHODS: r100_event.
**    METHODS: r100_changed FOR EVENT data_changed_finished OF cl_gui_alv_grid IMPORTING e_modified et_good_cells.
**
**  METHOD r100_st.
****    DATA: lt_fcode TYPE TABLE OF smp_dyntxt,
****          ls_fcode LIKE LINE OF lt_fcode.
**
**    alvlvc_excludest( CHANGING ct_excl = ct_excl ).
****
****    "Añadir FC01
****    ls_fcode-icon_id   = icon_print.
****    ls_fcode-icon_text = 'Imprimir'.
****    ls_fcode-text      = 'Imprimir Formulario'.
****    APPEND ls_fcode TO lt_fcode.
****    PERFORM dynamic_report_fcodes IN PROGRAM rhteiln0 TABLES lt_fcode USING ct_excl '' ''.
**
**    SET PF-STATUS 'ALVLIST' EXCLUDING ct_excl OF PROGRAM 'RHTEILN0'.
**  ENDMETHOD.
**
**  METHOD r100_uc.
**    CASE i_ucomm.
**      WHEN '&IC1'.
**        READ TABLE gt_det INTO DATA(ls_det) INDEX cs_sel-tabindex.
**        CASE cs_sel-fieldname.
**          WHEN 'ICON'.
**          WHEN 'BELNR'.
**          WHEN OTHERS.
**        ENDCASE.
**      WHEN 'FC01'.
**      WHEN '/&REFRESH'. alvlvc_refresh( CHANGING cs_sel = cs_sel ).
**      WHEN OTHERS.
**    ENDCASE.
**  ENDMETHOD.
**
**  METHOD r100_event.
**    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
**      IMPORTING
**        e_grid = go_100.
**
**    SET HANDLER r100_changed FOR go_100.
**    go_100->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
**    go_100->register_edit_event( cl_gui_alv_grid=>mc_evt_enter ).
**  ENDMETHOD.
**
**  METHOD r100_changed.
**  ENDMETHOD.
  ENDMETHOD.


  METHOD alvlvc_settop.
    DATA: ls_head LIKE LINE OF ct_head.
    ls_head-typ  = i_typ.
    ls_head-key  = i_key.
    ls_head-info = i_info.
    APPEND ls_head TO ct_head.
  ENDMETHOD.


  METHOD alvlvc_refresh.
    cs_sel-refresh = abap_on.
    cs_sel-col_stable = abap_on.
    cs_sel-row_stable = abap_on.
    message_show( ).
  ENDMETHOD.


  METHOD alvlvc_excludest.
    APPEND '&DATA_SAVE' TO ct_excl. "Grabar
    APPEND '&EB3' TO ct_excl.       "Otros informes
    APPEND '&REFRESH' TO ct_excl.   "Refrescar
    APPEND '&AQW' TO ct_excl.       "Tratamiento de textos...
    APPEND '%PC'  TO ct_excl.       "Fichero local...
    APPEND '&ABC' TO ct_excl.       "Analisis ABC
**    APPEND '&RNT_PREV' TO ct_excl.  "Presentacion preliminar
**    APPEND 'DNOT' TO ct_excl.       "List Visualizar nota
**    APPEND 'CNOT' TO ct_excl.       "List Tratar nota
  ENDMETHOD.


  METHOD alvgrid_show.
  ENDMETHOD.


  METHOD alvfast_show.
    DATA: lo_alv  TYPE REF TO cl_salv_table,
          lo_func TYPE REF TO cl_salv_functions_list,
          lo_cols TYPE REF TO cl_salv_columns_table,
          lo_aggr TYPE REF TO cl_salv_aggregations.
**          lo_display TYPE REF TO cl_salv_display_settings.
    DATA: lt_fcat TYPE lvc_t_fcat.
    FIELD-SYMBOLS: <fs_fcat> LIKE LINE OF lt_fcat.

    CHECK ct_table IS NOT INITIAL.

    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = lo_alv
                                CHANGING t_table       = ct_table ).

        lo_func = lo_alv->get_functions( ).
        lo_func->set_default( abap_on ).
        lo_cols = lo_alv->get_columns( ).
        lo_cols->set_optimize( abap_on ).
**        lo_display = lo_alv->get_display_settings( ).
**        lo_display->set_list_header( i_title ).

        "fcat
        lo_aggr = lo_alv->get_aggregations( ).
        lt_fcat = ct_fcat.
        IF lt_fcat IS INITIAL.
          lt_fcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns = lo_cols r_aggregations = lo_aggr ).
          LOOP AT lt_fcat ASSIGNING <fs_fcat>.
            <fs_fcat>-scrtext_s = <fs_fcat>-scrtext_m = <fs_fcat>-scrtext_l = <fs_fcat>-fieldname.
          ENDLOOP.
        ENDIF.
        cl_salv_controller_metadata=>set_lvc_fieldcatalog( t_fieldcatalog = lt_fcat r_columns = lo_cols r_aggregations = lo_aggr ).

        lo_alv->display( ).
      CATCH cx_root.
    ENDTRY.
  ENDMETHOD.


  METHOD is_hana.
  ENDMETHOD.


  METHOD isconfirm.
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

    IF l_answer <> '1'.
      MESSAGE e000(su) WITH 'Acción cancelada...' RAISING cancel.
    ENDIF.
  ENDMETHOD.


  METHOD isauthority_auart.
    AUTHORITY-CHECK OBJECT 'V_VBAK_AAT'
      ID 'AUART' FIELD i_auart
      ID 'ACTVT' FIELD '02'.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD isauthorithy_vkorg.
    AUTHORITY-CHECK OBJECT 'V_VBAK_VKO'
      ID 'VKORG' FIELD i_vkorg
      ID 'VTWEG' FIELD i_vtweg
      ID 'SPART' FIELD i_spart
      ID 'ACTVT' FIELD i_actvt.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD input_data.
    DATA: lt_field TYPE ty_sval,
          ls_field LIKE LINE OF lt_field,
          l_return TYPE char1.

    "01. Procesa
    ls_field-tabname   = i_tab.
    ls_field-fieldname = i_field.
    ls_field-field_obl = abap_on.
    ls_field-value     = e_value.
    APPEND ls_field TO lt_field.

    "02. Obtener
    CALL FUNCTION 'POPUP_GET_VALUES'
      EXPORTING
        popup_title     = i_title
      IMPORTING
        returncode      = l_return
      TABLES
        fields          = lt_field
      EXCEPTIONS
        error_in_fields = 1
        OTHERS          = 2.

    IF l_return = 'A'.
      MESSAGE s000(00) WITH 'Acción cancelada...' DISPLAY LIKE 'E' RAISING cancel.
    ELSE.

      "02.01. Recuperar
      READ TABLE lt_field INTO ls_field INDEX 1.
      IF sy-subrc = 0.
        e_value = ls_field-value.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD hana_select.
  ENDMETHOD.


  METHOD hana_range.
  ENDMETHOD.


  METHOD gui_upload_txt.
    DATA: l_filename TYPE string.

    l_filename = i_filename.

    cl_gui_frontend_services=>gui_upload(
    EXPORTING
    filename                = l_filename
**    filetype               = 'ASC'       "Default
    codepage                = '4110'      "utf8
    has_field_separator     = i_separator
    CHANGING
    data_tab                = rt_data
    EXCEPTIONS
    file_open_error         = 1
    file_read_error         = 2
    no_batch                = 3
    gui_refuse_filetransfer = 4
    invalid_type            = 5
    no_authority            = 6
    unknown_error           = 7
    bad_data_format         = 8
    header_not_allowed      = 9
    separator_not_allowed   = 10
    header_too_long         = 11
    unknown_dp_error        = 12
    access_denied           = 13
    dp_out_of_memory        = 14
    disk_full               = 15
    dp_timeout              = 16
    not_supported_by_gui    = 17
    error_no_gui            = 18
    ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD gui_download_txt.
    DATA: l_file TYPE string.
    l_file = i_file.

    cl_gui_frontend_services=>gui_download(
    EXPORTING
    filename                  = l_file
**    filetype                  = 'ASC'
**    confirm_overwrite         = i_overwrite
    codepage                  = '4110'           "utf8
    append                    = i_append
    write_field_separator     = i_separator
    CHANGING
    data_tab                  = ct_data
    EXCEPTIONS
    file_write_error          = 1
    no_batch                  = 2
    gui_refuse_filetransfer   = 3
    invalid_type              = 4
    no_authority              = 5
    unknown_error             = 6
    header_not_allowed        = 7
    separator_not_allowed     = 8
    filesize_not_allowed      = 9
    header_too_long           = 10
    dp_error_create           = 11
    dp_error_send             = 12
    dp_error_write            = 13
    unknown_dp_error          = 14
    access_denied             = 15
    dp_out_of_memory          = 16
    disk_full                 = 17
    dp_timeout                = 18
    file_not_found            = 19
    dataprovider_exception    = 20
    control_flush_error       = 21
    not_supported_by_gui      = 22
    error_no_gui              = 23
    OTHERS                    = 24
    ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD gui_download_bin.
    cl_gui_frontend_services=>gui_download(
      EXPORTING
        filename                = i_file
        filetype                = 'BIN'
      CHANGING
        data_tab                = ct_data
      EXCEPTIONS
        file_write_error        = 1
        no_batch                = 2
        gui_refuse_filetransfer = 3
        invalid_type            = 4
        no_authority            = 5
        unknown_error           = 6
        header_not_allowed      = 7
        separator_not_allowed   = 8
        filesize_not_allowed    = 9
        header_too_long         = 10
        dp_error_create         = 11
        dp_error_send           = 12
        dp_error_write          = 13
        unknown_dp_error        = 14
        access_denied           = 15
        dp_out_of_memory        = 16
        disk_full               = 17
        dp_timeout              = 18
        file_not_found          = 19
        dataprovider_exception  = 20
        control_flush_error     = 21
        not_supported_by_gui    = 22
        error_no_gui            = 23
        OTHERS                  = 24 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD gui_browse.
    DATA: l_length TYPE i,
          l_path   TYPE et_ws_path.

    GET PARAMETER ID 'ECATT_FILENAME' FIELD l_path.
    r_folder = l_path.
    IF r_folder IS INITIAL.
      r_folder = 'D:\'.
    ENDIF.

    cl_gui_frontend_services=>directory_browse(
      EXPORTING
        initial_folder       = r_folder
      CHANGING
        selected_folder      = r_folder
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
    ).
    IF sy-subrc = 0.
      IF r_folder IS NOT INITIAL.
        l_path = r_folder.
        SET PARAMETER ID 'ECATT_FILENAME' FIELD l_path.

        l_length = strlen( r_folder ).
        IF l_length > 3.
          CONCATENATE r_folder '\' INTO r_folder.
        ENDIF.
      ELSE.
        MESSAGE e000(su) WITH 'Folder no seleccionado...' RAISING error.
      ENDIF.
    ELSE.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD gos_download.
    DATA: ls_obj        TYPE sibflporb,
          lt_reltyp     TYPE obl_t_relt,
          ls_reltyp     LIKE LINE OF lt_reltyp,

          lt_link       TYPE obl_t_link,
          ls_link       LIKE LINE OF lt_link,
          ls_doc        TYPE sofolenti1,
          lt_objhead    TYPE TABLE OF solisti1,
          ls_objhead    LIKE LINE OF lt_objhead,
          lt_objcontent TYPE TABLE OF solisti1,
          lt_content    TYPE TABLE OF solix,

          l_filename    TYPE string.

    ls_obj-instid = i_obj_name.
    ls_obj-typeid = i_object.
    ls_obj-catid = 'BO'.

    ls_reltyp = 'IEQATTA'. "ATTA Attachment type, URL type
    APPEND ls_reltyp TO lt_reltyp.

    TRY.
        cl_binary_relation=>read_links(
          EXPORTING
            is_object           = ls_obj
            it_relation_options = lt_reltyp
            ip_no_buffer        = abap_on
          IMPORTING
            et_links            = lt_link ).
      CATCH cx_obl_parameter_error.
        RAISE error.
      CATCH cx_obl_internal_error.
        RAISE error.
      CATCH cx_obl_model_error.
        RAISE error.
    ENDTRY.

    LOOP AT lt_link INTO ls_link.
      ls_doc-doc_id = ls_link-instid_b.

      CALL FUNCTION 'SO_DOCUMENT_READ_API1'
        EXPORTING
          document_id                = ls_doc-doc_id
        IMPORTING
          document_data              = ls_doc
        TABLES
          object_header              = lt_objhead
          object_content             = lt_objcontent
          contents_hex               = lt_content
        EXCEPTIONS
          document_id_not_exist      = 1
          operation_no_authorization = 2
          x_error                    = 3
          OTHERS                     = 4.
      IF sy-subrc = 0.
        LOOP AT lt_objhead INTO ls_objhead WHERE line CS 'FILENAME'.
          SPLIT ls_objhead-line AT '=' INTO ls_objhead-line l_filename.
          CONCATENATE i_folder i_obj_name '\' l_filename INTO l_filename.
          EXIT.
        ENDLOOP.

        gui_download_bin(
          EXPORTING
            i_file  = l_filename
          CHANGING
            ct_data = lt_content
          EXCEPTIONS
            error   = 1
        ).
        IF sy-subrc <> 0.
          RAISE error.
        ENDIF.
      ELSE.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD folder_listfiles.

    DATA: lt_dir TYPE TABLE OF sdokpath,
          l_dir  TYPE char100.

    l_dir = i_dir.

    CALL FUNCTION 'TMP_GUI_DIRECTORY_LIST_FILES'
      EXPORTING
        directory  = l_dir
      TABLES
        file_table = et_file
        dir_table  = lt_dir
      EXCEPTIONS
        cntl_error = 1.
  ENDMETHOD.


  METHOD find_regex.
  ENDMETHOD.


  METHOD file_exist.
    DATA: lw_file   TYPE string,
          lw_result TYPE c.

    lw_file = i_file.

    cl_gui_frontend_services=>file_exist(
      EXPORTING
        file                 = lw_file
      RECEIVING
        result               = lw_result
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        wrong_parameter      = 3
        not_supported_by_gui = 4
        OTHERS               = 5 ).

    IF lw_result IS INITIAL.
      e_subrc = 1.
      MESSAGE s000(su) WITH 'Archivo no existe' RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD file_browser.
    DATA: l_dir   TYPE string.

    cl_gui_frontend_services=>directory_browse(
      CHANGING
        selected_folder      = l_dir
      EXCEPTIONS
        cntl_error           = 1
        error_no_gui         = 2
        not_supported_by_gui = 3
    ).
    IF sy-subrc = 0.
      c_dir = l_dir.
    ELSE.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
         WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 RAISING error.
    ENDIF.
  ENDMETHOD.


  METHOD field_getdynamic.
    FIELD-SYMBOLS <fs> TYPE any.
    ASSIGN COMPONENT i_field OF STRUCTURE is_line TO <fs>.
    IF sy-subrc = 0.
      e_out = <fs>.
    ENDIF.
  ENDMETHOD.


  METHOD f4_field.
  ENDMETHOD.


  METHOD excel_uploadeasy.
    DATA: l_raw      TYPE truxs_t_text_data,
          l_subrc    TYPE c,
          l_filename TYPE localfile.

    l_filename = i_filename.
    l_subrc = cl_gui_frontend_services=>file_exist( file = i_filename ).

    IF l_subrc IS NOT INITIAL.
      CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
        EXPORTING
          i_tab_raw_data       = l_raw
          i_filename           = l_filename
        TABLES
          i_tab_converted_data = rt_data
        EXCEPTIONS
          conversion_failed    = 1.
    ENDIF.
  ENDMETHOD.


  METHOD excel_upload.
  ENDMETHOD.


  METHOD dynpro_help.
  ENDMETHOD.


  METHOD dynpro_forzar_pbo.
  ENDMETHOD.


  METHOD dynpro.
  ENDMETHOD.


  METHOD dynamic_select.
  ENDMETHOD.


  METHOD date_startend.
    CALL FUNCTION 'OIL_MONTH_GET_FIRST_LAST'
      EXPORTING
        i_date      = i_date
      IMPORTING
        e_first_day = e_fecini
        e_last_day  = e_fecfin.
  ENDMETHOD.
ENDCLASS.