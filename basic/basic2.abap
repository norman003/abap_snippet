*----------------------------------------------------------------------*
*clipboard
*----------------------------------------------------------------------*
DATA: lt TYPE tchar255.
cl_gui_frontend_services=>clipboard_import( IMPORTING data = lt ). CHECK lt IS NOT INITIAL.