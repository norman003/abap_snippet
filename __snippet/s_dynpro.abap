**********************************************************************
* Dynpro - Ejemplo 100
**********************************************************************
PROCESS BEFORE OUTPUT.
  MODULE gtc_rend_change_tc_attr.
  LOOP AT gt_rend INTO gs_rend WITH CONTROL gtc_rend CURSOR gtc_rend-current_line.
    MODULE 100_inicializa.
  ENDLOOP.
*  MODULE status.
*  MODULE set_cursor.

PROCESS AFTER INPUT.
  LOOP AT gt_rend.
    chain.
      field gs_rend-withc. "Ind.Retencion
      field gs_rend-s_dobsr-obstx.
      MODULE gtc_rend_modify ON CHAIN-REQUEST.
    endchain.
    chain.
      field gs_rend-lifnr.
      MODULE gtc_lifnr_modify ON CHAIN-REQUEST.
    endchain.
  ENDLOOP.
  MODULE user_command.

PROCESS ON VALUE-REQUEST.
  field gs_rend-withc module help_withc.

**********************************************************************
* PAI-PBO
**********************************************************************
MODULE gtc_rend_change_tc_attr OUTPUT.
  DESCRIBE TABLE gt_rend LINES gtc_rend-lines.
ENDMODULE.
MODULE 100_inicializa.
  PERFORM 100_inicializa.
ENDMODULE.

FORM 100_inicializa.
  LOOP AT SCREEN.    
    "Validación por grupo 
    IF screen-group1 EQ 'EDI' AND screen-group2 EQ '001'.
      screen-input = 0.
    ELSE.
      screen-input = 1.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDFORM.

MODULE user_command_0100 INPUT.
  ok_code = sy-ucomm. 
  CLEAR sy-ucomm.

  CASE ok_code.
    WHEN 'BACK' OR 'EXIT' OR 'CANCEL'.
      SET SCREEN 0.
      LEAVE SCREEN.
  ENDCASE.
ENDMODULE.