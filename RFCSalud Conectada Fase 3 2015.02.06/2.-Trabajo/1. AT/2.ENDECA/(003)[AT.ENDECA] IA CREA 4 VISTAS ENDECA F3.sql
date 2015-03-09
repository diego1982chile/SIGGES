
INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT (RESPONSABLE,

                                        NOMBRE_SCRIPT,
                                        DESCRIPCION,
                                        FECHA_EJECUCION,
                                        NUMERO_OT)
     VALUES ('Iván Aguilera',
             '(003)[AT.ENDECA] IA CREA 4 VISTAS ENDECA F3.sql',
             'Crea vista ENDECA Fase 3',
             SYSDATE,
             'ENDECA FASE 3');
COMMIT;             
----------------------------------------------------------------------------------

--DROP VIEW ENDECA.ENDECA_VW_CAUSALCAC;

/* Formatted on 15-01-2015 18:26:28 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW ENDECA.ENDECA_VW_CAUSALCAC
(
   CODIGO,
   DESCRIPCION
)
AS
   SELECT "TIPEVEAIS_COD_TIPEVEAIS", "TIPEVEAIS_DSC_TIPEVEAIS"
     FROM SIS.SIS_TAB_TIPEVEAIS;

----------------------------------------------------------------------------------

--DROP VIEW ENDECA.ENDECA_VW_CAUSALCCEXGO;

/* Formatted on 15-01-2015 18:26:28 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW ENDECA.ENDECA_VW_CAUSALCCEXGO
(
   COD_CAUSAL,
   DESCRIPCION,
   TIPO_CAUSAL
)
AS
   SELECT "TIPCIECA_COD_TIPCIECA",
          "TIPCIECA_DSC_TIPCIECA",
          "TIPCAUSAL_COD_TIPCAUSAL"
     FROM SIS.SIS_TAB_TIPCIECA;


---------------------------------------------------------------------------------
--
DROP VIEW ENDECA.ENDECA_VW_DIAGNOSTICOPS;

/* Formatted on 15-01-2015 18:26:28 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW ENDECA.ENDECA_VW_DIAGNOSTICOPS
(
   COD_DIAGNOSTICO,
   DESCRIPCION
)
AS
   SELECT "TIPELEVA_COD_TIPELEVA", "TIPELEVA_DSC_TIPELEVA"
     FROM SIS.SIS_TAB_TIPELEVA;


---------------------------------------------------------------------------------

--DROP VIEW ENDECA.ENDECA_VW_NODOHD;

/* Formatted on 15-01-2015 18:26:28 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FORCE VIEW ENDECA.ENDECA_VW_NODOHD
(
   COD_NODOHD,
   DESCRIPCION
)
AS
   SELECT "NODOHD_COD_NODOHD", "NODOHD_DSC_NODOHD"
     FROM SIS.SIS_TAB_nodoHD;
