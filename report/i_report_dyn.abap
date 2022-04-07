*----------------------------------------------------------------------*
* Status
*----------------------------------------------------------------------*
MODULE status OUTPUT.
  SET PF-STATUS 'ST100'.
  SET TITLEBAR 'TI100'.

**  go_report->refresh( ).
ENDMODULE.

*----------------------------------------------------------------------*
* User command
*----------------------------------------------------------------------*
MODULE user_command INPUT.
  CASE sy-ucomm.
    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
      SET SCREEN 0.
      LEAVE SCREEN.
**    WHEN 'SAVE'.
  ENDCASE.
ENDMODULE.