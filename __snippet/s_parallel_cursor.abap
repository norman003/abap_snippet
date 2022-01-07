*----------------------------------------------------------------------*
* Read Table - Lectura parallel cursor
*----------------------------------------------------------------------*
DATA l_while TYPE i.

"More velocity parallel cursor
READ TABLE lt_cobrb INTO ls_cobrb WITH TABLE KEY objnr = object_tab-objnr.
WHILE sy-subrc = 0.
  l_while = sy-tabix + 1.
  "
  READ TABLE lt_cobrb INTO ls_cobrb INDEX l_while COMPARING objnr.
ENDWHILE.