METHODS a_bapi_datax IMPORTING is_data TYPE any CHANGING cs_datax TYPE any.

*----------------------------------------------------------------------*
* Get bapi data x
*----------------------------------------------------------------------*
FORM u_bapi_datax USING is_data TYPE any 
                   CHANGING cs_datax TYPE any.
  METHOD a_bapi_datax.
    DATA: lo_struct  TYPE REF TO cl_abap_structdescr,
          lo_structx TYPE REF TO cl_abap_structdescr,
          ls_comps   LIKE LINE OF lo_struct->components,
          ls_compsx  LIKE LINE OF lo_struct->components.

    FIELD-SYMBOLS: <fs_campo>  TYPE any,
                   <fs_campox> TYPE any.

    lo_struct ?= cl_abap_structdescr=>describe_by_data( is_data ).
    lo_structx ?= cl_abap_structdescr=>describe_by_data( cs_datax ).

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
ENDFORM.