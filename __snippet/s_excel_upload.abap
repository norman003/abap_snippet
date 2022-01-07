DATA: go_excel TYPE REF TO data,
      go_line  TYPE REF TO data.

FIELD-SYMBOLS: <ft_excel> TYPE STANDARD TABLE,
               <fs_excel> TYPE any.

*----------------------------------------------------------------------*
* Leer excel
*----------------------------------------------------------------------*
FORM s_excel_upload USING i_table TYPE dd02l-tabname
                           i_file  TYPE any.

  DATA: lt_fcat         TYPE lvc_t_fcat,
        ls_fcat         TYPE lvc_s_fcat,
        lt_excel        TYPE TABLE OF zalsmex_tabline,
        l_filename      TYPE rlgrap-filename,
        l_function_conv TYPE string,
        l_index         TYPE i.

  FIELD-SYMBOLS: <fs_excel> LIKE LINE OF lt_excel,
                 <fs>       TYPE any.

* 0. Crear tabla dinamica
  PERFORM r_table_builddynamic USING i_table CHANGING lt_fcat.
  CHECK <ft_excel>[] IS ASSIGNED.

* 1. Obtener del excel
  l_filename = i_file.
  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = l_filename
      i_begin_col             = 1
      i_begin_row             = 1
      i_end_col               = 250
      i_end_row               = 65000
    TABLES
      intern                  = lt_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

* 2. Borrar linea de cabecera
  DELETE lt_excel WHERE row EQ 1.

* 3. Pasar de texto a la tabla dinamica
  LOOP AT lt_excel ASSIGNING <fs_excel>.

    l_index = <fs_excel>-col.

    AT NEW row.
      CLEAR <fs_excel>.
    ENDAT.

*  3.1 Por columna
    ASSIGN COMPONENT l_index OF STRUCTURE <fs_excel> TO <fs>.
    IF sy-subrc = 0.

*    3.1.1 Verificar tipo de dato o conversion
      READ TABLE lt_fcat INTO ls_fcat INDEX l_index.
      CASE ls_fcat-inttype.

*       1. Números
        WHEN 'N' OR 'P' OR 'I'.
          TRY .
              <fs> = <fs_excel>-value.
            CATCH cx_sy_conversion_no_number.
          ENDTRY.
*       2. Fecha
        WHEN 'D'.
          CONCATENATE <fs_excel>-value+6(4)
                      <fs_excel>-value+3(2)
                      <fs_excel>-value+0(2) INTO <fs>.
*       3. Texto
        WHEN OTHERS.
*         3.1 Cuando no necesite conversion
          IF ls_fcat-convexit = ''.
            <fs> = <fs_excel>-value.
          ELSE.

*         3.2 Cuando necesita conversion
            IF <fs_excel>-value IS NOT INITIAL.
              CONCATENATE 'CONVERSION_EXIT_'  ls_fcat-convexit '_INPUT' INTO l_function_conv.

              CALL FUNCTION l_function_conv
                EXPORTING
                  input  = <fs_excel>-value
                IMPORTING
                  output = <fs>.
            ENDIF.
          ENDIF.
      ENDCASE.
    ENDIF.

*  3.2 Por registro
    AT END OF row.
      APPEND <fs_excel> TO <ft_excel>.
    ENDAT.
  ENDLOOP.
ENDFORM.

*----------------------------------------------------------------------*
* Obtener tabla dinamica
*----------------------------------------------------------------------*
FORM s_table_builddynamic USING i_table TYPE dd02l-tabname
                           CHANGING ct_fcat TYPE lvc_t_fcat.
  DATA: ls_fcat TYPE lvc_s_fcat.

  "0 Inicializa
  IF <ft_excel> IS ASSIGNED. UNASSIGN <ft_excel>. ENDIF.
  IF <fs_excel> IS ASSIGNED. UNASSIGN <fs_excel>. ENDIF.

  "1. Catalogo
  ct_fcat = lvc_fieldcatalog_merge( i_table ).

  "Borrar mandante, cuando se cargue el excel no sera necesario la columna
  DELETE ct_fcat WHERE fieldname = 'MANDT'.

  "2. Tabla dinamica
  CALL METHOD clulv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog           = ct_fcat
    IMPORTING
      ep_table                  = go_excel
    EXCEPTIONS
      generate_subpool_dir_full = 1
      OTHERS                    = 2.

  CHECK NOT go_excel IS INITIAL.

  ASSIGN go_excel->* TO <ft_excel>.

  CREATE DATA go_line LIKE LINE OF <ft_excel>.
  ASSIGN go_line->* TO <fs_excel>.
ENDFORM.

" * 1. Verificar existencia de nombre del archivo
  " PERFORM _verificar_archivo USING i_file CHANGING e_error.
  " CHECK e_error IS INITIAL.

" * 2. Obtener data y pasar a tabla dinamica
  " PERFORM _pasar_excel_a_tabla USING i_table i_file.

" * 3. Conversion adicional
  " LOOP AT <ft_excel> ASSIGNING <fs_excel>.
    " APPEND INITIAL LINE TO ct_uplckmlkeph ASSIGNING <fs_updckmlkeph>.
    " MOVE-CORRESPONDING <fs_excel> TO <fs_updckmlkeph>.
    " UNASSIGN <fs_updckmlkeph>.
  " ENDLOOP.