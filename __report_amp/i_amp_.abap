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

**----------------------------------------------------------------------*
** Source  : Badi  - ME_PROCESS_PO_CUST-CHECK
** Activity: ME22N - Validar pedidos con entrada de mercancia
**----------------------------------------------------------------------*
**----------------------------------------------------------------------*
** Source  : Uexit - EXIT_SAPLCOIH_009Z
** Activity: IW31  - Validar centro de costo de orden
**----------------------------------------------------------------------*
**----------------------------------------------------------------------*
** Source  : Enha  - EXIT_SAPLCOIH_009Z
** Activity: IW31  - Validar centro de costo de orden
**----------------------------------------------------------------------*
**----------------------------------------------------------------------*
** Source  : BTE  - SAMPLE_INTERFACE_00001025
** Activity: IDCP - Replicar cantidad,um para nc importe cero
**----------------------------------------------------------------------*

**********************************************************************
* Process A:  Set,Check fecha de caducidad, fabricacion obligatorio
* Flow     :  MIGO(R05),MF60
*             101 & ZEMB,ZENV,ZINS & ZNAL,ZIMP & a1,a2,v1,v2
**********************************************************************
*====================================================================*
* Tcode    : MIGO
*====================================================================*
*--------------------------------------------------------------------*
* Source   : Enhacement
* Activity : Set fecha de caducidad
*--------------------------------------------------------------------*
FORM a10_tcode_activity USING .
  CREATE OBJECT go_process.
  go_process->a10_accion( EXCEPTIONS error = 1 ).
ENDFORM.