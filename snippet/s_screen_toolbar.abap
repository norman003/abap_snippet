TABLES: sscrfields.

SELECTION-SCREEN FUNCTION KEY 1.

AT SELECTION-SCREEN.
  PERFORM sel_screen_toolbar_uc.

FORM sel_screen_toolbar_ini.
  DATA: ls_boton TYPE smp_dyntxt.

  CLEAR ls_boton.
  ls_boton-icon_id    = icon_system_copy.
  ls_boton-icon_text  = ''.
  ls_boton-quickinfo  = 'Copiar parametros'.
  sscrfields-functxt_01 = ls_boton.
ENDFORM.

FORM sel_screen_toolbar_uc.
  CASE sscrfields-ucomm.
    WHEN 'FC01'.
  ENDCASE.
ENDFORM.