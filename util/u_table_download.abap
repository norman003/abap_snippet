*----------------------------------------------------------------------*
* Table - Download
*----------------------------------------------------------------------*
FORM downtab USING i_append TYPE clike
                   i_header TYPE clike
                   is_line  TYPE any
                   i_dir    TYPE clike
                   it_table TYPE STANDARD TABLE.
  DATA l_file TYPE string.

  l_file = i_dir.
  IF i_header IS NOT INITIAL.
    DATA: lo_tab  TYPE REF TO data,
          lo_line TYPE REF TO data,
          l_tabix TYPE char03,
          lt_fcat TYPE lvc_t_fcat,
          ls_fcat TYPE lvc_s_fcat.
    FIELD-SYMBOLS: <ft_tab>  TYPE STANDARD TABLE,
                   <fs_line> TYPE any,
                   <fs>      TYPE any.

    "Crea una tabla de 500 columnas para guardar titulos de tablas
    DO 500 TIMES.
      ls_fcat-col_pos = l_tabix = sy-tabix. CONDENSE l_tabix.
      CONCATENATE 'F' l_tabix INTO ls_fcat-fieldname.
      ls_fcat-datatype = 'CHAR'.
      ls_fcat-intlen   = '500'.
      APPEND ls_fcat TO lt_fcat.
    ENDDO.
    CALL METHOD clulv_table_create=>create_dynamic_table
      EXPORTING
        it_fieldcatalog = lt_fcat
      IMPORTING
        ep_table        = lo_tab.
    ASSIGN lo_tab->* TO <ft_tab>.
    CREATE DATA lo_line LIKE LINE OF <ft_tab>.
    ASSIGN lo_line->* TO <fs_line>.

    "1ra fila = nombre de campo & descripción de campo
    DATA: lo_type TYPE REF TO clubap_structdescr,
          lt_comp TYPE abap_compdescr_tab,
          ls_comp LIKE LINE OF lt_comp.
    lo_type ?= clubap_structdescr=>describe_by_data( is_line ).
    lt_comp = lo_type->components.
    LOOP AT lt_comp INTO ls_comp.
      "1 name del campo
      IF <fs> IS NOT ASSIGNED. ASSIGN COMPONENT 1 OF STRUCTURE <fs_line> TO <fs>. ENDIF.
      <fs> = ls_comp-name.
      APPEND <fs_line> TO <ft_tab>.
    ENDLOOP.

    cl_gui_frontend_services=>gui_download(
      EXPORTING
        filename                  = l_file
        filetype                  = 'ASC'
        codepage                  = '4110'           "utf8
        "dat_mode                  = 'X'
        write_field_separator     = 'X'
        fieldnames                = <ft_tab>
        append                    = i_append
      CHANGING
        data_tab                  = it_table
        ).
  ELSE.
    cl_gui_frontend_services=>gui_download(
      EXPORTING
        filename                  = l_file
        filetype                  = 'ASC'
        codepage                  = '4110'           "utf8
        "dat_mode                  = 'X'
        write_field_separator     = 'X'
        append                    = i_append
      CHANGING
        data_tab                  = it_table
        ).
  ENDIF.
ENDFORM.                    "_downtable