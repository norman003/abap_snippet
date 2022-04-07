  DATA: l_cursor TYPE i,
        l_size   TYPE i VALUE 5000.
        
  OPEN CURSOR WITH HOLD l_cursor FOR
  SELECT mblnr mjahr zeile bwart ebeln matnr budat_mkpf charg
    FROM mseg
    CLIENT SPECIFIED
    BYPASSING BUFFER
    FOR ALL ENTRIES IN gt_mkpf
    WHERE mandt = sy-mandt
      AND mblnr = gt_mkpf-mblnr
      AND mjahr = gt_mkpf-mjahr
      AND zeile IN lr_zeile
      AND bwart = 101.
  WHILE l_cursor IS NOT INITIAL.
    FETCH NEXT CURSOR l_cursor APPENDING TABLE gt_mseg PACKAGE SIZE l_size.
    IF sy-subrc <> 0.
      CLOSE CURSOR l_cursor.
      EXIT.
    ENDIF.
  ENDWHILE.

  DESCRIBE TABLE ldt_ekko LINES g_lines.
  LOOP AT ldt_ekko ASSIGNING <lwa_ekko>.
    ADD 1 TO g_count.
    ADD 1 TO g_total.
    ls_ebeln-low = ''.
    APPEND ls_ebeln TO lr_ebeln.

    IF g_count  EQ '10000' OR g_total EQ g_lines.
      SELECT *
      APPENDING CORRESPONDING FIELDS OF TABLE gt_ekpo_aux
      FROM ekpo
      FOR ALL ENTRIES IN gdt_marc_ini
      WHERE ebeln IN lr_ebeln[]
        AND matnr EQ gdt_marc_ini-matnr
        AND werks EQ gdt_marc_ini-werks
        AND pstyp EQ p_pstyp
        AND loekz EQ space
        AND retpo EQ space.
      CLEAR: lr_ebeln, g_count.
    ENDIF.
  ENDLOOP.