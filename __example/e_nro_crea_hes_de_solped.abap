*----------------------------------------------------------------------*
* 0. Crear HES de solped
*----------------------------------------------------------------------*
  METHOD u_pro_crea_hes_de_solped.

    DATA: lo_ind    TYPE REF TO zosge_ind_progress,
          lt_report TYPE gtt_report.
    FIELD-SYMBOLS: <fs_report> LIKE LINE OF gt_report.



*   1. Seleccion
    READ TABLE gt_report WITH KEY box = abap_true TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      MESSAGE s000 WITH text-s01 RAISING error.
    ENDIF.

    zosge_utilities_1=>get_confirm(
      EXPORTING
        i_question = 'Desea Crear Hoja de Servicio'
      EXCEPTIONS
        cancel     = 1
    ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.


    "Indicador
    lt_report = gt_report.
    DELETE lt_report WHERE box IS INITIAL.
    CREATE OBJECT lo_ind EXPORTING it_table = lt_report.


*   2. Creación
    LOOP AT gt_report ASSIGNING <fs_report> WHERE box = abap_true.
      CLEAR <fs_report>-return.

      "Ind.
      lo_ind->show_progress( text1 = 'Orden:'
                             text2 = <fs_report>-aufnr ).


      "Construir texto de hoja de servicio
      PERFORM build_txz01 USING <fs_report>-ffin CHANGING zhessol-txz01.


      zospm_proceso_mhoe=>orden_crea_hessolped(
        EXPORTING
          is_report    = <fs_report>
          i_person_int = zhessol-sbnamag
          i_short_text = zhessol-txz01
          i_knttp      = zhessol-knttp
          i_dlort      = zhessol-dlort
        IMPORTING
          et_return    = <fs_report>-return
          e_lblni      = <fs_report>-lblni1
        EXCEPTIONS
          error        = 1
      ).
    ENDLOOP.


*   3. Resultado
    LOOP AT gt_report ASSIGNING <fs_report> WHERE box = abap_true.
      READ TABLE <fs_report>-return WITH KEY type = 'E' TRANSPORTING NO FIELDS.
      IF sy-subrc = 0.
        <fs_report>-icon = gc_red.
      ELSE.
        <fs_report>-icon = gc_green.
        MESSAGE s000 WITH text-s03.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.