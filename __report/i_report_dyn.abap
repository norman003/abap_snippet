*----------------------------------------------------------------------*
* Status
*----------------------------------------------------------------------*
MODULE status_100 OUTPUT.
  SET PF-STATUS '100_ST'.
  SET TITLEBAR '100_TI'.
ENDMODULE.

*----------------------------------------------------------------------*
* User command
*----------------------------------------------------------------------*
MODULE user_command_100 INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      SET SCREEN 0.
      LEAVE SCREEN.
    WHEN 'SAVE'.
  ENDCASE.
ENDMODULE.