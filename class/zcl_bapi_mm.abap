class ZCL_BAPI_MM definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF gty_tab,
*--Cab.
        nro     TYPE i,       "Nro de contrato
        bsart   TYPE bsart,   "Clase Pedido
        bukrs   TYPE bukrs,   "Sociedad
        lifnr   TYPE lifnr,   "Proveedor
        zterm   TYPE dzterm,  "Clave de condiciones
        zbd1t   TYPE dzbd1t,  "Dias de desc.
        zbd2t   TYPE dzbd2t,  "Dias de desc.
        zbd3t   TYPE dzbd3t,  "Dias de desc.
        ekorg   TYPE ekorg,   "Org. Compras
        ekgrp   TYPE ekgrp,   "Grp. Compras
        waers   TYPE waers,   "Moneda
        bedat   TYPE ebdat,   "Fecha Documento
        weakt   TYPE weakt,   "Mensaje EM
        inco1   TYPE inco1,   "Incoterms1
        inco2   TYPE inco2,   "Incoterms2
*--Detalle
        ebelp   TYPE ebelp,   "Posicion
        matnr   TYPE matnr,   "Material
        werks   TYPE werks_d, "Centro
        lgort   TYPE lgort_d, "Almacen
        menge   TYPE menge13, "Cantidad
        meins   TYPE meins,   "Uni. Med.
        bprme   TYPE bbprm,   "Uni. Med. Precio
        netpr   TYPE netpr,   "Precio Neto
        peinh   TYPE peinh,   "Por
        pstyp   TYPE pstyp,   "Tipo Posición
        knttp   TYPE knttp,   "Tipo de imputacion
        afnam   TYPE afnam,   "Solicitante
        txz01   TYPE txz01,   "Texto breve
        matkl   TYPE mara-matkl,   "Gr. Articulos
        mwskz   TYPE mwskz,   "Ind. IVA
*--Cuenta
        sakto   TYPE sakto,   "Cuenta Mayor
        kostl   TYPE kostl,   "Centro de costo
        aufnr   TYPE aufnr,   "Orden de Proceso
        kokrs   TYPE kokrs,   "Sociedad CO
*--Servicio
        srvpos  TYPE asnum,   "Servicio
        txz01_s TYPE txz01,   "Texto breve
        menge_s TYPE menge_d, "Cantidad
        meins_s TYPE meins,   "Unidad
        peinh_s TYPE peinh,   "Por
        brtwr_s TYPE brtwr,   "Precio Bruto
        matkl_s TYPE matkl,   "Grupo Artículo
*--Adicionales Detalle
        wepos   TYPE wepos,
        webre   TYPE webre,
        lebre   TYPE lebre,
        idnlf   TYPE idnlf,
       END OF gty_tab .

  data LS_HEADER type BAPIMEPOHEADER .
  data LS_HEADERX type BAPIMEPOHEADERX .
  data:
    LT_ITEMS type TABLE OF bapimepoitem .
  data:
    LT_ITEMSX type TABLE OF bapimepoitemx .
  data:
    LT_SERVICE type TABLE OF bapiesllc .
  data:
    LT_ACCOUNT type TABLE OF bapimepoaccount .
  data:
    LT_ACCOUNTX type TABLE OF bapimepoaccountx .
  data:
    LT_SERVICEACCES type TABLE OF bapiesklc .
  data EXP_HEADER type BAPIMEPOHEADER .
  data GT_RETURN type BAPIRETTAB .
  data:
    BEGIN OF zbapi,
          updateflag TYPE c VALUE 'I',"Crear
        END OF zbapi .

  methods PEDIDO_CREATE
    importing
      !I_COMMIT_NO type C optional
    exporting
      !I_MBLNR type BAPIMEPOHEADER-PO_NUMBER
      !I_TEST type C
    exceptions
      ERROR .
  methods PEDIDO_HEADER_SET
    importing
      !LS_TAB type GTY_TAB .
  methods PEDIDO_ITEMS_SET
    importing
      !LS_TAB type GTY_TAB
      !I_PACKNO type I .
  methods PEDIDO_ACCOUNT_SET
    importing
      !LS_TAB type GTY_TAB .
  methods PEDIDO_SERVICIO_SET
    importing
      !LS_TAB type GTY_TAB
      !W_ITEM type I
      !W_LINE type I
      !W_PACKNO type I .
