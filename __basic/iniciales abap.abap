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
Programa	  ZOSMMRPT_proceso	"Reporte
Programa	  ZOSMMINT_proceso	"Interfaz de mantenimiento
Programa	  ZOSMMINC_proceso	"Includes TOP,SEL,F01,LIB,ALV
Programa	  ZOSMMPRO_proceso	"Proceso
Programa	  ZOSMMCAR_proceso	"Carga masiva
Estructura	ZOSMMPRO_proceso	"Estructura de reporte
Clase	      ZOSMMCL_proceso	
Grupo	      ZOSMMGF_proceso	
Función	    ZOSMMFM_proceso	

*----------------------------------------------------------------------*
*1.6. RFC
*----------------------------------------------------------------------*
Grupo de Funcion	ZOSMMGFRFC_proceso	
Funcion           ZOSMMMFRFC_proceso

*----------------------------------------------------------------------*
*1.7. WEBSERVICES
*----------------------------------------------------------------------*
Grupo Función	      ZOSMMGFWSP_proceso
Grupo Función	      ZOSMMMFWSP_proceso
Paquete Consumo	    ZOSMMWSC
Paquete Publicación	ZOSMMWSP
WebServices Publish	ZOSMMWSP_proceso
WebServices Consume	ZOSMMWSC_proceso

*----------------------------------------------------------------------*
*1.8. AMPLIACIONES
*----------------------------------------------------------------------*
Enhancement	          ZOSMMEP_tcode_proceso_badi	"proceso - si tiene varias validaciones
Enhancement compuesto	ZOSMMEC_tcode_proceso
Enhancement badi	    ZOSMMbadi
Programa	            ZOSMMAMP_tcode_proceso
                      ZOSMMMAIL_tcode_proceso
Include de Exit	      ZOSMMAMP_exit
Paquete padre	        ZOSMM
Paquete	              ZOSMMAMP

*----------------------------------------------------------------------*
*1.9. WORKFLOW
*----------------------------------------------------------------------*
Grupo Función	ZOSMMGFWF_proceso	
Funcion       ZOSMMMFWF_proceso
Programa	    ZOSMMWF_proceso	
Clase	        ZOSMMCLWF_proceso	
Paquete padre	ZOSMM	
Paquete	      ZOSMMWF

*----------------------------------------------------------------------*
*1.10. FORMULARIO
*----------------------------------------------------------------------*
Programa	  ZOSMMSF_proceso	
Smartforms	ZOSMMSF_proceso	
Estructuras	ZOSMMSF_proceso_CAB
            ZOSMMSF_proceso_DET
            ZOSMMSF_proceso_DET_TT
            ZOSMMSF_proceso_PIE

*----------------------------------------------------------------------*
*1.11. COMPARTIDOS
*----------------------------------------------------------------------*
Paquete padre	ZOSMM
Paquete	      ZOSMM_SHARED_CEW
