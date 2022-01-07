*&---------------------------------------------------------------------*
*&  Include           ZFI_TIPOCAMBIOSBS_F01
*&---------------------------------------------------------------------*

TYPES: BEGIN OF gty_sql,
        quotationunit     TYPE char01,    "Enviar 1
        validfrom         TYPE char24,    "Fecha
        exchangerate      TYPE char22,    "Tipo de cambio
        currencycode      TYPE char03,    "Moneda
        currencyname      TYPE char30,    "Nombre de la moneda
        basecurrencycode  TYPE char03,    "Base de la moneda
        companygroupno    TYPE char04,    "Sociedad
        message           TYPE string,
      END OF gty_sql.

TYPES: tab_sql        TYPE TABLE OF gty_sql.

DATA: BEGIN OF zconst,
        con_name TYPE dbcon-con_name,
        comp_nro TYPE string,
      END OF zconst.

*----------------------------------------------------------------------*
* Obtener constantes
*----------------------------------------------------------------------*
FORM get_constantes.

  DATA: lt_const TYPE TABLE OF zostb_constantes,
        ls_const LIKE LINE OF lt_const.

  SELECT * INTO TABLE lt_const
    FROM zostb_constantes
    WHERE modulo = 'FI'
      AND aplicacion = 'TIPCAM_SERTICA'
      AND programa = 'ZFI_TIPOCAMBIOSBS'.

  LOOP AT lt_const INTO ls_const.
    CASE ls_const-campo.
      WHEN 'CON_NAME'.
        zconst-con_name = ls_const-valor1.
      WHEN 'COMP_NRO'.
        zconst-comp_nro = ls_const-valor1.
    ENDCASE.
  ENDLOOP.
ENDFORM.

*----------------------------------------------------------------------*
* Envio de tipo de cambio a sertica
*----------------------------------------------------------------------*
FORM pf_sendtc_sertica USING it_final TYPE tab_final.


  DATA: lt_sql    TYPE tab_sql,
        ls_sql    LIKE LINE OF lt_sql,
        lt_return TYPE tab_sql.


  PERFORM get_constantes.

  " Tipo de cambio para Sertica
  LOOP AT it_final INTO DATA(ls_final) WHERE moneda = 'USD'.
    ls_sql-quotationunit    = 1.
    ls_sql-currencycode     = ls_final-waers.
    ls_sql-currencyname     = ls_final-descrp.
    ls_sql-basecurrencycode = ls_final-moneda.
    ls_sql-companygroupno   = zconst-comp_nro.

    ls_sql-validfrom = lw_fecha(4) && '-' && lw_fecha+4(2) && '-' && lw_fecha+6(2) && ' 00:00:00.000'.
    IF ls_final-venta > 0.
      ls_sql-exchangerate   = 100 / ls_final-venta.
      CONDENSE ls_sql-exchangerate.
    ENDIF.

    APPEND ls_sql TO lt_sql.
    CLEAR ls_sql.
  ENDLOOP.

  "Insertar en Sertica
  PERFORM sql_insert_db_tipcam USING zconst-con_name
                                     lt_sql
                               CHANGING lt_return.

*  PERFORM sql_select_db_tipcam USING zconst-con_name
*                               CHANGING lt_sql.

  "Enviar correos
  PERFORM pf_sendmail_sertica USING lt_return.

ENDFORM.                    " PF_SENDTC_SERTICA


*----------------------------------------------------------------------*
* Insertar datos en tabla sql
*----------------------------------------------------------------------*
FORM sql_insert_db_tipcam USING i_con_name TYPE dbcon-con_name
                                it_sql       TYPE tab_sql
                          CHANGING et_return TYPE tab_sql.

  DATA: ls_return LIKE LINE OF et_return.


  CHECK it_sql IS NOT INITIAL.

  " connect
  EXEC SQL.
    CONNECT TO :I_CON_NAME
  ENDEXEC.

  " insert
  LOOP AT it_sql INTO DATA(ls_sql).
    TRY.
        EXEC SQL.
          INSERT INTO
            CURRENCYIMPORT(QUOTATIONUNIT, VALIDFROM, EXCHANGERATE, CURRENCYCODE,
                           CURRENCYNAME, BASECURRENCYCODE, COMPANYGROUPNO)
            VALUES( :LS_SQL-QUOTATIONUNIT,
                    :LS_SQL-VALIDFROM,
                    :LS_SQL-EXCHANGERATE,
                    :LS_SQL-CURRENCYCODE,
                    :LS_SQL-CURRENCYNAME,
                    :LS_SQL-BASECURRENCYCODE,
                    :LS_SQL-COMPANYGROUPNO )
        ENDEXEC.

      CATCH cx_sy_native_sql_error INTO DATA(lx_sql).
      CATCH cx_sql_exception.
    ENDTRY.

    "Log
    IF lx_sql IS NOT INITIAL.
      ls_return = ls_sql.
      APPEND ls_return TO et_return.
      FREE lx_sql.
    ENDIF.
  ENDLOOP.

  " Close
  EXEC SQL.
    SET CONNECTION DEFAULT
  ENDEXEC.

  " Excribir mensaje
  IF et_return IS NOT INITIAL.
    PERFORM _show_alv CHANGING et_return.
  ENDIF.

ENDFORM.


