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
* Process  :  Check,Set fecha de caducidad, fabricacion obligatorio
* Flow     :  MIGO(R05),MF60: 101 & ZEMB,ZENV,ZINS & ZNAL,ZIMP & a1,a2,v1,v2
**********************************************************************
*--------------------------------------------------------------------*
* Activity : check fecha de caducidad
* Source   : MIGO - Badi,Userexit,Bte,Enhacement
*--------------------------------------------------------------------*
FORM a10_tcode_check USING .
  CREATE OBJECT go_process.
  go_process->a10_accion( EXCEPTIONS error = 1 ).
ENDFORM.
*--------------------------------------------------------------------*
* Activity : Set fecha de caducidad
* Source   : MIGO - Badi,Userexit,Bte,Enhacement - 
*--------------------------------------------------------------------*
FORM a20_tcode_set USING .
  CREATE OBJECT go_process.
  go_process->a20_accion( EXCEPTIONS error = 1 ).
ENDFORM.