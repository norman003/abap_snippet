CLASS lcl_process DEFINITION DEFERRED.
DATA: go_process TYPE REF TO lcl_process.

CLASS lcl_process DEFINITION.
  PUBLIC SECTION.
    "Tipos
    "Data
    CLASS-DATA: BEGIN OF zconst,
                  r_bukrs TYPE RANGE OF bukrs,
                END OF zconst.

    "Metodos
    METHODS a10_accion EXCEPTIONS error.

  PRIVATE SECTION.
    METHODS inicializa EXCEPTIONS error.
    METHODS a10_valida EXCEPTIONS error.
ENDCLASS.

CLASS lcl_process IMPLEMENTATION.
  METHOD inicializa.
    DATA: lt_const TYPE TABLE OF zostb_constantes,
          ls_const LIKE LINE OF lt_const,
          l_string TYPE string,
          l_active TYPE xfeld.

    "Active
    zosge_utilities=>validar_ampliacion( EXPORTING i_modulo = 'SD' i_repid = sy-repid CHANGING c_activo = l_active ).
    IF l_active IS INITIAL.
      RAISE error.
    ENDIF.

    "Get
    IF zconst IS INITIAL.
      SELECT * INTO TABLE lt_const FROM zostb_constantes
        WHERE aplicacion = 'AMPLIACION'
          AND programa   = sy-repid.

      "Read
      LOOP AT lt_const INTO ls_const.
        CONCATENATE ls_const-signo ls_const-opcion ls_const-valor1 INTO l_string.
        CASE ls_const-campo.
**          WHEN 'BUKRS'. APPEND l_string TO zconst-r_bukrs.
        ENDCASE.
      ENDLOOP.
    ENDIF.

**    "Mandatory
**    IF zconst-r_cilindraje IS INITIAL.
**      RAISE error.
**    ENDIF.
  ENDMETHOD.


  METHOD a10_valida.
    DATA: l_edicion  TYPE xfeld,
          l_sociedad TYPE xfeld.

    "Inicializa
    inicializa( EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

    "Edicion
**    IF trtyp <> 'A'. "View exclude
**      l_edicion = abap_on.
**    ENDIF.
**    IF <godynpro>-action IN zconst-action AND
**       <godynpro>-refdoc IN zconst-refdoc.
**      l_edicion = abap_on.
**    ENDIF.

    "Sociedad
**    ls_head = im_header->get_data( ).
**    IF ls_head-bukrs IN zconst-r_bukrs.
**      l_sociedad = abap_on.
**    ENDIF.

    "Resultado
    IF l_edicion = abap_off OR l_sociedad = abap_off.
      RAISE error.
    ENDIF.
  ENDMETHOD.


  METHOD a10_accion.
**    DATA: ls_item TYPE mepoitem.

    "Valida
    a10_valida( EXCEPTIONS error = 1 ).
    IF sy-subrc <> 0.
      RAISE error.
    ENDIF.

**    ls_item = co_item->get_data( ).
**
**    "Si ingresa pedido obtener referencia
**    IF ls_item-zzvbeln IS NOT INITIAL AND ls_item-zzihrez_e IS INITIAL.
**      SELECT SINGLE ihrez_e INTO ls_item-zzihrez_e FROM vbkd WHERE vbeln = ls_item-zzvbeln.
**    ENDIF.
**
**    "Si ingresa referencia obtener pedido
**    IF ls_item-zzvbeln IS INITIAL AND ls_item-zzihrez_e IS NOT INITIAL.
**      SELECT SINGLE vbeln INTO ls_item-zzvbeln FROM vbkd WHERE ihrez_e = ls_item-zzihrez_e.
**    ENDIF.
  ENDMETHOD.
ENDCLASS.