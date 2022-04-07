*----------------------------------------------------------------------*
* Dynpro - Ejemplo help
*----------------------------------------------------------------------*
PROCESS BEFORE OUTPUT.
PROCESS AFTER INPUT.
PROCESS ON VALUE-REQUEST.
  FIELD gs_rc_mat-lgort MODULE f4_lgort.
  
MODULE help_lgort.
  PERFORM _help_lgort CHANGING gs_rc_mat-lgort.
ENDMODULE.