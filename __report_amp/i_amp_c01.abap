CLASS zcl_amp_a DEFINITION.
  PUBLIC SECTION.
    "Tipos

    "Data
    DATA: BEGIN OF zamp,
            is_edicion TYPE xfeld,
            is_sociedad TYPE xfeld,
            is_active TYPE xfeld,

          END OF zamp.
    DATA: BEGIN OF zconst,
            f_active TYPE datum,

            r_bukrs  TYPE RANGE OF bukrs,
          END OF zconst.

    "Metodos
    METHODS inicializa EXCEPTIONS error.
    METHODS validacion EXCEPTIONS error.
    METHODS accion_a10 EXCEPTIONS error.
ENDCLASS.

CLASS zcl_amp_a IMPLEMENTATION.
*----------------------------------------------------------------------*
* Inicializa
*----------------------------------------------------------------------*
  METHOD inicializa.
    DATA: lt_const TYPE TABLE OF zostb_constantes,
          ls_const LIKE LINE OF lt_const,
          l_string TYPE string.

    "Get
    IMPORT zconst = zconst FROM MEMORY ID sy-repid.
    IF zconst IS INITIAL.
      SELECT * INTO TABLE lt_const FROM zostb_constantes
        WHERE aplicacion = 'AMPLIACION'
          AND programa   = sy-repid.

      "Read
      LOOP AT lt_const INTO ls_const.
        CONCATENATE ls_const-signo ls_const-opcion ls_const-valor1 INTO l_string.
        CASE ls_const-campo.
            "Fecha activa
          WHEN 'F_ACTIVE'.
            CONCATENATE ls_const-valor1+6(4)
                        ls_const-valor1+3(2)
                        ls_const-valor1+0(2) INTO zconst-f_active.
            "WHEN 'BUKRS'. APPEND l_string TO zconst-r_bukrs.
        ENDCASE.
      ENDLOOP.

      "Mandatory
*      IF zconst-r_bukrs IS INITIAL.
*        RAISE error.
*      ENDIF.
      EXPORT zconst = zconst TO MEMORY ID sy-repid.
    ENDIF.
  ENDMETHOD.

*---------------------------------------------------------------------*
* Inicializa
*---------------------------------------------------------------------*
  METHOD validacion.

    DATA: ls_head TYPE mepoheader.

    "Inicializa
    inicializa( EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "Edicion
*    IF trtyp <> 'A'. "View exclude
*      zamp-is_edicion = abap_on.
*    ENDIF.
*    IF <godynpro>-action IN zconst-action AND
*       <godynpro>-refdoc IN zconst-refdoc.
*      zamp-is_edicion = abap_on.
*    ENDIF.

    "Sociedad
*    ls_head = im_header->get_data( ).
*    IF ls_head-bukrs IN zconst-r_bukrs AND
*       ls_head-bsart IN zconst-r_bsart.
*      zamp-is_sociedad = abap_on.
*    ENDIF.

    "Fecha de activacion
    IF zconst-f_active <= sy-datum.
      zamp-is_active = abap_on.
    ENDIF.

    "Resultado
    IF zamp-is_edicion = abap_off OR zamp-is_sociedad = abap_off OR zamp-is_active = abap_off.
      RAISE error.
    ENDIF.

  ENDMETHOD.

*--------------------------------------------------------------------*
* Accion
*--------------------------------------------------------------------*
  METHOD accion_a10.

    DATA: ls_item TYPE mepoitem.

    "Valida
    validacion( EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

*    ls_item = co_item->get_data( ).

    "Si ingresa pedido obtener referencia
*    IF ls_item-zzvbeln IS NOT INITIAL AND ls_item-zzihrez_e IS INITIAL.
*      SELECT SINGLE ihrez_e INTO ls_item-zzihrez_e FROM vbkd WHERE vbeln = ls_item-zzvbeln.
*    ENDIF.

    "Si ingresa referencia obtener pedido
*    IF ls_item-zzvbeln IS INITIAL AND ls_item-zzihrez_e IS NOT INITIAL.
*      SELECT SINGLE vbeln INTO ls_item-zzvbeln FROM vbkd WHERE ihrez_e = ls_item-zzihrez_e.
*    ENDIF.

  ENDMETHOD.
ENDCLASS.