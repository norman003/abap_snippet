*&---------------------------------------------------------------------*
*& Report YNO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT yno.

START-OF-SELECTION.
  PERFORM get_source USING 'X' ' ' ' ' 'YMT'. "report
*  PERFORM get_source USING ' ' 'X' ' ' 'ZCL_UTIL'. "Class
*  PERFORM get_source USING ' ' ' ' 'X' 'READ_IBAN_EXT'. "fm

FORM get_source USING u_prog TYPE boolean
                      u_class TYPE boolean
                      u_fm TYPE boolean
                      u_name TYPE string.

  DATA abap_editor TYPE REF TO cl_wb_pgeditor.
  DATA source_tab TYPE sedi_source.
  DATA source_name TYPE sy-repid.
  DATA lv_count TYPE string.

  CASE 'X'.
    WHEN u_prog.
      source_name = u_name.
      IF source_name IS NOT INITIAL.
        CREATE OBJECT abap_editor
          EXPORTING
            p_is_in_adjustment_mode = ' '.
        CALL METHOD abap_editor->read_source
          EXPORTING
            source_name             = source_name
            initialize_edit_control = ' '
            status                  = ' '
            with_impl_enhancements  = ' '
            single_enhname          = ' '
          IMPORTING
            source_tab              = source_tab
          EXCEPTIONS
            not_found               = 1
            cancelled               = 2
            read_protected          = 3.

        abap_editor->change_mode( ).
        delete source_tab INDEX 2.
        abap_editor->set_old_source( source_tab = source_tab ).
        abap_editor->save_source( ).
        lv_count = lines( source_tab ).
        WRITE : / lv_count.
        REFRESH source_tab[].
      ENDIF.

    WHEN u_class.
      DATA clskey TYPE seoclskey.
      DATA includes TYPE seop_methods_w_include.
      DATA ls_includes LIKE LINE OF includes.
      clskey = u_name.
      CALL FUNCTION 'SEO_CLASS_GET_METHOD_INCLUDES'
        EXPORTING
          clskey                       = clskey
        IMPORTING
          includes                     = includes
        EXCEPTIONS
          _internal_class_not_existing = 1.

      CASE sy-subrc.
        WHEN 0.
          LOOP AT includes INTO ls_includes.
            source_name = ls_includes-incname.
            IF source_name IS NOT INITIAL.
              CREATE OBJECT abap_editor
                EXPORTING
                  p_is_in_adjustment_mode = ' '.
              CALL METHOD abap_editor->read_source
                EXPORTING
                  source_name             = source_name
                  initialize_edit_control = ' '
                  status                  = ' '
                  with_impl_enhancements  = ' '
                  single_enhname          = ' '
                IMPORTING
                  source_tab              = source_tab
                EXCEPTIONS
                  not_found               = 1
                  cancelled               = 2
                  read_protected          = 3.

              lv_count = lines( source_tab ).
              WRITE : / lv_count.
              REFRESH source_tab[].
            ENDIF.
          ENDLOOP.
      ENDCASE.
    WHEN u_fm.
      DATA funcname TYPE rs38l-name.
      DATA r3state TYPE d010sinf-r3state.
      DATA ptfdir TYPE STANDARD TABLE OF tfdir.
      DATA ptftit TYPE STANDARD TABLE OF tftit.
      DATA pfunct TYPE STANDARD TABLE OF funct.
      DATA penlfdir TYPE STANDARD TABLE OF enlfdir.
      DATA ptrdir TYPE STANDARD TABLE OF trdir.
      DATA ls_ptrdir LIKE LINE OF ptrdir.
      DATA pfupararef TYPE STANDARD TABLE OF sfupararef.
      DATA uincl TYPE STANDARD TABLE OF abaptxt255.

      funcname = u_name.
      CALL FUNCTION 'FUNC_GET_OBJECT'
        EXPORTING
          funcname           = funcname
*         R3STATE            = 'A'
        TABLES
          ptfdir             = ptfdir
          ptftit             = ptftit
          pfunct             = pfunct
          penlfdir           = penlfdir
          ptrdir             = ptrdir
          pfupararef         = pfupararef
          uincl              = uincl
        EXCEPTIONS
          function_not_exist = 1
          version_not_found  = 2.

      CASE sy-subrc.
        WHEN 0.
          READ TABLE ptrdir INTO ls_ptrdir INDEX 1.
          CASE sy-subrc.
            WHEN 0.
              IF ls_ptrdir-name IS NOT INITIAL.
                source_name = ls_ptrdir-name.
                IF source_name IS NOT INITIAL.
                  CREATE OBJECT abap_editor
                    EXPORTING
                      p_is_in_adjustment_mode = ' '.

                  CALL METHOD abap_editor->read_source
                    EXPORTING
                      source_name             = source_name
                      initialize_edit_control = ' '
                      status                  = ' '
                      with_impl_enhancements  = ' '
                      single_enhname          = ' '
                    IMPORTING
                      source_tab              = source_tab
                    EXCEPTIONS
                      not_found               = 1
                      cancelled               = 2
                      read_protected          = 3.

                  lv_count = lines( source_tab ).

                  WRITE : / lv_count."Print lines of souce code with enahncement lines as well
                  REFRESH source_tab[].
                ENDIF.
              ENDIF.
          ENDCASE.
      ENDCASE.
  ENDCASE.
ENDFORM. "get_source