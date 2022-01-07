*----------------------------------------------------------------------*
* Date - Get Ini y Fin
*----------------------------------------------------------------------*
FORM u_date_inifin USING i_date TYPE datum
                    CHANGING e_fecini TYPE datum
                             e_fecfin TYPE datum.
  CALL FUNCTION 'OIL_MONTH_GET_FIRST_LAST'
    EXPORTING
      i_date      = i_date
    IMPORTING
      e_first_day = e_fecini
      e_last_day  = e_fecfin.
ENDIF.
*----------------------------------------------------------------------*
* Obtener tipo de cambio
*----------------------------------------------------------------------*
FORM u_convert_to_foreign_currency USING i_date    TYPE sy-datum
                                          i_waers_o TYPE waers
                                          i_waers_d TYPE waers
                                          i_type_of_rate TYPE char01
                                          i_monto   TYPE any
                                    CHANGING e_monto TYPE any
                                             e_kursf TYPE any.

  DATA: ls_rate LIKE LINE OF gth_rate.

* 0. Tipo
  ls_rate-type_of_rate = i_type_of_rate.
  IF ls_rate-type_of_rate IS INITIAL.
    ls_rate-type_of_rate = 'M'.
  ENDIF.

* 1. Monedas iguales
  IF i_waers_d = i_waers_o.
    e_kursf = 1.
    e_monto   = i_monto.
    RETURN.
  ENDIF.

* 2. Monedas distintas
  "Leer lo almacenado
  READ TABLE gth_rate INTO ls_rate WITH TABLE KEY date    = i_date
                                                  waers_o = i_waers_o
                                                  waers_d = i_waers_d
                                                  type_of_rate = ls_rate-type_of_rate.
  IF sy-subrc = 0.
    IF ls_rate-kursf <> 0.
      e_kursf = ls_rate-kursf.
      e_monto = i_monto / ls_rate-kursf.
    ENDIF.
  ELSE.
    CALL FUNCTION 'CONVERT_TO_FOREIGN_CURRENCY'
      EXPORTING
        date             = i_date
        foreign_currency = i_waers_d
        local_amount     = i_monto
        local_currency   = i_waers_o
        type_of_rate     = ls_rate-type_of_rate
      IMPORTING
        exchange_rate    = e_kursf
        foreign_amount   = e_monto
      EXCEPTIONS
        no_rate_found    = 1
        overflow         = 2
        no_factors_found = 3
        no_spread_found  = 4
        derived_2_times  = 5.

    "Guardar para consultas rapidas
    ls_rate-date    = i_date.
    ls_rate-waers_o = i_waers_o.
    ls_rate-waers_d = i_waers_d.
    ls_rate-kursf   = e_kursf.
    INSERT ls_rate INTO TABLE gth_rate.
  ENDIF.
ENDFORM.

TYPES: BEGIN OF gty_rate,
         date    TYPE datum,
         waers_o TYPE waers,
         waers_d TYPE waers,
         type_of_rate TYPE char01,
         kursf   TYPE kursf,
       END OF gty_rate.
       
DATA: gth_rate TYPE HASHED TABLE OF gty_rate WITH UNIQUE KEY date waers_o waers_d type.
*--------------------------------------------------------------------*
* Date - Get from char
*--------------------------------------------------------------------*
FORM u_date_fromchar USING i_fecha TYPE clike
                      CHANGING e_datum TYPE datum.

  DATA: l_length  TYPE i,
        l_year    TYPE gjahr,
        l_datum   TYPE datum.


  "0. Clear
  CLEAR e_datum.


  "1. Extraer y convertir
  l_length = strlen( i_fecha ).

  CASE l_length.
    WHEN 10. "Formato DD/MM/AAAA
      CONCATENATE i_fecha+6(4) i_fecha+3(2) i_fecha+0(2) INTO l_datum.

    WHEN 8. "Formato DD/MM/AA, DD*MM*AA
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

    WHEN 6. "Formato DDMMAA
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
      "Formato no considerado
  ENDCASE.


  "2. Validar
  CALL FUNCTION 'RP_CHECK_DATE'
    EXPORTING
      date         = l_datum
    EXCEPTIONS
      date_invalid = 1
      OTHERS       = 2.

  IF sy-subrc = 0.
    e_datum = l_datum.
  ENDIF.
