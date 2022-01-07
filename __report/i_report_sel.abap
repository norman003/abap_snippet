**----------------------------------------------------------------------*
** INFOTIPOS
**----------------------------------------------------------------------*
**INFOTYPES: 0001, 0002, 9006.
**
*----------------------------------------------------------------------*
* TYPES
*----------------------------------------------------------------------*
TYPES: BEGIN OF gty_param,
         bukrs   TYPE rbkp-bukrs,
**         belnr   TYPE rbkp-belnr,
**         gjahr   TYPE rbkp-gjahr,
**
         r_bukrs TYPE RANGE OF gty_param-bukrs,
**         r_belnr TYPE RANGE OF gty_param-belnr,
**         r_gjahr TYPE RANGE OF gty_param-gjahr,
**         pend    TYPE xfeld,
       END OF gty_param.
DATA: ls_param TYPE gty_param.

***----------------------------------------------------------------------*
*** TOOLBAR
***----------------------------------------------------------------------*
**TABLES: sscrfields.
**SELECTION-SCREEN FUNCTION KEY 1.

*----------------------------------------------------------------------*
* SELECTION-SCREEN
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01. "Parámetros de Selección
SELECT-OPTIONS: s_bukrs FOR ls_param-bukrs MEMORY ID buk OBLIGATORY.
**                s_belnr FOR ls_param-belnr,
**                s_gjahr FOR ls_param-gjahr MEMORY ID gjr OBLIGATORY MATCHCODE OBJECT user_comp.
**PARAMETERS: p_pend TYPE xfeld DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK b1.

**SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-b02.
**SELECTION-SCREEN END OF BLOCK b2.
**
**FI
**PARAMETERS: p_bukrs type ty_param-bukrs OBLIGATORY MEMORY ID buk.
**PARAMETERS: p_kunnr TYPE ty_param-kunnr OBLIGATORY MEMORY ID lif.
**
**MM
**SELECT-OPTIONS: s_ebeln FOR ls_param-ebeln OBLIGATORY.
**
**DIR
**PARAMETERS: p_dir  TYPE localfile OBLIGATORY DEFAULT 'C:\'.
**PARAMETERS: p_test AS CHECKBOX.
**
**ABAP
**PARAMETERS: r_new RADIOBUTTON GROUP r1 DEFAULT 'X' USER-COMMAND b01,
**            r_old RADIOBUTTON GROUP r1.
**PARAMETERS: p_gjahr TYPE ty_param-gjahr MODIF ID b01 DEFAULT sy-datum(4).

***----------------------------------------------------------------------*
*** F4
***----------------------------------------------------------------------*
**"AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dir.
**  "PERFORM u_f4_dir USING p_dir.
**
***----------------------------------------------------------------------*
*** SCREEN OUTPUT
***----------------------------------------------------------------------*
**AT SELECTION-SCREEN OUTPUT.
**  PERFORM 1000_output.
**
***----------------------------------------------------------------------*
*** 1000 Output
***----------------------------------------------------------------------*
**FORM 1000_output.
**  DATA: l_active TYPE i.
**
**  "CASE abap_on.
**  "  WHEN r_old. l_active = 1. "Mostrar Param.
**  "  WHEN r_new. l_active = 0. "Ocultar Param.
**  "ENDCASE.
**  LOOP AT screen.
**    IF screen-group1 EQ 'B02'.
**      screen-active = l_active.
**      MODIFY screen.
**    ENDIF.
**  ENDLOOP.
**ENDFORM.
**
***----------------------------------------------------------------------*
*** SELECTION-SCREEN
***----------------------------------------------------------------------*
**AT SELECTION-SCREEN.
**  PERFORM 1000_uc.
**
**FORM inicializa.
**  DATA: ls_boton TYPE smp_dyntxt.
**
**  ls_boton-icon_id   = icon_system_copy.
**  ls_boton-icon_text = 'Mant. Config. Vehicular'.
**  sscrfields-functxt_01 = ls_boton. "'Mant. Config. Vehicular'
**ENDFORM.
**
***----------------------------------------------------------------------*
*** 1000 UC
***----------------------------------------------------------------------*
**FORM 1000_uc.
**  CASE sy-ucomm.
**    WHEN 'FC01'.
**    WHEN OTHERS.
**  ENDCASE.
**ENDFORM.