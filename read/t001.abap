      SELECT * INTO TABLE @DATA(ltt001) FROM t001 WHERE bukrs = @zparam-bukrs.
      
      read table ltt001 ASSIGNING FIELD-SYMBOL(<fs_t001>) with key bukrs = <fs_det>-bukrs BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_det>-butxt = <fs_t001>-butxt.
      ENDIF.