ENDFORM.
  TYPES: BEGIN OF gty_rate,
           date         TYPE datum,
           waers_o      TYPE waers,
           waers_d      TYPE waers,
           type_of_rate TYPE char01,
           kursf      TYPE kursf,
         END OF gty_rate .
  DATA: gth_rate TYPE HASHED TABLE OF gty_rate WITH UNIQUE KEY date waers_o waers_d type_of_rate .

  METHODS u_convert_to_local_currency IMPORTING i_date type dats i_waers_o type waers i_waers_d type waers i_type_of_rate type char01 default 'M' i_monto type kwert optional EXPORTING e_tcambio TYPE nfuml e_monto TYPE kwert .

*----------------------------------------------------------------------*
* Obtener tipo de cambio
*----------------------------------------------------------------------*
FORM u_convert_to_local_currency USING i_date    TYPE sy-datum
                                       i_waers_o TYPE waers
                                       i_waers_d TYPE waers
                                       i_type_of_rate TYPE char01
                                       i_monto   TYPE any
                                 CHANGING e_monto TYPE any
                                          e_tcambio type any.
  "METHOD u_convert_to_local_currency.

    DATA: ls_rate LIKE LINE OF gth_rate.

* 0. Tipo
    ls_rate-type_of_rate = i_type_of_rate.
    IF ls_rate-type_of_rate IS INITIAL.
      ls_rate-type_of_rate = 'M'.
    ENDIF.

* 1. Monedas iguales
    IF i_waers_d = i_waers_o.
      e_tcambio = 1.
      e_monto   = i_monto.
      RETURN.
    ENDIF.

* 2. Monedas distintas
    "Leer lo almacenado
    READ TABLE gth_rate INTO ls_rate WITH TABLE KEY date    = i_date
                                                    waers_o = i_waers_o
                                                    waers_d = i_waers_d
                                                    type_of_rate = ls_rate-type_of_rate.
    IF sy-subrc = 0.
      e_tcambio = ls_rate-kursf.
      e_monto   = i_monto * ls_rate-kursf.
    ELSE.
      CALL FUNCTION 'CONVERT_TO_LOCAL_CURRENCY'
        EXPORTING
          date             = i_date
          foreign_amount   = i_monto
          foreign_currency = i_waers_d
          local_currency   = i_waers_o
          type_of_rate     = ls_rate-type_of_rate
        IMPORTING
          exchange_rate    = ls_rate-kursf
        EXCEPTIONS
          no_rate_found    = 1
          overflow         = 2
          no_factors_found = 3
          no_spread_found  = 4
          derived_2_times  = 5
          OTHERS           = 6.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      "Negativo
      IF ls_rate-kursf < 0.
        ls_rate-kursf = 1 / abs( ls_rate-kursf ).
      ENDIF.

      "Tipo de Cambio y conversion del monto
      e_tcambio = ls_rate-kursf.
      e_monto   = i_monto * ls_rate-kursf.

      "Guardar para futuras consultas rapidas
      ls_rate-date    = i_date.
      ls_rate-waers_o = i_waers_o.
      ls_rate-waers_d = i_waers_d.
      ls_rate-type_of_rate = i_type_of_rate.
      INSERT ls_rate INTO TABLE gth_rate.
    ENDIF.
  "ENDMETHOD.
ENDFORM.
*----------------------------------------------------------------------*
* Excel - Upload only xls
*----------------------------------------------------------------------*
FORM u_excel_uploadeasy USING i_filename TYPE clike
                         CHANGING rt_data TYPE STANDARD TABLE.

  DATA: l_raw       TYPE truxs_t_text_data,
        l_subrc     TYPE c,
        l_filename  TYPE localfile.

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

ENDFORM.
*----------------------------------------------------------------------*
* Dynpro - Actualizar campos
*----------------------------------------------------------------------*
FORM u_dynp_update USING i_field TYPE clike
                          i_value TYPE clike.
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
ENDFORM.
*----------------------------------------------------------------------*
* Fb03 - Call
*----------------------------------------------------------------------*
FORM u_fb03 USING i_bukrs TYPE bkpf-bukrs
                  i_belnr TYPE bkpf-belnr
                  i_gjahr TYPE bkpf-gjahr.
  SET PARAMETER ID: 'BLN' FIELD i_belnr,
                    'BUK' FIELD i_bukrs,
                    'GJR' FIELD i_gjahr.
  CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.
