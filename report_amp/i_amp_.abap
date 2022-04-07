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

**********************************************************************
* Process A:  Set,Check fecha de caducidad, fabricacion obligatorio
* Flow     :  MIGO(R05),MF60: 101 & ZEMB,ZENV,ZINS & ZNAL,ZIMP & a1,a2,v1,v2
**********************************************************************
*====================================================================*
* Tcode    : MIGO
*====================================================================*
*--------------------------------------------------------------------*
* Source   : Badi,Userexit,Bte,Enhacement - 
* Activity : Set fecha de caducidad
*--------------------------------------------------------------------*
FORM a10_tcode_activity USING .
  CREATE OBJECT go_process.
  go_process->a10_accion( EXCEPTIONS error = 1 ).
ENDFORM.