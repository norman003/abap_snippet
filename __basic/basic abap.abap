*----------------------------------------------------------------------*
*1.1 CHAR BASIC
*----------------------------------------------------------------------*
DATA: l_char  TYPE char30 VALUE 'TICKET 3000000129',
      l_char1 TYPE char30.

SEARCH l_char FOR '300'. "sy-fdpos = pos
CONCATENATE  'Hola Mundo' l_vbeln INTO l_char. "[SEPARATED BY space]. "Unir textos 
CONDENSE l_char. "[NO-GAPS].                                          "Borrar todos los espacios 
SPLIT l_char AT space INTO l_char l_char0000 "[1 ... cn].             "Cortar donde tenga space 
l_char1 = strlen( l_char ).                                           "Determinar tamaño de cadena 
SHIFT l_char BY 1 PLACES. "[BY 1 PLACES][{LEFT|RIGHT|CIRCULAR}].      "Desplazar texto

*----------------------------------------------------------------------*
*1.2 CHAR COMPARACION
*----------------------------------------------------------------------*
IF 'ABAB' CO 'ABCD'. ENDIF. "CO Contiene solo             CN no contiene solo 
IF 'ABCD' CS 'CD'.   ENDIF. "CS contiene algun fragmento  NS no contiene el fragmento 
IF 'ABCD' CA 'CV'.   ENDIF. "CA Contiene algún carácter   NA no contiene algun caracter 
IF 'ABCD' CP '++C*'. ENDIF. "CP Comodin sy-fdpos = 2      NP no contiene el comodin

*----------------------------------------------------------------------*
*1.3 CHAR CONVERTIR
*----------------------------------------------------------------------*
TRANSLATE l_char TO LOWER CASE.
TRANSLATE l_char TO UPPER CASE.

*----------------------------------------------------------------------*
*1.4 CHAR EXTRAER
*----------------------------------------------------------------------*
ls_afpo-charg      = '0063E009'.
ls_afpo-charg(3)   = '006'.
ls_afpo-charg+0(3) = '006'.
ls_afpo-charg+3    = '63E009'.

*----------------------------------------------------------------------*
*1.5 CHAR FECHA
*----------------------------------------------------------------------*
CONCATENATE fecha+6(4) fecha+3(2) fecha+0(2) INTO l_aaaammdd. "Fecha 6(4)-
3(2)-0(2) 
2.0000 CHAR REEMPLAZAR 
REPLACE 'TICKET' IN l_char WITH 'NEW'.                                "Reemplazar uno 
REPLACE ALL OCCURRENCES OF old IN var WITH new.                       "Reemplazar varios 
REPLACE SECTION OFFSET pos LENGTH lenght OF var WITH new.             "Reemplazar con posicion

*----------------------------------------------------------------------*
*1.6 IF OPERADORES
*----------------------------------------------------------------------*
IF l_char EQ ml_char0000 ENDIF.  "=  Igual a 
IF l_char NE l_char0000 ENDIF.  "<> Distinto de 
IF l_char GT l_char0000 ENDIF.  ">  Mayor que 
IF l_char LT l_char0000 ENDIF.  "<  Menor de 
IF l_char GE l_char0000 ENDIF.  ">= Mayor o igual a 
IF l_char LE l_char0000 ENDIF.  "<= Menor o igual a

*----------------------------------------------------------------------*
*1.7 LOOP
*----------------------------------------------------------------------*
LOOP AT tabla.
  AT FIRST. ENDAT.        "AT FIRST una vez y al principio de un loop
  AT NEW campo. ENDAT.    "AT NEW   cuando los primeros campos de la tabla
  AT END OF campo. ENDAT. "AT END   cuando los primeros campo de la tabla
  AT LAST. ENDAT.         "AT LAST  una vez y al final de un loop
ENDLOOP.

*----------------------------------------------------------------------*
*1.8 NUMEROS
*----------------------------------------------------------------------*
DATA: l_var TYPE dmbtr VALUE '-100.49',
      l_res TYPE dmbtr.

l_res = l_var MOD l_var.  "toma el resto
l_res = ABS( l_var ).     "valor absoluto
l_res = SIGN( l_var ).    "devuelve 1 si > 0, 0 si = 0, -1 si < 0
l_res = FLOOR( l_var ).   "redondea para arriba
l_res = CEIL( l_var ).    "redondea para abajo
l_res = TRUNC( l_var ).   "toma la parte entera
l_res = FRAC( l_var ).    "toma la parte decimal