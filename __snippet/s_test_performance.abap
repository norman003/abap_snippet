DATA ran TYPE TABLE OF i WITH HEADER LINE.
DEFINE ran.
  DATA next TYPE i.
  IMPORT next = next FROM MEMORY ID 'NEXT'. "Mientras no salgas de se38 no se borra la memoria
  IF next = 6. next = 0. ENDIF.
  ADD 1 TO next.
  CASE next.
    WHEN 1. APPEND 1 TO ran. APPEND 2 TO ran. APPEND 3 TO ran.
    WHEN 2. APPEND 2 TO ran. APPEND 3 TO ran. APPEND 1 TO ran.
    WHEN 3. APPEND 3 TO ran. APPEND 1 TO ran. APPEND 2 TO ran.
    WHEN 4. APPEND 2 TO ran. APPEND 1 TO ran. APPEND 3 TO ran.
    WHEN 5. APPEND 3 TO ran. APPEND 2 TO ran. APPEND 1 TO ran.
    WHEN 6. APPEND 1 TO ran. APPEND 3 TO ran. APPEND 2 TO ran.
  ENDCASE.
  EXPORT next = next TO MEMORY ID 'NEXT'.
END-OF-DEFINITION.

"Compara lineas de codigo
DATA: a TYPE timestampl,
      b TYPE timestampl,
      c TYPE string.
DEFINE time.
  IF c IS INITIAL. CALL FUNCTION 'SLIC_GET_LICENCE_NUMBER' IMPORTING license_number = c. WRITE:/ 'license', 23 c. ENDIF.
  IF a IS INITIAL. GET TIME STAMP FIELD a. ELSE. GET TIME STAMP FIELD b. c = b - a. CLEAR a. WRITE:/ &1, 25 c. ENDIF.
END-OF-DEFINITION.