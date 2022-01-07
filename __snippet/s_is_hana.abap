DATA: l_hana TYPE xfeld.

SELECT COUNT(*) FROM cvers WHERE component = 'S4CORE'.
IF sy-subrc = 0.
  l_hana = abap_on.
ENDIF.