ENDFORM.
*----------------------------------------------------------------------*
* Convertir material
*----------------------------------------------------------------------*
FORM u_md_convert_material_unit USING i_matnr TYPE matnr
                                       i_meins_i TYPE meins
                                       i_meins_o TYPE meins
                                       i_menge TYPE menge_d
                                 CHANGING r_menge TYPE menge_d.

  DATA: ls_unit LIKE LINE OF gth_unit.
  
  "Leer lo almacenado
  READ TABLE gth_unit INTO ls_unit WITH TABLE KEY matnr = i_matnr
                                                  meins_i = i_meins_i
                                                  meins_o = i_meins_o.
  IF sy-subrc = 0.
    r_menge = i_menge * ls_unit-menge.
  ELSE.
    CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
      EXPORTING
        i_matnr              = i_matnr
        i_in_me              = i_meins_i
        i_out_me             = i_meins_o
        i_menge              = 1
      IMPORTING
        e_menge              = ls_unit-menge
      EXCEPTIONS
        error_in_application = 1
        error                = 2
        OTHERS               = 3.

    "Cantidad
    r_menge = i_menge * ls_unit-menge.

    "Guardar para consultas rapidas
    ls_unit-matnr = i_matnr.
    ls_unit-meins_i = i_meins_i.
    ls_unit-meins_o = i_meins_o.
    INSERT ls_unit INTO TABLE gth_unit.
  ENDIF.
ENDFORM.

TYPES: BEGIN OF ty_unit,
        matnr TYPE matnr,
        meins_i TYPE meins,
        meins_o TYPE meins,
        menge TYPE menge_d,
       END OF ty_unit.

DATA: gth_unit TYPE HASHED TABLE OF ty_unit WITH UNIQUE KEY matnr meins_i meins_o.
*----------------------------------------------------------------------*
* Convert - To string
*----------------------------------------------------------------------*
FORM u_convert_tostring USING in TYPE any
                         CHANGING out TYPE string.
  DATA l_char20 TYPE char20.

  WRITE in TO l_char20.
  CONDENSE l_char20.
  out = l_char20.
ENDFORM.
*---------------------------------------------------------------------*
* Help - Folder
*---------------------------------------------------------------------*
FORM r_help_folder CHANGING c_dir TYPE clike.
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
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  
  "AT SELECTION-SCREEN ON VALUE-REQUEST FOR pfolder.
ENDFORM.
*----------------------------------------------------------------------*
* Cj13 - Call
*----------------------------------------------------------------------*
FORM u_tcode_cj13 USING i_posid TYPE posid.
  SET PARAMETER ID: 'PRO' FIELD i_posid.
  CALL TRANSACTION 'CJ13' AND SKIP FIRST SCREEN.
ENDFORM.
*----------------------------------------------------------------------*
* Field - Get field dynamic
*----------------------------------------------------------------------*
FORM u_field_getdynamic USING i_field TYPE clike
                               is_line TYPE any
                         CHANGING e_out TYPE any.
  FIELD-SYMBOLS <fs> TYPE any.
  ASSIGN COMPONENT i_field OF STRUCTURE is_line TO <fs>.
  IF sy-subrc = 0.
    e_out = <fs>.
  ENDIF.
ENDFORM.
*----------------------------------------------------------------------*
* Folder - Get list files
*----------------------------------------------------------------------*
FORM u_folder_list TABLES et_file STRUCTURE sdokpath
                    USING i_dir TYPE clike.

  DATA: lt_dir  TYPE TABLE OF sdokpath,
        l_dir   TYPE char100.

  l_dir = i_dir.

  CALL FUNCTION 'TMP_GUI_DIRECTORY_LIST_FILES'
    EXPORTING
      directory  = l_dir
    TABLES
      file_table = et_file
      dir_table  = lt_dir
    EXCEPTIONS
      cntl_error = 1.
ENDFORM.
*----------------------------------------------------------------------*
* Input - date
*----------------------------------------------------------------------*
FORM r_input_date CHANGING e_out TYPE any.

  DATA: lt_fields   TYPE TABLE OF sval,
        ls_fields   LIKE LINE OF lt_fields,
        l_return    TYPE char1.