protected section.
private section.

  methods PEDIDO_CLEAR_TABLES .
  methods SET_STRUCTURE_X
    importing
      !IS_STRUCT_O type ANY
    changing
      !CS_STRUCT_X type ANY .
ENDCLASS.



CLASS ZCL_BAPI_MM IMPLEMENTATION.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_MM->PEDIDO_ACCOUNT_SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] LS_TAB                         TYPE        GTY_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
method PEDIDO_ACCOUNT_SET.

  DATA: ls_account LIKE LINE OF lt_account,
        ls_accountx LIKE LINE OF lt_accountx.

  ls_account-po_item    = ls_tab-ebelp.
  ls_account-serial_no  = 01.
  ls_account-creat_date = sy-datum.
  ls_account-gl_account = ls_tab-sakto.
  ls_account-costcenter = ls_tab-kostl.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = ls_tab-aufnr
    IMPORTING
      output = ls_account-orderid.

  ls_account-co_area    = ls_tab-kokrs.

  set_structure_x( EXPORTING is_struct_o = ls_account
                    CHANGING cs_struct_x = ls_accountx ).

  APPEND: ls_account TO lt_account,
          ls_accountx TO lt_accountx.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_BAPI_MM->PEDIDO_CLEAR_TABLES
* +-------------------------------------------------------------------------------------------------+
* +--------------------------------------------------------------------------------------</SIGNATURE>
method PEDIDO_CLEAR_TABLES.

*     Limpiar variables
      CLEAR: exp_header, ls_header, ls_headerx.
      REFRESH: lt_items, lt_itemsx, lt_service,
               lt_account, lt_accountx, lt_serviceacces.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_MM->PEDIDO_CREATE
* +-------------------------------------------------------------------------------------------------+
* | [--->] I_COMMIT_NO                    TYPE        C(optional)
* | [<---] I_MBLNR                        TYPE        BAPIMEPOHEADER-PO_NUMBER
* | [<---] I_TEST                         TYPE        C
* | [EXC!] ERROR
* +--------------------------------------------------------------------------------------</SIGNATURE>
METHOD pedido_create.

*     Limpiar return
  REFRESH gt_return.

*     Procesar BAPI
  CALL FUNCTION 'BAPI_PO_CREATE1'
    EXPORTING
      poheader          = ls_header
      poheaderx         = ls_headerx
    IMPORTING
      exppurchaseorder  = i_mblnr
      expheader         = exp_header
    TABLES
      return            = gt_return
      poitem            = lt_items
      poitemx           = lt_itemsx
      poaccount         = lt_account
      poaccountx        = lt_accountx
      poservices        = lt_service
      posrvaccessvalues = lt_serviceacces.

  pedido_clear_tables( ).
  CHECK i_commit_no = space.

  IF i_mblnr IS NOT INITIAL.
    IF i_test IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ENDIF.
  ENDIF.



ENDMETHOD.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_MM->PEDIDO_HEADER_SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] LS_TAB                         TYPE        GTY_TAB
* +--------------------------------------------------------------------------------------</SIGNATURE>
method PEDIDO_HEADER_SET.

