*----------------------------------------------------------------------*
* Crear condición dinamica
*----------------------------------------------------------------------*
FORM generar_where  USING    pt_setleaf   TYPE  tt_setleaf
                    CHANGING pt_clause    TYPE  tt_clause.

  DATA: lt_set_values TYPE tt_set_values,
        lt_dyn_cond   TYPE tt_dyn_cond,
        lt_condtab    TYPE tt_condtab.

  DATA: lv_setnr           TYPE setid,
        lv_shortname       TYPE setnamenew,
        ls_header          TYPE rgsbs,         "I-NTP-110516
        lv_class           LIKE rgsbs-class,
        lv_table           TYPE tabname,
        lv_objet           TYPE j_obart,
        lv_bukrs           TYPE bukrs,
        lv_elemt           TYPE zosed_elem_costo,
        lv_id_detail       TYPE zosed_id_detail,
        lv_lines           TYPE i,
        lv_condition(1000) TYPE c.

  DATA: ls_condtab    TYPE ty_condtab,
        ls_clause     TYPE ty_clause,
        ls_setleaf    TYPE ty_setleaf,
        ls_set_values TYPE ty_set_values.

  REFRESH: lt_condtab, lt_dyn_cond, pt_clause, lt_set_values.

  SORT pt_setleaf BY bukrs          ASCENDING
                     elemt          ASCENDING
                     id_detail      ASCENDING
                     table setname  ASCENDING.

  LOOP AT pt_setleaf INTO ls_setleaf.
    IF lv_condition IS INITIAL.
      lv_condition = ls_setleaf-setname.
    ELSE.
      CONCATENATE ls_setleaf-setname lv_condition INTO lv_condition SEPARATED BY '_'.
    ENDIF.

    lv_shortname = ls_setleaf-setname.
    lv_table     = ls_setleaf-table.
    lv_objet     = ls_setleaf-objet.

    PERFORM obtener_valores_set   USING     lv_shortname
                                  CHANGING  ls_header                         "I-NTP-110516
                                            lt_set_values.
    "Permite realizar join
*    CONCATENATE ls_header-table '~' ls_setleaf-campo INTO ls_setleaf-campo. "I-NTP-110516
    CONCATENATE ls_header-table '~' ls_header-field INTO ls_setleaf-campo. "I-NTP-110516

    LOOP AT lt_set_values INTO ls_set_values.
      IF ls_set_values-from EQ ls_set_values-to.
        CLEAR ls_condtab.
        ls_condtab-field = ls_setleaf-campo.
*        ls_condtab-opera = 'EQ'.                                             "E-NTP-310516
        ls_condtab-low   = ls_set_values-from.
        APPEND  ls_condtab TO lt_condtab.
      ELSE.
        CLEAR ls_condtab.
        ls_condtab-field = ls_setleaf-campo.
*        ls_condtab-opera = 'BT'.                                             "E-NTP-310516
        ls_condtab-low   = ls_set_values-from.
        ls_condtab-high  = ls_set_values-to.
        APPEND  ls_condtab TO lt_condtab.
      ENDIF.
    ENDLOOP.

    AT END OF id_detail.
      IF lt_condtab[] IS NOT INITIAL.
        CLEAR ls_clause.

*BE-NTP-050516
*        CALL FUNCTION 'RH_DYNAMIC_WHERE_BUILD'
*          EXPORTING
*            dbtable         = space
*          TABLES
*            condtab         = lt_condtab
*            where_clause    = lt_dyn_cond
*          EXCEPTIONS
*            empty_condtab   = 1
*            no_db_field     = 2
*            unknown_db      = 3
*            wrong_condition = 4
*            OTHERS          = 5.
*        IF sy-subrc NE 0.
*          CONTINUE.
*        ENDIF.
*EE-NTP-050516
        PERFORM _build_condicion_dinamica USING lt_condtab CHANGING lt_dyn_cond. "R-NTP-050516

        DESCRIBE TABLE lt_dyn_cond LINES lv_lines.
        IF lv_lines GT 0.
          ls_clause-table     = lv_table.
          ls_clause-objet     = lv_objet.
          ls_clause-setname   = lv_condition.
          ls_clause-where     = lt_dyn_cond.
          ls_clause-elemt     = ls_setleaf-elemt.
          ls_clause-id_detail = ls_setleaf-id_detail.
          ls_clause-bukrs     = ls_setleaf-bukrs.
          APPEND ls_clause TO pt_clause.
        ENDIF.

        REFRESH: lt_dyn_cond, lt_condtab, lt_set_values.
        CLEAR: lv_condition, lv_table, lv_objet, lv_lines,
               lv_shortname.
      ENDIF.
    ENDAT.
  ENDLOOP.

  SORT pt_clause.
  DELETE ADJACENT DUPLICATES FROM pt_clause COMPARING ALL FIELDS.

ENDFORM.                    " GENERAR_WHERE

FORM _build_condicion_dinamica USING it_condtab TYPE tt_condtab
                              CHANGING et_dyn_cond TYPE tt_dyn_cond.

  DATA: lt_tab TYPE se16n_or_t,
        ls_tab TYPE se16n_or_seltab,
        ls_sel TYPE se16n_seltab.
  DATA: ls_condtab TYPE ty_condtab.

  LOOP AT it_condtab INTO ls_condtab.
    CLEAR ls_sel.
    ls_sel-field = ls_condtab-field.
    ls_sel-sign  = 'I'.
    ls_sel-low   = ls_condtab-low.
    ls_sel-high  = ls_condtab-high.
    APPEND ls_sel TO ls_tab-seltab.
  ENDLOOP.
  APPEND ls_tab TO lt_tab.

  CALL FUNCTION 'SE16N_CREATE_OR_SELTAB'
    TABLES
      it_or_seltab = lt_tab
      et_where     = et_dyn_cond.
ENDFORM.                    "_build_condicion_dinamica