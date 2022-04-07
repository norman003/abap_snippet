*----------------------------------------------------------------------*
* Alv - Get data filtrered
*----------------------------------------------------------------------*
FORM u_alv_getfiltered USING io_alv TYPE REF TO cl_gui_alv_grid
                              it_data TYPE STANDARD TABLE
                        CHANGING rt_data TYPE STANDARD TABLE.

  DATA: lt_fil TYPE lvc_t_fidx,
        ls_fil LIKE LINE OF lt_fil,
        l_tabix TYPE i,
        l_subrc TYPE i.
  FIELD-SYMBOLS: <fs_data> TYPE any.


  io_alv->get_filtered_entries( IMPORTING et_filtered_entries = lt_fil ).  
  LOOP AT it_data ASSIGNING <fs_data>.
    IF lt_fil IS NOT INITIAL.
      l_subrc = 1.
      l_tabix = sy-tabix.

      LOOP AT lt_fil INTO ls_fil.
        IF ls_fil = l_tabix.
          l_subrc = 0.
        ENDIF.
      ENDLOOP.
      IF l_subrc <> 0.
        APPEND it_data TO rt_data.
      ENDIF.
    ELSE.
      APPEND it_data TO rt_data.
    ENDIF.
  ENDLOOP.

ENDFORM.