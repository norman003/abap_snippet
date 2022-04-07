*--------------------------------------------------------------------*
* View - Set auditoria
*--------------------------------------------------------------------*
FORM u_view_updateaudi.
  FIELD-SYMBOLS: <fs_struct> TYPE any,
                 <fs>        TYPE any.

  ASSIGN <table1> TO <fs_struct>.

  ASSIGN COMPONENT 'ERDAT' OF STRUCTURE <fs_struct> TO <fs>.
  IF <fs> IS ASSIGNED.
    IF <fs> IS INITIAL.
      ASSIGN COMPONENT 'ERDAT' OF STRUCTURE <fs_struct> TO <fs>. IF sy-subrc = 0. <fs> = sy-datum. ENDIF.
      ASSIGN COMPONENT 'ERNAM' OF STRUCTURE <fs_struct> TO <fs>. IF sy-subrc = 0. <fs> = sy-uname. ENDIF.
      ASSIGN COMPONENT 'ERZET' OF STRUCTURE <fs_struct> TO <fs>. IF sy-subrc = 0. <fs> = sy-uzeit. ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.