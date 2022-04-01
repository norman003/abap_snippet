*----------------------------------------------------------------------*
*1.1 INICIALES
*----------------------------------------------------------------------*
•	Asegura un enfoque consistente
•	Previene conflicto de nombres de objetos

*----------------------------------------------------------------------*
*1.2. PAQUETES
*----------------------------------------------------------------------*
ZOSCO	      "Controlling
ZOSPEWP		  "Solución de web de proveedores
ZOSPEFE_WPC	"Facturación electrónica – web services

*----------------------------------------------------------------------*
*1.3. TRANSACCIONES
*----------------------------------------------------------------------*
"Para propósito de asignación de autorización
ZOSMMacronimo
ZOSMMxxx      "Correlativo

*----------------------------------------------------------------------*
*1.4. OBJETOS - SE11
*----------------------------------------------------------------------*
Tablas	          ZOSMMTB_acrónimo	"Max 16 – Excluir PE: zoslltb_sociedad
Elemento de Dato	ZOSMMED_acrónimo
Domino	          ZOSMMDO_acrónimo
Ayuda de búsqueda	ZOSMMAB_acrónimo
Estructura	      ZOSMMES_acrónimo
Tipo tabla	      ZOSMMTT_acrónimo
Vistas	          ZOSMMVA_acrónimo	"Max 16 – Excluir PE: zoslltb_sociedad
Vista Gr Función	ZOSGFVA_acrónimo	"Max 16 – Excluir PE: zoslltb_sociedad
Vistas Cluster	  ZOSMMVC_acrónimo	"Max 16 – Excluir PE: zoslltb_sociedad

*----------------------------------------------------------------------*
*1.5. CODIGO - SE38, SE24, SE37
*----------------------------------------------------------------------*
Programa	  ZOSMMRPT_process/activity	"Reporte
Programa	  ZOSMMINT_process/activity	"Interfaz de mantenimiento
Programa	  ZOSMMINC_process/activity	"Includes TOP,SEL,F01,LIB,ALV
Programa	  ZOSMMPRO_process/activity	"process/activity
Programa	  ZOSMMCAR_process/activity	"Carga masiva
Estructura	ZOSMMPRO_process/activity	"Estructura de reporte
Clase	      ZOSMMCL_process/activity
Grupo	      ZOSMMGF_process/activity
Función	    ZOSMMFM_process/activity

*----------------------------------------------------------------------*
*1.6. RFC
*----------------------------------------------------------------------*
Grupo de Funcion	ZOSMMGFRFC_process/activity
Funcion           ZOSMMMFRFC_process/activity

*----------------------------------------------------------------------*
*1.7. WEBSERVICES
*----------------------------------------------------------------------*
Grupo Función	      ZOSMMGFWSP_process/activity
Grupo Función	      ZOSMMMFWSP_process/activity
Paquete Consumo	    ZOSMMWSC
Paquete Publicación	ZOSMMWSP
WebServices Publish	ZOSMMWSP_process/activity
WebServices Consume	ZOSMMWSC_process/activity

*----------------------------------------------------------------------*
*1.8. AMPLIACIONES
*----------------------------------------------------------------------*
Enhancement	          ZOSMMEP_tcode_process/activity_badi	"process/activity - si tiene varias validaciones
Enhancement compuesto	ZOSMMEC_tcode_process/activity
Enhancement badi	    ZOSMMbadi
Programa	            ZOSMMAMP_tcode_process/activity
                      ZOSMMMAIL_tcode_process/activity
Include de Exit	      ZOSMMAMP_exit
Paquete padre	        ZOSMM
Paquete	              ZOSMMAMP

*----------------------------------------------------------------------*
*1.9. WORKFLOW
*----------------------------------------------------------------------*
Grupo Función	ZOSMMGFWF_process/activity
Funcion       ZOSMMMFWF_process/activity
Programa	    ZOSMMWF_process/activity
Clase	        ZOSMMCLWF_process/activity
Paquete padre	ZOSMM	
Paquete	      ZOSMMWF

*----------------------------------------------------------------------*
*1.10. FORMULARIO
*----------------------------------------------------------------------*
Programa	  ZOSMMSF_process/activity
Smartforms	ZOSMMSF_process/activity
Estructuras	ZOSMMSF_process/activity_CAB
            ZOSMMSF_process/activity_DET
            ZOSMMSF_process/activity_DET_TT
            ZOSMMSF_process/activity_PIE

*----------------------------------------------------------------------*
*1.11. COMPARTIDOS
*----------------------------------------------------------------------*
Paquete padre	ZOSMM
Paquete	      ZOSMM_SHARED_CEW