* 1. Procesa
  ls_fields-tabname   = 'MSEG'.
  ls_fields-fieldname = 'BUDAT_MKPF'.
  ls_fields-value     = sy-datum.
  ls_fields-field_obl = abap_on.
  APPEND ls_fields TO lt_fields.

* 2. Obtener
  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
      popup_title     = 'Ingrese Fecha para contabilización'
    IMPORTING
      returncode      = l_return
    TABLES
      fields          = lt_fields
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.
  
  IF l_return = 'A'.
    MESSAGE s000(26) WITH 'Acción cancelada...' DISPLAY LIKE 'E'.
    sy-subrc = 1.
  ENDIF.
      
* 3. Recuperar
  READ TABLE lt_fields INTO ls_fields INDEX 1.
  IF sy-subrc = 0.
    e_out = ls_fields-value.

* 4. Validar fecha ingresada
    CALL FUNCTION 'RP_CHECK_DATE'
      EXPORTING
        date         = e_out
      EXCEPTIONS
        date_invalid = 1.

    IF sy-subrc <> 0.
      e_out = pi_budat.
    ELSE.
      IF e_out GT sy-datum.
        MESSAGE 'Fe.contabilización no puede ser mayor a Fe.actual' TYPE 'E'.
        sy-subrc = 1.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFORM.
*--------------------------------------------------------------------*
* Input - with field of table
*--------------------------------------------------------------------*
FORM r_input_fieldtable USING i_title TYPE clike
                               i_tab TYPE clike
                               i_field TYPE clike
                         CHANGING e_value TYPE clike.

  DATA: lt_field TYPE ty_sval,
        ls_field LIKE LINE OF lt_field,
        l_return  TYPE char1.

  "1. Procesa
  ls_field-tabname   = i_tab.
  ls_field-fieldname = i_field.
  ls_field-field_obl = abap_on.
  ls_field-value     = e_value.
  APPEND ls_field TO lt_field.

  "2. Obtener
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
    MESSAGE s000(26) WITH 'Acción cancelada...' DISPLAY LIKE 'E'.
    sy-subrc = 1.
  ELSE.

    "3. Recuperar
    READ TABLE lt_field INTO ls_field INDEX 1.
    IF sy-subrc = 0.
      e_value = ls_field-value.
    ENDIF.
  ENDIF.

ENDFORM.
*----------------------------------------------------------------------*
* Authority - Auart
*----------------------------------------------------------------------*
FORM u_is_authority_auart USING i_auart TYPE auart.
  AUTHORITY-CHECK OBJECT 'V_VBAK_AAT'
    ID 'AUART' FIELD i_auart
    ID 'ACTVT' FIELD '02'.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
    METHODS u_is_authorithy_vkorg IMPORTING i_vkorg TYPE vkorg i_vtweg TYPE vtweg i_spart TYPE spart i_actvt TYPE actvt EXCEPTION error.
    
  METHOD u_is_authorithy_vkorg.
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
    METHODS u_is_confirm IMPORTING i_question TYPE clike EXCEPTIONS cancel.

*----------------------------------------------------------------------*
* Mensaje de confirmación
*----------------------------------------------------------------------*
FORM u_is_confirm USING i_question TYPE string
                         i_cancel TYPE xfeld.
  METHOD u_is_confirm.
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
ENDFORM.
*----------------------------------------------------------------------*
* Mb03 - Call
*----------------------------------------------------------------------*
FORM u_tcode_mb03 USING i_mblnr TYPE mblnr
                         i_mjahr TYPE mjahr.
  SET PARAMETER ID: 'MBN' FIELD i_mblnr,
                    'MJA' FIELD i_mjahr.
  CALL TRANSACTION 'MB03' AND SKIP FIRST SCREEN.
