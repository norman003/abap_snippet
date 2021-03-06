REPORT ym_screen_events.

DATA field1(10) TYPE c.
DATA lt TYPE TABLE OF string.

SELECT-OPTIONS sel_opt1 FOR field1.
SELECTION-SCREEN BEGIN OF BLOCK block1.
PARAMETERS: test1(10) TYPE c,
            test2(10) TYPE c.
SELECTION-SCREEN END OF BLOCK block1.

PARAMETERS: r1 RADIOBUTTON GROUP rad1 DEFAULT 'X',
            r2 RADIOBUTTON GROUP rad1.

"1. INICIALIZA
AT SELECTION-SCREEN OUTPUT.
  APPEND 'AT SELECTION-SCREEN OUTPUT' TO lt.

"2. F8
AT SELECTION-SCREEN ON sel_opt1.
  APPEND 'AT SELECTION-SCREEN ON SEL_OPT1' TO lt.
AT SELECTION-SCREEN ON test1.
  APPEND 'AT SELECTION-SCREEN ON TEST1' TO lt.
AT SELECTION-SCREEN ON test2.
  APPEND 'AT SELECTION-SCREEN ON TEST2' TO lt.
AT SELECTION-SCREEN ON BLOCK block1.
  APPEND 'AT SELECTION-SCREEN ON BLOCK BLOCK1' TO lt.
AT SELECTION-SCREEN ON RADIOBUTTON GROUP rad1.
  APPEND 'AT SELECTION-SCREEN ON RADIOBUTTON GROUP RAD1' TO lt.
AT SELECTION-SCREEN.
  APPEND 'AT SELECTION-SCREEN' TO lt.
  
AT SELECTION-SCREEN ON VALUE-REQUEST FOR sel_opt1-low.
  APPEND 'AT SELECTION-SCREEN ON VALUE-REQUEST FOR SEL_OPT1-LOW' TO lt.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR sel_opt1-high.
  APPEND 'AT SELECTION-SCREEN ON VALUE-REQUEST FOR SEL_OPT1-HIGH' TO lt.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR test1.
  APPEND 'AT SELECTION-SCREEN ON VALUE-REQUEST FOR TEST1' TO lt.
AT SELECTION-SCREEN ON VALUE-REQUEST FOR test2.
  APPEND 'AT SELECTION-SCREEN ON VALUE-REQUEST FOR TEST2' TO lt.
  
AT SELECTION-SCREEN ON END OF sel_opt1.
  APPEND 'AT SELECTION-SCREEN ON END OF SEL_OPT1' TO lt.

INITIALIZATION.

START-OF-SELECTION.
  BREAK-POINT.

"START
" AT SELECTION-SCREEN OUTPUT
"F8
" AT SELECTION-SCREEN ON SEL_OPT1
" AT SELECTION-SCREEN ON TEST1
" AT SELECTION-SCREEN ON TEST2
" AT SELECTION-SCREEN ON BLOCK BLOCK1
" AT SELECTION-SCREEN ON RADIOBUTTON GROUP RAD1
" AT SELECTION-SCREEN

SET CURSOR FIELD 'P_SUPRE'.