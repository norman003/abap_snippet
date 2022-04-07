*----------------------------------------------------------------------*
* pdf_call
*----------------------------------------------------------------------*
  FORM pdf_call USING is_alv TYPE ty_alv.
    DATA: ls_t001z TYPE t001z,
          l_path TYPE string,
          l_filename TYPE string,
          l_message  TYPE bapiret2-message,
          l_content TYPE xstring.

    "Obtener Ruc
    SELECT SINGLE * INTO ls_t001z FROM t001z WHERE bukrs = is_alv-bukrs AND party = 'ZRUC'.

    CONCATENATE ls_t001z-paval
                is_alv-sunat_trans
                is_alv-sunat_trans INTO l_filename SEPARATED BY '-'.

    "Obtener directorio
    SELECT SINGLE dirname INTO l_path FROM user_dir WHERE aliass = 'DIR_GUIAELE'.

    CONCATENATE l_path '/' l_filename '.pdf' INTO l_filename.


    "Leer archivo
    OPEN DATASET l_filename FOR INPUT IN BINARY MODE MESSAGE l_message.
    IF sy-subrc = 0.
      READ DATASET l_filename INTO l_content.
      IF sy-subrc = 0.
        CLOSE DATASET l_filename. "NEW LOCATION TO CLOSE
      ENDIF.
    ELSE.
      MESSAGE e208(00) WITH l_message. EXIT.
    ENDIF.

    "Show PDF
    PERFORM pdf_alv USING l_content.
    CALL SCREEN 200.
  ENDFORM.                    "pdf_call

*----------------------------------------------------------------------*
* pdf_alv
*----------------------------------------------------------------------*
  FORM pdf_alv USING i_content TYPE xstring.
    DATA: lt_data TYPE TABLE OF x255,
          l_url TYPE char255.

    IF go_html IS INITIAL.
      CREATE OBJECT go_container
        EXPORTING
          container_name = 'PDF'.

      CREATE OBJECT go_html
        EXPORTING
          parent = go_container.
    ENDIF.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING
        buffer     = i_content
      TABLES
        binary_tab = lt_data.

    "Load the HTML
    go_html->load_data(
      EXPORTING
        type                 = 'application'
        subtype              = 'pdf'
      IMPORTING
        assigned_url         = l_url
      CHANGING
        data_table           = lt_data
      EXCEPTIONS
        dp_invalid_parameter = 1
        dp_error_general     = 2
        cntl_error           = 3
        OTHERS               = 4 ).

    "Show
    go_html->show_url( url = l_url in_place = 'X' ).
  ENDFORM.                    "pdf_alv