*----------------------------------------------------------------------*
* Obtener datos de tipcam
*----------------------------------------------------------------------*
FORM sql_select_db_tipcam USING i_con_name TYPE dbcon-con_name
                          CHANGING et_sql  TYPE tab_sql.

  DATA: ls_sql     LIKE LINE OF et_sql.

  TRY.

      " connect
      DATA(lo_sql) = cl_sql_connection=>get_connection( i_con_name ).

      DATA(l_fecha) = lw_fecha(4) && '-' && lw_fecha+4(2) && '-' && lw_fecha+6(2) && ' 00:00:00.000'.

      " create the query string
      DATA(l_stmt) = `SELECT `
                      && `QUOTATIONUNIT, VALIDFROM, EXCHANGERATE, CURRENCYCODE,`
                      && ` CURRENCYNAME, BASECURRENCYCODE, COMPANYGROUPNO FROM CURRENCYIMPORT`
                      && ` WHERE VALIDFROM ='` && l_fecha && `'`.

      " create a statement object
      DATA(l_stmt_ref) = lo_sql->create_statement( tab_name_for_trace = 'CURRENCYIMPORT' ).

      " bind input variables
      l_stmt_ref->set_param( REF #( ls_sql-quotationunit ) ).
      l_stmt_ref->set_param( REF #( ls_sql-validfrom ) ).
      l_stmt_ref->set_param( REF #( ls_sql-exchangerate ) ).
      l_stmt_ref->set_param( REF #( ls_sql-currencycode ) ).
      l_stmt_ref->set_param( REF #( ls_sql-currencyname ) ).
      l_stmt_ref->set_param( REF #( ls_sql-basecurrencycode ) ).
      l_stmt_ref->set_param( REF #( ls_sql-companygroupno ) ).

      " set the input values and execute the query
      DATA(l_res_ref) = l_stmt_ref->execute_query( l_stmt ).

      " set output table
      l_res_ref->set_param_table( REF #( et_sql ) ).

      " get the complete result set
      DATA(l_row_cnt) = l_res_ref->next_package( ).

      " don't forget to close the result set object in order to free
      " resources on the database
      l_res_ref->close( ).

      " disconnet
      lo_sql->close( ).

    CATCH cx_sql_exception INTO DATA(lcx_sql).
      MESSAGE e000(su) WITH lcx_sql->sql_message(50)
                            lcx_sql->sql_message+50(50)
                            lcx_sql->sql_message+100(50)
                            lcx_sql->sql_message+150(50).
  ENDTRY.

ENDFORM.

*----------------------------------------------------------------------*
* Mostrar alv
*----------------------------------------------------------------------*
FORM _show_alv CHANGING ct_table TYPE STANDARD TABLE.
  DATA: lo_alv  TYPE REF TO cl_salv_table,
        lo_func TYPE REF TO cl_salv_functions_list,
        lo_cols TYPE REF TO cl_salv_columns_table,
        lo_col  TYPE REF TO cl_salv_column_table.

*   Instancia
  cl_salv_table=>factory(
    IMPORTING
      r_salv_table   = lo_alv
    CHANGING
      t_table        = ct_table
  ).

*   Show
  lo_alv->display( ).

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PF_SENDMAIL_SERTICA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM pf_sendmail_sertica USING it_return TYPE tab_sql.

  DATA: objpack LIKE sopcklsti1 OCCURS 2 WITH HEADER LINE.
  DATA: objhead LIKE solisti1 OCCURS 1 WITH HEADER LINE.
  DATA: objbin LIKE solisti1 OCCURS 10 WITH HEADER LINE.
  DATA: objtxt LIKE solisti1 OCCURS 10 WITH HEADER LINE.
  DATA: reclist LIKE somlreci1 OCCURS 5 WITH HEADER LINE.
  DATA: doc_chng LIKE sodocchgi1.
  DATA: tab_lines LIKE sy-tabix.
  DATA l_num(3).

  LOOP AT s_email.

* Creation of the document to be sent
    doc_chng-obj_name = 'SENDFILE'.

* Mail Subject
    IF it_return is initial.
      doc_chng-obj_descr = 'Se envió Tipo de Cambio SBS de SAP a SERTICA'.
    ELSE.
      doc_chng-obj_descr = 'No se envió Tipo de Cambio SBS de SAP a SERTICA'.
    ENDIF.

* Mail Contents
    LOOP AT lt_email INTO ls_email.
      objtxt = ls_email-texto.
      APPEND objtxt.
    ENDLOOP.

    DESCRIBE TABLE objtxt LINES tab_lines.
    READ TABLE objtxt INDEX tab_lines.
    doc_chng-doc_size = ( tab_lines - 1 ) * 255 + strlen( objtxt ).

* Creation of the entry for the compressed document
    CLEAR objpack-transf_bin.
    objpack-head_start = 1.
    objpack-head_num = 0.
    objpack-body_start = 1.
    objpack-body_num = tab_lines.
    objpack-doc_type = 'RAW'.
    APPEND objpack.

    CLEAR reclist.
    reclist-receiver = s_email-low.
    reclist-express = 'X'.
    reclist-rec_type = 'U'.
    reclist-copy = 'X'.
    APPEND reclist.

* Sending the document
    CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
      EXPORTING
        document_data              = doc_chng
        put_in_outbox              = 'X'
        commit_work                = 'X'
      TABLES
        packing_list               = objpack
*       object_header              = objhead
*       contents_bin               = objbin
        contents_txt               = objtxt
        receivers                  = reclist
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        operation_no_authorization = 4
        OTHERS                     = 99.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDLOOP.

ENDFORM.                    " PF_SENDMAIL_SERTICA
