*--------------------------------------------------------------------*
* Screen - set listbox
*--------------------------------------------------------------------*
FORM r_screen_listbox_set USING i_field TYPE clike.
  DATA: lt_value TYPE vrm_values,
        ls_value LIKE LINE OF lt_value.
  
  "Producción
  ls_value-text = 'Producto'.
  ls_value-key  = 'Test'.
  APPEND ls_value TO lt_value.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = i_field
      values          = lt_value
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.
ENDFORM.