ENDFORM.
*----------------------------------------------------------------------*
* Memory - Export/Import
*----------------------------------------------------------------------*
FORM u_memory USING i_tipo  TYPE char01
                     i_process TYPE clike
               CHANGING c_data TYPE any.
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
ENDFORM.
*----------------------------------------------------------------------*
* Buffer - Export/Import
*----------------------------------------------------------------------*
FORM u_memorybuffer USING i_tipo  TYPE char01
                          i_process TYPE clike
                    CHANGING c_data TYPE any.
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
ENDFORM.
*----------------------------------------------------------------------*
* Get mes ini fin
*----------------------------------------------------------------------*
FORM u_mes_inifin USING i_ini TYPE datum
                        i_fin TYPE datum.

  CONCATENATE sy-datum(6) '01' INTO i_ini.
  CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = i_ini
    IMPORTING
      last_day_of_month = i_fin.
ENDFORM.
*----------------------------------------------------------------------*
* Mir4
*----------------------------------------------------------------------*
FORM u_mir4 USING i_belnr TYPE rbkp-belnr
                  i_gjahr TYPE rbkp-gjahr.
  SET PARAMETER ID 'RBN' FIELD i_belnr.
  SET PARAMETER ID 'GJR' FIELD i_gjahr.
  CALL TRANSACTION 'MIR4' AND SKIP FIRST SCREEN.
ENDFORM.
    METHODS u_return_fromsy RETURNING VALUE(rs_return) TYPE bapiret2.

*----------------------------------------------------------------------*
* Return sy
*----------------------------------------------------------------------*
FORM u_return_fromsy CHANGING ct_return TYPE bapirettab.
  METHOD u_return_fromsy.
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
ENDFORM.
*----------------------------------------------------------------------*
* Return - set
*----------------------------------------------------------------------*
FORM u_return_set USING i_id     TYPE sy-msgid
                        i_number TYPE sy-msgno
                        i_type   TYPE sy-msgty
                        i_msg1   TYPE clike
                        i_msg2   TYPE clike
                        i_msg3   TYPE clike
                        i_msg4   TYPE clike
                  CHANGING ct_return TYPE bapirettab.
  DATA: ls_return LIKE LINE OF ct_return.
  ls_return-id     = i_id.
  ls_return-type   = i_type.
  ls_return-number = i_number.
  ls_return-message_v1 = i_msg1.
  ls_return-message_v2 = i_msg2.
  ls_return-message_v3 = i_msg3.
  ls_return-message_v4 = i_msg4.
  IF ls_return-id IS INITIAL. ls_return-id   = 'SU'. ENDIF.
  IF ls_return-type IS INITIAL. ls_return-type = 'E'. ENDIF.
  APPEND ls_return TO ct_return.
ENDFORM.
    METHODS u_return_show IMPORTING it_return TYPE bapirettab.

*----------------------------------------------------------------------*
* Show return
*----------------------------------------------------------------------*
FORM u_return_show USING it_return TYPE bapirettab.
  METHOD u_return_show.
    CALL FUNCTION 'FINB_BAPIRET2_DISPLAY'
      EXPORTING
        it_message = it_return.
  ENDMETHOD.
ENDFORM.
*----------------------------------------------------------------------*
* Return - Show line
*----------------------------------------------------------------------*
FORM u_return_showline USING is_return TYPE bapiret2.
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
ENDFORM.
    METHODS u_return_showsy IMPORTING is_return TYPE bapiret2 OPTIONAL.

*----------------------------------------------------------------------*
* Print message
*----------------------------------------------------------------------*
  METHOD u_return_showsy.
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
* Screen - get field
*----------------------------------------------------------------------*
FORM u_screen_getfield USING i_field TYPE clike
                              i_dynnr TYPE clike
                              e_value TYPE any.
  DATA l_value TYPE char20.

  CALL FUNCTION 'GET_DYNP_VALUE'
    EXPORTING
      i_field      = i_field
      i_repid      = sy-repid
      i_dynnr      = i_dynnr
      i_conv_input = abap_true
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
  "PERFORM screen_getfield USING 'GS_TOP101-AUDAT_L' '0101' gs_top101-audat_l.
