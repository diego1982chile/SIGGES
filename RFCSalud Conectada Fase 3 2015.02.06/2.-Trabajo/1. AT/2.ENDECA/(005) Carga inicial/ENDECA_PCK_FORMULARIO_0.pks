INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT (RESPONSABLE,

                                        NOMBRE_SCRIPT,
                                        DESCRIPCION,
                                        FECHA_EJECUCION,
                                        NUMERO_OT)
     VALUES ('Diego Soto',
             '(005.1)[AT.ENDECA] DS CREA PACKAGE (pks) CARGA INICIAL TABAS ENDECA F3.sql',
             'Crea package para llenar tablas ENDECA Fase 3',
             SYSDATE,
             'ENDECA FASE 3');
COMMIT;             


/******oBJETIVO****

Crear package para realizar la carga inicial de formularios SIC-IPD-HD-OA-EXCGO-CAC Y CC, desde PK inicio hasta PK final

*******************/



CREATE OR REPLACE PACKAGE ENDECA.ENDECA_PCK_FORMULARIO_0 AS

/******************************************************************************
   NAME:       ENDECA_PCK_FORMULARIO_0
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02-02-2015   Diego Soto       1. Created this package.

******************************************************************************/

  FUNCTION ENDECA_FUN_PkLimiteIPD RETURN NUMBER;
  FUNCTION ENDECA_FUN_PkLimiteSIC RETURN NUMBER;
  FUNCTION ENDECA_FUN_PkLimiteHD RETURN NUMBER;
  FUNCTION ENDECA_FUN_PkLimiteEXCGO  RETURN NUMBER;
  FUNCTION ENDECA_FUN_PkLimiteCC  RETURN NUMBER;
  FUNCTION ENDECA_FUN_PkLimiteCAC  RETURN NUMBER;
  FUNCTION ENDECA_FUN_PkLimiteOA  RETURN NUMBER;
  PROCEDURE ENDECA_PRC_CARGA_FRM_IPD (p_HastaPK NUMBER);
  PROCEDURE ENDECA_PRC_CARGA_FRM_SIC (p_HastaPK NUMBER);
  PROCEDURE ENDECA_PRC_CARGA_FRM_HD (p_HastaPK NUMBER);
  PROCEDURE ENDECA_PRC_CARGA_FRM_EXCGO (p_HastaPK NUMBER);
  PROCEDURE ENDECA_PRC_CARGA_FRM_CC (p_HastaPK NUMBER);
  PROCEDURE ENDECA_PRC_CARGA_FRM_CAC (p_HastaPK NUMBER);
  PROCEDURE ENDECA_PRC_CARGA_FRM_OA (p_HastaPK NUMBER);
END ENDECA_PCK_FORMULARIO_0;
/