* Campos de MEPO_TOPLINE de ME21N
  ls_header-doc_type    = ls_tab-bsart. "Cl.Pedido      "bsart      "x
  ls_header-vendor      = ls_tab-lifnr. "Proveedor      "superfield "x
  ls_header-doc_date    = ls_tab-bedat. "Fe.Doc.        "bedat      "x
  ls_header-comp_code   = ls_tab-bukrs. "Sociedad       "bukrs      "x
  ls_header-purch_org   = ls_tab-ekorg. "Org.Compras    "ekorg      "x
  ls_header-pur_group   = ls_tab-ekgrp. "Gr.Compras     "ekgrp      "x
  ls_header-pmnttrms    = ls_tab-zterm. "Cl.Condicion
  ls_header-dscnt1_to   = ls_tab-zbd1t. "% pronto pago1
  ls_header-dscnt2_to   = ls_tab-zbd2t. "% pronto pago2
  ls_header-dscnt3_to   = ls_tab-zbd3t. "% pronto pago3
  ls_header-currency    = ls_tab-waers. "Moneda
  ls_header-gr_message  = ls_tab-weakt. "Ind. Mensaj. EM
  ls_header-incoterms1  = ls_tab-inco1. "Incoterms1
  ls_header-incoterms2  = ls_tab-inco2. "Incoterms2

  set_structure_x( EXPORTING is_struct_o = ls_header
                    CHANGING cs_struct_x = ls_headerx ).

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_MM->PEDIDO_ITEMS_SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] LS_TAB                         TYPE        GTY_TAB
* | [--->] I_PACKNO                       TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method PEDIDO_ITEMS_SET.

    DATA: ls_items    LIKE LINE OF lt_items,
        ls_itemsx   LIKE LINE OF lt_itemsx.

* Ventana POSICION - estructura MEPO1211
  ls_items-po_item    = ls_tab-ebelp. "Nro de pos.    "ebelp  "x
  ls_items-acctasscat = ls_tab-knttp. "Tipo de imput. "knttp  "x
  ls_items-item_cat   = ls_tab-pstyp. "Tipo de pos    "epstp  "x
  ls_items-short_text = ls_tab-txz01. "Texto breve    "txz01

  ls_items-material   = ls_tab-matnr. "Material       "ematn
  ls_items-matl_group = ls_tab-matkl. "Gr. articulos  "wgbez
  ls_items-plant      = ls_tab-werks. "Centro         "name1  "x
  ls_items-stge_loc   = ls_tab-lgort. "Almacen        "lgobe
  ls_items-quantity   = ls_tab-menge. "Cantidad       "menge  "x
  ls_items-po_unit    = ls_tab-meins. "UM             "meins  "x
  ls_items-orderpr_un = ls_tab-bprme. "UM de precio
  ls_items-net_price  = ls_tab-netpr. "Precio neto    "netpr
  ls_items-price_unit = ls_tab-peinh. "Cantidad base

  ls_items-preq_name  = ls_tab-afnam. "Solicitante

* Pestaña ENTREGA - estructura MEPO1313
  ls_items-gr_ind     = ls_tab-wepos. "Ind. EM.             "wepos "x

* Pestaña FACTURA - estructura MEPO1317
  ls_items-gr_basediv = ls_tab-webre. "Ind. ver. fac. EM.   "webre "X
  ls_items-srv_based_iv = ls_tab-lebre. "Ind. ver. fac. SV. "lebre
  ls_items-tax_code   = ls_tab-mwskz. "Indicador IVA        "mwskz

* Pestaña SERVICIO - estructura ESLL
  ls_items-pckg_no    = i_packno.     "N° paquete           "packno

* Pestaña DATOS MATERIAL - estructura MEPO1319
  ls_items-vend_mat   = ls_tab-idnlf. "Mat. Proveedor       "idnlf


  set_structure_x( EXPORTING is_struct_o = ls_items
                    CHANGING cs_struct_x = ls_itemsx ).

  APPEND: ls_items TO lt_items,
          ls_itemsx TO lt_itemsx.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Public Method ZCL_BAPI_MM->PEDIDO_SERVICIO_SET
