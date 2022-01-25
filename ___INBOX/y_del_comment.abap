REPORT ydelete_line_comment.
TYPES: BEGIN OF line, line TYPE c LENGTH 500, END OF line.
DATA lt TYPE TABLE OF line.
DATA lsubrc TYPE i.
DATA char TYPE char50.
FIELD-SYMBOLS <fs> LIKE LINE OF lt.
cl_gui_frontend_services=>clipboard_import( IMPORTING data = lt ). CHECK lt IS NOT INITIAL.
LOOP AT lt ASSIGNING <fs>.
  char = <fs>. CONDENSE char.
  IF <fs>(1) = '*' OR char(1) = '"'.
    <Fs> = 1. condense <fs>.
  ENDIF.
ENDLOOP.
delete lt WHERE line = '1'.
cl_gui_frontend_services=>clipboard_export( IMPORTING data = lt CHANGING rc = lsubrc ).