ENDFORM.
*----------------------------------------------------------------------*
* Set value
*----------------------------------------------------------------------*
FORM u_setvaluedynamic USING input TYPE clike
                              out TYPE any.
  DATA: l_type TYPE char10,
        l_mask TYPE string.

  DESCRIBE FIELD out TYPE l_type EDIT MASK l_mask.
  CASE l_type.
    WHEN 'N' OR 'P' OR 'I'.
      TRY .
          out = input.
        CATCH cx_sy_conversion_no_number.
      ENDTRY.
    WHEN 'D'. CONCATENATE input+6(4) input+3(2) input+0(2) INTO out.
    WHEN 'C'.
      IF l_mask IS INITIAL.
        out = input.
      ELSE.
        REPLACE '==' IN l_mask WITH ''.
        CONCATENATE 'CONVERSION_EXIT_'  l_mask '_INPUT' INTO l_mask.

        CALL FUNCTION l_mask
          EXPORTING
            input  = input
          IMPORTING
            output = out.
      ENDIF.
    WHEN OTHERS.
      out = input.
  ENDCASE.
ENDFORM.                    "u_setvalue
*----------------------------------------------------------------------*
* Smartforms - Print
*----------------------------------------------------------------------*
FORM u_smartforms USING i_formname TYPE tdsfname
                         i_preview TYPE tdpreview
                         i_tddest TYPE rspopname
                         it_print TYPE gtt_print.

  DATA: ls_control_param  TYPE ssfctrlop,
        ls_composer_param TYPE ssfcompop,
        l_fn_name         TYPE rs38l_fnam,
        ls_print          LIKE LINE OF it_print.


* 1. Creacion de la funcion
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = i_formname
    IMPORTING
      fm_name            = l_fn_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


* 2. Abrir
* Parametro de impresion
  ls_control_param-device     = 'PRINTER'.    "Imprimir
  ls_control_param-preview    = i_preview.    "Mostrar preview
  ls_control_param-no_open    = 'X'.          "Abrir
  ls_control_param-no_close   = 'X'.          "No cerrar
*  ls_control_param-no_dialog  = i_no_dialog.  "No ventana impresora
*  ls_control_param-tdtitle    = ''.          "Titulo ventana impresora

* Opcion para control SPOOL
  ls_composer_param-tdimmed   = abap_true.    "Salida inmediata
  ls_composer_param-tdnewid   = abap_true.    "Nueva orden spool
  ls_composer_param-tddest    = i_tddest.    "Impresora setteado en constantes
*  ls_composer_param-tddelete  = abap_true.    "Borrado inmediato
*  ls_composer_param-tdcovtitle = ''.          "Titulo de spool
*  ls_composer_param-tdnoprev  = space.        "No mostrar formulario
*  ls_composer_param-tdcopies  = 1.            "Nro copias

  CALL FUNCTION 'SSF_OPEN'
    EXPORTING
      user_settings      = ''
      output_options     = ls_composer_param
      control_parameters = ls_control_param
    EXCEPTIONS
      formatting_error   = 1
      internal_error     = 2
      send_error         = 3
      user_canceled      = 4
      OTHERS             = 5.


* 3. Mostrar formulario
  LOOP AT it_print INTO ls_print.
    CALL FUNCTION l_fn_name
      EXPORTING
        control_parameters = ls_control_param
        output_options     = ls_composer_param
        user_settings      = ''
        is_cab             = ls_print-s_cab
      TABLES
        it_det             = ls_print-t_det
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.
    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDLOOP.

* 4. Cerrar
  CALL FUNCTION 'SSF_CLOSE'
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      OTHERS           = 4.
ENDFORM.
*----------------------------------------------------------------------*
* Snro - next
*----------------------------------------------------------------------*
FORM u_snro_next USING is_inri TYPE inri
                  CHANGING r_number TYPE clike.
*----------------------------------------------------------------------*
* Proceso
*  1. Bloquea el rango
*  2. Obtiene el numero siguiente
*  3. Libera el rango
*----------------------------------------------------------------------*
* Ayuda
*  ls_inri-object    = 'ZSD_SHIP'.  "Nombre
*  ls_inri-nrrangenr = '01'.        "Posicion
*  ls_inri-subobject = ''.          "Opcional
*  ls_inri-toyear    = '2015'.      "Como Doc. FI
*  l_nro = go_util->get_next_snro( is_inri = ls_inri ).
*----------------------------------------------------------------------*
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
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
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
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.


    CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
      EXPORTING
        object           = is_inri-object
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
ENDFORM.
  METHODS u_sy_show.
  
