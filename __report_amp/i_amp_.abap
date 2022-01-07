*----------------------------------------------------------------------*
*                         INFORMACION GENERAL
*----------------------------------------------------------------------*
* Modulo      : 
* Descripcion : 
* Ticket      : Omnia Solution SAC
* Autor       : Norman Tinco
* Fecha       : 
*----------------------------------------------------------------------*
REPORT  MESSAGE-ID .

INCLUDE _c01.
DATA: amp_a TYPE REF TO zcl_amp_a.

*----------------------------------------------------------------------*
* Fuente : Badi  - ME_PROCESS_PO_CUST-CHECK
* Proceso: ME22N - Validar pedidos con entrada de mercancia
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Fuente : Uexit - EXIT_SAPLCOIH_009Z
* Proceso: IW31  - Validar centro de costo de orden
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Fuente : Enha  - EXIT_SAPLCOIH_009Z
* Proceso: IW31  - Validar centro de costo de orden
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Fuente : BTE  - SAMPLE_INTERFACE_00001025
* Proceso: IDCP - Replicar cantidad,um para nc importe cero
*----------------------------------------------------------------------*
**********************************************************************
* Process A:  Set,Check fecha de caducidad, fabricacion obligatorio
* Tcode:      MIGO(R05),MF60
*             101 & ZEMB,ZENV,ZINS & ZNAL,ZIMP & a1,a2,v1,v2
**********************************************************************
*====================================================================*
* Fuente : MIGO
*====================================================================*
*--------------------------------------------------------------------*
* Proceso: Set fecha de caducidad - A10
*--------------------------------------------------------------------*
FORM a10_tcode_proceso USING .
  CREATE OBJECT amp_a.
<<<<<<< HEAD:__report_amp/i_amp_.abap
  amp_a->accion_a10( EXCEPTIONS error = 1 ).
=======
  a00->accion_a10( EXCEPTIONS error = 1 ).
>>>>>>> bc5e8a90cd892da5d68e80132fdd3ab2364bfea4:_include/i_amp_.txt
ENDFORM.

**FORM ampdyn01a_tcode_proceso USING .
**ENDFORM.