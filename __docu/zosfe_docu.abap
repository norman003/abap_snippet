"32 AllowanceTotalAmount Monto total de descuentos del comprobante
        CONCATENATE '{"0":"' lv_desctotot  '",' ;suma de descuentos item + global
                    '"1":"'  lv_desctoxite '",' ;suma de descuentos item                            para total descuento PDF
                    '"2":"'  lv_desctoglob '",' ;suma de descuentos global                          para descto global PDF
                    '"3":"'  lv_desctotot_sabi '",' ;suma de descuento item SABI + global SABI
                    '"4":"'  lv_desctotot_nabi '"}' ;suma de descuento item NABI + global NABI para informar a sunat
      ENDIF.

      "33 ChargeTotalAmount    Monto total de otros cargos del comprobante
      CONCATENATE '{"0":"' lv_cargostot  '",'
                  '"1":"'  lv_cargosxite '",'
                  '"2":"'  lv_cargosglob '",'     ;suma de cargos global                          para otros cargos PDF
                  '"3":"'  lv_cargostot_sabi '",'
                  '"4":"'  lv_cargostot_nabi '"}'