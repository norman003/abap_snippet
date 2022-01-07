  IF p_combaj EQ abap_true.

*    IF s_tipdoc[] IS INITIAL OR 'RA' IN s_tipdoc[].                     "E-WMR-230419-3000010823
    IF s_tipdoc[] IS INITIAL OR gc_combaj IN s_tipdoc[].                "I-WMR-230419-3000010823
      SELECT *
        APPENDING CORRESPONDING FIELDS OF TABLE lt_balog
        FROM zostb_balog
        WHERE bukrs            EQ p_bukrs
          AND zzt_identifibaja IN s_numero
          AND zzt_status_cdr   IN s_status
          AND zzt_fcreacion    IN s_fecha.

      LOOP AT lt_balog ASSIGNING <fs_balog>.
        APPEND INITIAL LINE TO gt_felog ASSIGNING <fs_felog>.
        MOVE-CORRESPONDING <fs_balog> TO <fs_felog>.
        <fs_felog>-zzt_numeracion = <fs_balog>-zzt_identifibaja.
        <fs_felog>-zzt_tipodoc    = gc_combaj.
      ENDLOOP.
    ENDIF.
  ENDIF.

*{  BEGIN OF INSERT WMR-190419-3000010823