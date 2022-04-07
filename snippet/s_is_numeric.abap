
  CALL FUNCTION 'NUMERIC_CHECK'

  IF var CO '0123456789'.
    "var is numeric.
  ELSE.
    "non numeric.
  ENDIF.
  
  DATA l_lenght type i.
  
  "Validar que no es numerico
  l_lenght = strlen( i_data ).
  DO l_lenght TIMES.
    SUBTRACT 1 FROM l_lenght.
    IF i_data+l_lenght(1) NA '0123456789'.
      "no es numerico
    ENDIF.
  ENDDO.
