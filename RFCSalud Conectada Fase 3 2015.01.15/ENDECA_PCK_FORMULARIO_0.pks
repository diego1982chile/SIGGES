CREATE OR REPLACE PACKAGE ENDECA.ENDECA_PCK_FORMULARIO_0 AS
/******************************************************************************
   NAME:       ENDECA_PCK_FORMULARIO_0
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23-12-2014      Iván       1. Created this package.
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