*----------------------------------------------------------------------*
* Sy show
*----------------------------------------------------------------------*
FORM u_sy_show.
  METHOD u_sy_show.
    CHECK sy-msgid IS NOT INITIAL.
    
    IF sy-msgty = 'E'.
      MESSAGE ID sy-msgid TYPE 'S' NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 DISPLAY LIKE 'E'.
    ELSE.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.
ENDFORM.
*--------------------------------------------------------------------*
* Text - Save
*--------------------------------------------------------------------*
FORM u_tline_save USING is_thead TYPE thead
                         i_texto TYPE clike.

  DATA:lt_tline TYPE TABLE OF tline,
       ls_tline LIKE LINE OF lt_tline.

  ls_tline-tdformat = '*'.
  ls_tline-tdline   = i_texto.
  APPEND ls_tline to ls_thead.

  CALL FUNCTION 'SAVE_TEXT'
    EXPORTING
      header          = ls_thead
      savemode_direct = 'X'
    TABLES
      lines           = ls_thead
    EXCEPTIONS
      id              = 1
      language        = 2
      name            = 3
      object          = 4
      OTHERS          = 5.
ENDFORM.
*--------------------------------------------------------------------*
* Txt - download
*--------------------------------------------------------------------*
FORM u_txt_download USING i_file TYPE clike
                           i_separator TYPE xfeld
                           i_append  TYPE xfeld
                     CHANGING ct_data TYPE STANDARD TABLE.
  DATA: l_file TYPE string.
  l_file = i_file.

  cl_gui_frontend_services=>gui_download(
    EXPORTING
      filename                  = l_file
      "filetype                  = 'ASC'
      "confirm_overwrite         = i_overwrite
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
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.
*----------------------------------------------------------------------*
* Txt - upload
*----------------------------------------------------------------------*
FORM u_txt_upload USING i_filename TYPE clike
                         i_separator TYPE clike
                   CHANGING rt_data TYPE STANDARD TABLE.
  
  DATA: l_filename TYPE string.
  
  l_filename = i_filename.
  
  cl_gui_frontend_services=>gui_upload(
    EXPORTING
      filename                = l_filename
      "filetype               = 'ASC'       "Default
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
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*----------------------------------------------------------------------*
* Txt - upload servidor
*----------------------------------------------------------------------*
FORM u_txt_uploadserver USING i_filename TYPE string
                         CHANGING ct_data TYPE STANDARD TABLE.

  DATA: l_message TYPE text100.
  DATA: lo_data   TYPE REF TO data.
  FIELD-SYMBOLS: <fs_data> TYPE any.

  CREATE DATA lo_data LIKE LINE OF ct_data.
  ASSIGN lo_data->* TO <fs_data>.

  OPEN DATASET i_filename FOR INPUT IN TEXT MODE ENCODING NON-UNICODE
                          IGNORING CONVERSION ERRORS
                          MESSAGE l_message.
  IF sy-subrc EQ 0.
    DO.
      READ DATASET i_filename INTO <fs_data>.
      CASE sy-subrc.
        WHEN '0'.
          APPEND <fs_data> TO ct_data.
        WHEN '4'.
          EXIT.
        WHEN '8'.
          MESSAGE e000(su) WITH 'Error en lectura de archivo'.
      ENDCASE.
    ENDDO.
  ELSE.
    MESSAGE s000(su) WITH l_message.
  ENDIF.

  CLOSE DATASET i_filename.
ENDFORM.
*----------------------------------------------------------------------*
* Mir4
*----------------------------------------------------------------------*
FORM u_va03 USING i_vbeln TYPE vbak-vbeln.
  SET PARAMETER ID 'AUN'  FIELD i_vbeln.
  CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.
ENDFORM.
*----------------------------------------------------------------------*
* File - Is exist
*----------------------------------------------------------------------*
FORM u_file_isexist USING i_file TYPE clike
                     CHANGING e_subrc TYPE sy-subrc.
  DATA: lw_file   TYPE string,
        lw_result.

  lw_file = i_file.

  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file                 = lw_file
    RECEIVING
      result               = lw_result
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      wrong_parameter      = 3
      not_supported_by_gui = 4
      OTHERS               = 5.

  IF lw_result IS INITIAL.
    e_subrc = 1.
    MESSAGE text-e01 TYPE 'S' DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.