* +-------------------------------------------------------------------------------------------------+
* | [--->] LS_TAB                         TYPE        GTY_TAB
* | [--->] W_ITEM                         TYPE        I
* | [--->] W_LINE                         TYPE        I
* | [--->] W_PACKNO                       TYPE        I
* +--------------------------------------------------------------------------------------</SIGNATURE>
method PEDIDO_SERVICIO_SET.

  DATA: ls_service      LIKE LINE OF lt_service,
        ls_serviceacces LIKE LINE OF lt_serviceacces.


  IF w_line = 1.
    ls_service-pckg_no    = w_packno.
    ls_service-line_no    = w_line.
    ls_service-outl_ind   = 'X'.
    ls_service-subpckg_no = w_packno + 1.
    APPEND ls_service TO lt_service.
  ENDIF.

  ls_service-pckg_no    = w_packno + 1.
  ls_service-line_no    = w_line + 1.
  ls_service-ext_line   = w_item.
  ls_service-subpckg_no = w_packno + 1.

** O es codigo de servicio o texto
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = ls_tab-srvpos
    IMPORTING
      output = ls_service-service.


* Campos de ESLL de la tx ME21N
  ls_service-short_text = ls_tab-txz01_s. "Texto de servicio  "txz01  "x
  ls_service-quantity   = ls_tab-menge_s. "Cantidad con signo "menge  "x
  ls_service-base_uom   = ls_tab-meins_s. "UM                 "meins  "x
  ls_service-gr_price   = ls_tab-brtwr_s. "Precio bruto       "brtwr  "x
  ls_service-matl_group = ls_tab-matkl_s. "Gr.Articulo        "matkl  "x
  ls_service-price_unit = ls_tab-peinh_s. "Cantidad base      "peinh
  APPEND ls_service TO lt_service.

** Datos de asignaciones de cuentas # Imputación (en este caso es imputación simple)**
* Si fuera imputación múltiple hay que agregar mís registros, uno por cada distribución
  ls_serviceacces-pckg_no    = w_packno + 1.
  ls_serviceacces-line_no    = w_line + 1.
  ls_serviceacces-serno_line = 01.
  ls_serviceacces-serial_no  = 01.
  APPEND ls_serviceacces TO lt_serviceacces.

endmethod.


* <SIGNATURE>---------------------------------------------------------------------------------------+
* | Instance Private Method ZCL_BAPI_MM->SET_STRUCTURE_X
* +-------------------------------------------------------------------------------------------------+
* | [--->] IS_STRUCT_O                    TYPE        ANY
* | [<-->] CS_STRUCT_X                    TYPE        ANY
* +--------------------------------------------------------------------------------------</SIGNATURE>
method SET_STRUCTURE_X.

    DATA: lo_struct     TYPE REF TO clubap_structdescr,
          lo_structx    TYPE REF TO clubap_structdescr,
          ls_comps      LIKE LINE OF lo_struct->components,
          ls_compsx     LIKE LINE OF lo_struct->components.

    FIELD-SYMBOLS: <fs_campo> TYPE any,
                   <fs_campox> TYPE any.

    lo_struct ?= clubap_structdescr=>describe_by_data( is_struct_o ).
    lo_structx ?= clubap_structdescr=>describe_by_data( cs_struct_x ).

    LOOP AT lo_struct->components INTO ls_comps.
      ASSIGN COMPONENT ls_comps-name OF STRUCTURE is_struct_o TO <fs_campo>.
      ASSIGN COMPONENT ls_comps-name OF STRUCTURE cs_struct_x TO <fs_campox>.
      IF sy-subrc = 0.
        IF <fs_campo> IS NOT INITIAL.
          READ TABLE lo_structx->components INTO ls_compsx WITH KEY name = ls_comps-name.
          IF ls_compsx-length EQ 1.
            <fs_campox> = abap_true.
          ELSE.
            <fs_campox> = <fs_campo>.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    ASSIGN COMPONENT 'UPDATEFLAG' OF STRUCTURE cs_struct_x TO <fs_campox>.
    IF sy-subrc = 0.
      <fs_campox> = zbapi-updateflag.
    ENDIF.

endmethod.
ENDCLASS.