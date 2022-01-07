  "Se implemento en modasa mlit=106m mlpp=125m mlhd=18m se bajo de 10h a 10m
  LOOP AT lt_ ASSIGNING <fs_>.
    ADD 1 TO l_count.
    ls_filtro-low = <fs_>
    APPEND ls_filtro TO lr_filtro.
    AT LAST. l_count = 9999. ENDAT.
    IF l_count > 9900.
      CLEAR: l_count, lr_filtro.
    ENDIF.
  ENDLOOP.