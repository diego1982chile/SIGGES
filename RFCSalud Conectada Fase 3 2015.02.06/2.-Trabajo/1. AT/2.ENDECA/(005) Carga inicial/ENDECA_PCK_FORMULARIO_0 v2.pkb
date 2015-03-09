INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT (RESPONSABLE,

                                        NOMBRE_SCRIPT,
                                        DESCRIPCION,
                                        FECHA_EJECUCION,
                                        NUMERO_OT)
     VALUES ('Diego Soto',
             '(005.1)[AT.ENDECA] DS CREA PACKAGE (pkb) CARGA INICIAL TABAS ENDECA F3.sql',
             'Crea package para llenar tablas ENDECA Fase 3',
             SYSDATE,
             'ENDECA FASE 3');
COMMIT;             


/******oBJETIVO****

Crear package (pkb) para realizar la carga inicial de formularios SIC-IPD-HD-OA-EXCGO-CAC Y CC
para registros con fecha otorgamiento desde 01/07/2005 hasta el 09/12/2014

*******************/


CREATE OR REPLACE PACKAGE BODY ENDECA.ENDECA_PCK_FORMULARIO_0
AS
   /******************************************************************************
      NAME:       ENDECA_PCK_FORMULARIO
      PURPOSE:

      REVISIONS:
      Ver        Date        Author           Description
      ---------  ----------  ---------------  ------------------------------------
      1.0        02-02-2015     Iván       1. Created this package body.
      1.1        03-02-2015     Diego      2. Se modifica rango de fecha anterior al 10/12/2014 para 1a. carga
      1.2        06-02-2014     Diego      3. Se agrega validación en el filtro para fecha otorgamiento de los formularios desde 01/07/2005
   ******************************************************************************/

   FUNCTION ENDECA_FUN_PkLimiteIPD
      RETURN NUMBER
   IS
      ultimo_en_secuencia   NUMBER (12) := 0;
   BEGIN
      SELECT MAX (R.REGESTINSDOC_NUM_VALORPK)
        INTO ultimo_en_secuencia
        FROM sis.sis_tab_regestinsdoc r
       WHERE R.CAMP_COD_CAMP = 247
             --AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (SYSDATE - 1);
             AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (to_date('10/12/2014','DD/MM/RRRR'));

      RETURN ultimo_en_secuencia;
   END;

   FUNCTION ENDECA_FUN_PkLimiteSIC
      RETURN NUMBER
   IS
      ultimo_en_secuencia   NUMBER (12) := 0;
   BEGIN
      SELECT MAX (R.REGESTINSDOC_NUM_VALORPK)
        INTO ultimo_en_secuencia
        FROM sis.sis_tab_regestinsdoc r
       WHERE R.CAMP_COD_CAMP = 105
             --AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (SYSDATE - 1);
            AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (to_date('10/12/2014','DD/MM/RRRR'));

      RETURN ultimo_en_secuencia;
   END;

   FUNCTION ENDECA_FUN_PkLimiteHD
      RETURN NUMBER
   IS
      ultimo_en_secuencia   NUMBER (12) := 0;
   BEGIN
      SELECT MAX (R.REGESTINSDOC_NUM_VALORPK)
        INTO ultimo_en_secuencia
        FROM sis.sis_tab_regestinsdoc r
       WHERE R.CAMP_COD_CAMP = 8000
             --AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (SYSDATE - 1);
             AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (to_date('10/12/2014','DD/MM/RRRR'));

      RETURN ultimo_en_secuencia;
   END;

   FUNCTION ENDECA_FUN_PkLimiteEXCGO
      RETURN NUMBER
   IS
      ultimo_en_secuencia   NUMBER (12) := 0;
   BEGIN
      SELECT MAX (R.REGESTINSDOC_NUM_VALORPK)
        INTO ultimo_en_secuencia
        FROM sis.sis_tab_regestinsdoc r
       WHERE R.CAMP_COD_CAMP = 8200
             --AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (SYSDATE - 1);
             AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (to_date('10/12/2014','DD/MM/RRRR'));

      RETURN ultimo_en_secuencia;
   END;

   FUNCTION ENDECA_FUN_PkLimiteCC
      RETURN NUMBER
   IS
      ultimo_en_secuencia   NUMBER (12) := 0;
   BEGIN
      SELECT MAX (R.REGESTINSDOC_NUM_VALORPK)
        INTO ultimo_en_secuencia
        FROM sis.sis_tab_regestinsdoc r
       WHERE R.CAMP_COD_CAMP = 6000
             --AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (SYSDATE - 1);
             AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (to_date('10/12/2014','DD/MM/RRRR'));

      RETURN ultimo_en_secuencia;
   END;

   FUNCTION ENDECA_FUN_PkLimiteCAC
      RETURN NUMBER
   IS
      ultimo_en_secuencia   NUMBER (12) := 0;
   BEGIN
      SELECT MAX (R.REGESTINSDOC_NUM_VALORPK)
        INTO ultimo_en_secuencia
        FROM sis.sis_tab_regestinsdoc r
       WHERE R.CAMP_COD_CAMP = 8100
             --AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (SYSDATE - 1);
             AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (to_date('10/12/2014','DD/MM/RRRR'));

      RETURN ultimo_en_secuencia;
   END;

   FUNCTION ENDECA_FUN_PkLimiteOA
      RETURN NUMBER
   IS
      ultimo_en_secuencia   NUMBER (12) := 0;
   BEGIN
      SELECT MAX (R.REGESTINSDOC_NUM_VALORPK)
        INTO ultimo_en_secuencia
        FROM sis.sis_tab_regestinsdoc r
       WHERE R.CAMP_COD_CAMP = 1081
             --AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (SYSDATE - 1);
             AND TRUNC (R.REGESTINSDOC_FEC_VIGE) <= TRUNC (to_date('10/12/2014','DD/MM/RRRR'));

      RETURN ultimo_en_secuencia;
   END;

   PROCEDURE ENDECA_PRC_CARGA_FRM_IPD (p_HastaPK NUMBER)
   IS
      num_total_rows      NUMBER (15);
      num_insert_rows     NUMBER (15);
      ultima_pk           NUMBER (15);
      primera_pk          NUMBER (15);
      ultima_Fecha        TIMESTAMP (6);
      primera_Fecha       TIMESTAMP (6);
      v_ultimo_anterior   NUMBER (15);
      codigoProceso       VARCHAR2 (25);
      v_id_proceso        NUMBER (15);
      v_ficha_Clinica     VARCHAR2 (20 BYTE);
      v_Direccion         VARCHAR2 (256 BYTE);
      v_Comuna            NUMBER (12);
      v_telefono          VARCHAR2 (20 BYTE);
      errnum              NUMBER (12);
      errmsg              VARCHAR2 (200);
      MaxRegistros        NUMBER (15);
      PROCESO_ABORTADO    EXCEPTION;
      Flag                NUMBER (2);
      v_caso_valido       VARCHAR2 (2) := 'SI';
      k                   NUMBER (15);
   BEGIN
      codigoProceso := 'Carga FRM_IPD Nuevo';
      v_id_proceso := endeca_pck_log.endeca_fun_IniciaProceso (codigoProceso);
      num_insert_rows := 0;
      v_ultimo_anterior :=
         endeca_pck_log.endeca_fun_GetPkAnterior (codigoProceso);

      IF v_ultimo_anterior = 0
      THEN
         --v_ultimo_anterior := 1006149078 - 1; -- para que inicie desde 01-01-2010
         v_ultimo_anterior := 4057473-1; 
      END IF;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Registrada:' || v_ultimo_anterior);

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Considerada:' || p_HastaPK);

      SELECT TO_NUMBER (PARA_DSC_VALOR)
        INTO MaxRegistros
        FROM SIS.SIS_TAB_PARA
       WHERE PARA_COD_PARA = 50581;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (v_id_proceso,
                                            'MaxRegistros:' || MaxRegistros);

      /**/
      SELECT COUNT (1)
        INTO num_total_rows
        FROM sis.sis_tab_DOCU_2 D,
             sis.SIS_TAB_REGESTINSDOC R
       WHERE     D.DOCU_2_COL_247 > v_ultimo_anterior
             AND D.DOCU_2_COL_247 <= p_HastaPK
             AND D.DOCU_2_COL_245 > 0
			 AND D.DOCU_2_COL_175 >= to_date('01/07/2005','DD/MM/RRRR')
             AND R.REGESTINSDOC_NUM_VALORPK = D.DOCU_2_COL_247
             AND R.CAMP_COD_CAMP = 247
             AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
             AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
             AND R.REGESTINSDOC_FEC_VCTO IS NULL;
             --AND ROWNUM <= MaxRegistros;



      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'num_total_rows:' || num_total_rows);

      /**/
      FOR doc
         IN (SELECT D.DOCU_2_COL_247 ID_IPD,
                    D.DOCU_2_COL_245 ID_Caso,
                    D.DOCU_2_COL_173 Folio_IPD,
                    D.DOCU_2_COL_175 Fecha_IPD,
                    D.DOCU_2_COL_178 Hora_IPD,
                    D.DOCU_2_COL_182 Cod_Establecim,
                    D.DOCU_2_COL_233 Cod_Especialidad,
                    D.DOCU_2_COL_197 ConfirmaDescarta,
                    D.DOCU_2_COL_194 Cod_rama,
                    D.DOCU_2_COL_6043 DiagEsp_PS,
                    D.DOCU_2_COL_225 RUN_Profesional,
                    D.DOCU_2_COL_227 DV_Profesional,
                    R.REGESTINSDOC_FEC_VIGE Fec_digitacion,
                    R.USUA_COD_USUA Usuario_digita,
                    R.UNI_COD_UNI Unidad_digita
               FROM sis.sis_tab_DOCU_2 D,
                    sis.SIS_TAB_REGESTINSDOC R
              WHERE     D.DOCU_2_COL_247 > v_ultimo_anterior
                    AND D.DOCU_2_COL_247 <= p_HastaPK
                    AND D.DOCU_2_COL_245 > 0
                    AND R.REGESTINSDOC_NUM_VALORPK = D.DOCU_2_COL_247
                    AND R.CAMP_COD_CAMP = 247
                    AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
                    AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
                    AND R.REGESTINSDOC_FEC_VCTO IS NULL)
                    --AND ROWNUM <= Maxregistros)
      LOOP
         BEGIN
            v_caso_valido := 'SI';

            SELECT C.CASOBENEF_COD_CASOBENEF
              INTO k
              FROM sis.SIS_TAB_CASOBENEF C
             WHERE C.CASOBENEF_COD_CASOBENEF = doc.ID_CASO        --1020251434
                   AND C.BOO_COD_CASOVALIDO = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_caso_valido := 'NO';                              --no valido
         END;

         IF (v_caso_valido = 'SI')
         THEN
            INSERT INTO ENDECA.ENDECA_TAB_IPD (CPROCESO_ID_PROCESO,
                                               ID_IPD,
                                               ID_CASO,
                                               FOLIO_IPD,
                                               FECHA_IPD,
                                               HORA_IPD,
                                               COD_ESTABLECIM,
                                               COD_ESPECIALIDAD,
                                               CONFIRMADESCARTA,
                                               COD_RAMA,
                                               DIAGESP_PS,
                                               RUN_PROFESIONAL,
                                               DV_PROFESIONAL,
                                               FEC_DIGITACION,
                                               USUARIO_DIGITA,
                                               UNIDAD_DIGITA)
                 VALUES (v_id_proceso,               /* CPROCESO_ID_PROCESO */
                         doc.ID_IPD,                              /* ID_IPD */
                         doc.ID_CASO,                            /* ID_CASO */
                         doc.FOLIO_IPD,                        /* FOLIO_IPD */
                         doc.FECHA_IPD,                        /* FECHA_IPD */
                         doc.HORA_IPD,                          /* HORA_IPD */
                         doc.COD_ESTABLECIM,              /* COD_ESTABLECIM */
                         doc.COD_ESPECIALIDAD,          /* COD_ESPECIALIDAD */
                         doc.CONFIRMADESCARTA,          /* CONFIRMADESCARTA */
                         doc.COD_RAMA,                          /* COD_RAMA */
                         doc.DIAGESP_PS,                      /* DIAGESP_PS */
                         doc.RUN_PROFESIONAL,            /* RUN_PROFESIONAL */
                         doc.DV_PROFESIONAL,              /* DV_PROFESIONAL */
                         doc.FEC_DIGITACION,              /* FEC_DIGITACION */
                         doc.USUARIO_DIGITA,              /* USUARIO_DIGITA */
                         doc.UNIDAD_DIGITA                 /* UNIDAD_DIGITA */
                                          );

            num_insert_rows := num_insert_rows + 1;

            IF (MOD (num_insert_rows, 1000) = 0)
            THEN
               endeca_pck_log.endeca_pro_Avance (
                  v_id_proceso,
                  ' AVANCE '
                  || TO_CHAR ( (num_insert_rows / num_total_rows) * 100,
                              '990.0')
                  || '%');

               SELECT TO_NUMBER (PARA_DSC_VALOR)
                 INTO Flag
                 FROM SIS.SIS_TAB_PARA
                WHERE PARA_COD_PARA = 50584;

               IF Flag <> 1
               THEN
                  RAISE PROCESO_ABORTADO;
               END IF;

               COMMIT;
            END IF;

            IF (num_insert_rows = 1)
            THEN
               primera_pk := doc.ID_IPD;
               primera_Fecha := NULL;
               ultima_Fecha := NULL;
               ultima_pk := doc.ID_IPD;
               endeca_pck_log.endeca_pro_SetLeidos (v_id_proceso,
                                                    num_total_rows);
            END IF;

            IF doc.ID_IPD < primera_pk
            THEN
               primera_pk := doc.ID_IPD;
               primera_Fecha := NULL;
            END IF;

            IF doc.ID_IPD > ultima_pk
            THEN
               ultima_pk := doc.ID_IPD;
               ultima_Fecha := NULL;
            END IF;
         END IF;                                                 --caso valido
      END LOOP;

      COMMIT;
      endeca_pck_log.endeca_pro_SetProcesados (v_id_proceso, num_insert_rows);
      endeca_pck_log.endeca_pro_SetPK (v_id_proceso, primera_pk, ultima_pk);
      endeca_pck_log.endeca_pro_SetFecha (v_id_proceso,
                                          primera_Fecha,
                                          ultima_Fecha);
      endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_OK');
   EXCEPTION
      WHEN PROCESO_ABORTADO
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || '  Abortado por Usuario Operador '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'ABORTADO ');
      WHEN OTHERS
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || ' Error en endeca_fun_GetPkAnterior '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_ERR');
   END;                                                          --FIN FRM_IPD

   PROCEDURE ENDECA_PRC_CARGA_FRM_SIC (p_HastaPK NUMBER)
   IS
      num_total_rows      NUMBER (15);
      num_insert_rows     NUMBER (15);
      ultima_pk           NUMBER (15);
      primera_pk          NUMBER (15);
      ultima_Fecha        TIMESTAMP (6);
      primera_Fecha       TIMESTAMP (6);
      v_ultimo_anterior   NUMBER (15);
      codigoProceso       VARCHAR2 (25);
      v_id_proceso        NUMBER (15);
      v_ficha_Clinica     VARCHAR2 (20 BYTE);
      v_Direccion         VARCHAR2 (256 BYTE);
      v_Comuna            NUMBER (12);
      v_telefono          VARCHAR2 (20 BYTE);
      errnum              NUMBER (12);
      errmsg              VARCHAR2 (200);
      MaxRegistros        NUMBER (15);
      PROCESO_ABORTADO    EXCEPTION;
      Flag                NUMBER (2);
      v_caso_valido       VARCHAR2 (2) := 'SI';
      k                   NUMBER (15);
   BEGIN
      codigoProceso := 'Carga FRM_SIC Nuevo';
      v_id_proceso := endeca_pck_log.endeca_fun_IniciaProceso (codigoProceso);
      num_insert_rows := 0;
      v_ultimo_anterior :=
         endeca_pck_log.endeca_fun_GetPkAnterior (codigoProceso);

      IF v_ultimo_anterior = 0
      THEN
         --v_ultimo_anterior := 1012145939 - 1; -- para que inicie desde 01-01-2010
         v_ultimo_anterior := 4203887-1;
      END IF;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Registrada:' || v_ultimo_anterior);

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Considerada:' || p_HastaPK);

      SELECT TO_NUMBER (PARA_DSC_VALOR)
        INTO MaxRegistros
        FROM SIS.SIS_TAB_PARA
       --WHERE PARA_COD_PARA = 50582;
       WHERE PARA_COD_PARA = 50582;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (v_id_proceso,
                                            'MaxRegistros:' || MaxRegistros);

      /**/
      SELECT COUNT (1)
        INTO num_total_rows
        FROM sis.sis_tab_DOCU_1 D,
             sis.SIS_TAB_REGESTINSDOC R
       WHERE D.DOCU_1_COL_105 > v_ultimo_anterior
             AND D.DOCU_1_COL_105 <= p_HastaPK
             AND D.DOCU_1_COL_104 > 0
             AND D.DOCU_1_COL_5 >= to_date('01/07/2005','DD/MM/RRRR')
             AND R.REGESTINSDOC_NUM_VALORPK = D.DOCU_1_COL_105
             AND R.CAMP_COD_CAMP = 105
             AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
             AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
             AND R.REGESTINSDOC_FEC_VCTO IS NULL;
             --AND ROWNUM <= MaxRegistros;


      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'num_total_rows:' || num_total_rows);

      /**/
      FOR doc
         IN (SELECT D.DOCU_1_COL_105 ID_SIC,
                    D.DOCU_1_COL_104 ID_CASO,
                    D.DOCU_1_COL_3 FOLIO_SIC,
                    D.DOCU_1_COL_5 FECHA_SIC,
                    D.DOCU_1_COL_8 HORA_SIC,
                    D.DOCU_1_COL_12 ESTABLORIGEN,
                    D.DOCU_1_COL_15 ESPECORIGEN,
                    D.DOCU_1_COL_72 ESTABLDESTINO,
                    D.DOCU_1_COL_74 ESPECDESTINO,
                    D.DOCU_1_COL_78 ES_AUGE,
                    D.DOCU_1_COL_6016 DERIVADA_PARA,
                    D.DOCU_1_COL_82 COD_RAMA,
                    D.DOCU_1_COL_95 RUN_PROFESIONAL,
                    D.DOCU_1_COL_97 DV_PROFESIONAL,
                    R.REGESTINSDOC_FEC_VIGE FEC_DIGITACION,
                    R.USUA_COD_USUA USUARIO_DIGITA,
                    R.UNI_COD_UNI UNIDAD_DIGITA
               FROM sis.sis_tab_DOCU_1 D,
                    sis.SIS_TAB_REGESTINSDOC R
              WHERE     D.DOCU_1_COL_105 > v_ultimo_anterior
                    AND D.DOCU_1_COL_105 <= p_HastaPK
                    AND D.DOCU_1_COL_104 > 0
                    AND R.REGESTINSDOC_NUM_VALORPK = D.DOCU_1_COL_105
                    AND R.CAMP_COD_CAMP = 105
                    AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
                    AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
                    AND R.REGESTINSDOC_FEC_VCTO IS NULL)
                    --AND ROWNUM <= MaxRegistros)
      LOOP
         BEGIN
            v_caso_valido := 'SI';

            SELECT C.CASOBENEF_COD_CASOBENEF
              INTO k
              FROM sis.SIS_TAB_CASOBENEF C
             WHERE C.CASOBENEF_COD_CASOBENEF = doc.ID_CASO        --1020251434
                   AND C.BOO_COD_CASOVALIDO = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_caso_valido := 'NO';                              --no valido
         END;

         IF (v_caso_valido = 'SI')
         THEN
            INSERT INTO ENDECA.ENDECA_TAB_SIC (CPROCESO_ID_PROCESO,
                                               ID_SIC,
                                               ID_CASO,
                                               FOLIO_SIC,
                                               FECHA_SIC,
                                               HORA_SIC,
                                               ESTABLORIGEN,
                                               ESPECORIGEN,
                                               ESTABLDESTINO,
                                               ESPECDESTINO,
                                               ES_AUGE,
                                               DERIVADA_PARA,
                                               COD_RAMA,
                                               RUN_PROFESIONAL,
                                               DV_PROFESIONAL,
                                               FEC_DIGITACION,
                                               USUARIO_DIGITA,
                                               UNIDAD_DIGITA)
                 VALUES (v_id_proceso,               /* CPROCESO_ID_PROCESO */
                         doc.ID_SIC,                              /* ID_SIC */
                         doc.ID_CASO,                            /* ID_CASO */
                         doc.FOLIO_SIC,                        /* FOLIO_SIC */
                         doc.FECHA_SIC,                        /* FECHA_SIC */
                         doc.HORA_SIC,                          /* HORA_SIC */
                         doc.ESTABLORIGEN,                  /* ESTABLORIGEN */
                         doc.ESTABLORIGEN,                   /* ESPECORIGEN */
                         doc.ESTABLDESTINO,                /* ESTABLDESTINO */
                         doc.ESPECDESTINO,                  /* ESPECDESTINO */
                         doc.ES_AUGE,                            /* ES_AUGE */
                         doc.DERIVADA_PARA,                /* DERIVADA_PARA */
                         doc.COD_RAMA,                          /* COD_RAMA */
                         doc.RUN_PROFESIONAL,            /* RUN_PROFESIONAL */
                         doc.DV_PROFESIONAL,              /* DV_PROFESIONAL */
                         doc.FEC_DIGITACION,              /* FEC_DIGITACION */
                         doc.USUARIO_DIGITA,              /* USUARIO_DIGITA */
                         doc.UNIDAD_DIGITA);               /* UNIDAD_DIGITA */

            num_insert_rows := num_insert_rows + 1;

            IF (MOD (num_insert_rows, 1000) = 0)
            THEN
               endeca_pck_log.endeca_pro_Avance (
                  v_id_proceso,
                  ' AVANCE '
                  || TO_CHAR ( (num_insert_rows / num_total_rows) * 100,
                              '990.0')
                  || '%');

               SELECT TO_NUMBER (PARA_DSC_VALOR)
                 INTO Flag
                 FROM SIS.SIS_TAB_PARA
                WHERE PARA_COD_PARA = 50585;

               IF Flag <> 1
               THEN
                  RAISE PROCESO_ABORTADO;
               END IF;

               COMMIT;
            END IF;

            IF (num_insert_rows = 1)
            THEN
               primera_pk := doc.ID_SIC;
               primera_Fecha := NULL;
               ultima_Fecha := NULL;
               ultima_pk := doc.ID_SIC;
               endeca_pck_log.endeca_pro_SetLeidos (v_id_proceso,
                                                    num_total_rows);
            END IF;

            IF doc.ID_SIC < primera_pk
            THEN
               primera_pk := doc.ID_SIC;
               primera_Fecha := NULL;
            END IF;

            IF doc.ID_SIC > ultima_pk
            THEN
               ultima_pk := doc.ID_SIC;
               ultima_Fecha := NULL;
            END IF;
         END IF;                                                -- caso valido
      END LOOP;

      COMMIT;
      endeca_pck_log.endeca_pro_SetProcesados (v_id_proceso, num_insert_rows);
      endeca_pck_log.endeca_pro_SetPK (v_id_proceso, primera_pk, ultima_pk);
      endeca_pck_log.endeca_pro_SetFecha (v_id_proceso,
                                          primera_Fecha,
                                          ultima_Fecha);
      endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_OK');
   EXCEPTION
      WHEN PROCESO_ABORTADO
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || '  Abortado por Usuario Operador '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'ABORTADO ');
      WHEN OTHERS
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || ' Error en endeca_fun_GetPkAnterior '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_ERR');
   END;                                                         -- FIN_FRM_SIC

   PROCEDURE ENDECA_PRC_CARGA_FRM_HD (p_HastaPK NUMBER)
   IS
      num_total_rows      NUMBER (15);
      num_insert_rows     NUMBER (15);
      ultima_pk           NUMBER (15);
      primera_pk          NUMBER (15);
      ultima_Fecha        TIMESTAMP (6);
      primera_Fecha       TIMESTAMP (6);
      v_ultimo_anterior   NUMBER (15);
      codigoProceso       VARCHAR2 (25);
      v_id_proceso        NUMBER (15);
      v_ficha_Clinica     VARCHAR2 (20 BYTE);
      v_Direccion         VARCHAR2 (256 BYTE);
      v_Comuna            NUMBER (12);
      v_telefono          VARCHAR2 (20 BYTE);
      errnum              NUMBER (12);
      errmsg              VARCHAR2 (200);
      MaxRegistros        NUMBER (15);
      PROCESO_ABORTADO    EXCEPTION;
      Flag                NUMBER (2);
      v_caso_valido       VARCHAR2 (2) := 'SI';
      k                   NUMBER (15);
   BEGIN
      codigoProceso := 'Carga FRM_HD Nuevo';
      v_id_proceso := endeca_pck_log.endeca_fun_IniciaProceso (codigoProceso);
      num_insert_rows := 0;
      v_ultimo_anterior :=
         endeca_pck_log.endeca_fun_GetPkAnterior (codigoProceso);

      IF v_ultimo_anterior = 0
      THEN
         --v_ultimo_anterior := 1007158697 - 1; -- para que inicie desde 01-01-2010
         v_ultimo_anterior := 41325-1; -- para que inicie desde 01-01-2010
      END IF;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Registrada:' || v_ultimo_anterior);

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Considerada:' || p_HastaPK);

      SELECT TO_NUMBER (PARA_DSC_VALOR)
        INTO MaxRegistros
        FROM SIS.SIS_TAB_PARA
       WHERE PARA_COD_PARA = 50583;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (v_id_proceso,
                                            'MaxRegistros:' || MaxRegistros);

      /**/
      SELECT COUNT (1)
        INTO num_total_rows
        FROM sis.sis_tab_DOCU_32 D,
             sis.SIS_TAB_REGESTINSDOC R
       WHERE     D.DOCU_32_COL_8000 > v_ultimo_anterior
             AND D.DOCU_32_COL_8000 <= p_HastaPK
             AND D.DOCU_32_COL_8013 > 0
             AND D.DOCU_32_COL_8003 >= to_date('01/07/2005','DD/MM/RRRR')
             AND R.REGESTINSDOC_NUM_VALORPK = D.DOCU_32_COL_8000
             AND R.CAMP_COD_CAMP = 8000
             AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
             AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
             AND R.REGESTINSDOC_FEC_VCTO IS NULL;
             --AND ROWNUM <= MaxRegistros;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'num_total_rows:' || num_total_rows);

      /**/
      FOR doc
         IN (SELECT D.DOCU_32_COL_8000 ID_HD,
                    D.DOCU_32_COL_8013 ID_CASO,
                    D.DOCU_32_COL_8003 FECHA_HD,
                    D.DOCU_32_COL_8866 HORA_HD,
                    D.DOCU_32_COL_8002 COD_ESTABLECIM,
                    D.DOCU_32_COL_8865 COD_ESPECIALIDAD,
                    D.DOCU_32_COL_8011 COD_RAMA,
                    D.DOCU_32_COL_8012 ESTADO_PS_HD,
                    D.DOCU_32_COL_8004 RUN_PROFESIONAL,
                    D.DOCU_32_COL_8005 DV_PROFESIONAL,
                    R.REGESTINSDOC_FEC_VIGE FEC_DIGITACION,
                    R.USUA_COD_USUA USUARIO_DIGITA,
                    R.UNI_COD_UNI UNIDAD_DIGITA
               FROM sis.sis_tab_DOCU_32 D,
                    sis.SIS_TAB_REGESTINSDOC R
              WHERE     D.DOCU_32_COL_8000 > v_ultimo_anterior
                    AND D.DOCU_32_COL_8000 <= p_HastaPK
                    AND D.DOCU_32_COL_8013 > 0
                    AND R.REGESTINSDOC_NUM_VALORPK = D.DOCU_32_COL_8000
                    AND R.CAMP_COD_CAMP = 8000
                    AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
                    AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
                    AND R.REGESTINSDOC_FEC_VCTO IS NULL)
                    --AND ROWNUM <= MaxRegistros)
      LOOP
         BEGIN
            v_caso_valido := 'SI';

            SELECT C.CASOBENEF_COD_CASOBENEF
              INTO k
              FROM sis.SIS_TAB_CASOBENEF C
             WHERE C.CASOBENEF_COD_CASOBENEF = doc.ID_CASO        --1020251434
                   AND C.BOO_COD_CASOVALIDO = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_caso_valido := 'NO';                              --no valido
         END;

         IF (v_caso_valido = 'SI')
         THEN
            INSERT INTO ENDECA.ENDECA_TAB_HD (CPROCESO_ID_PROCESO,
                                              ID_HD,
                                              ID_CASO,
                                              FECHA_HD,
                                              HORA_HD,
                                              COD_ESTABLECIM,
                                              COD_ESPECIALIDAD,
                                              COD_RAMA,
                                              ESTADO_PS_HD,
                                              RUN_PROFESIONAL,
                                              DV_PROFESIONAL,
                                              FEC_DIGITACION,
                                              USUARIO_DIGITA,
                                              UNIDAD_DIGITA)
                 VALUES (v_id_proceso,               /* CPROCESO_ID_PROCESO */
                         doc.ID_HD,                                /* ID_HD */
                         doc.ID_CASO,                            /* ID_CASO */
                         doc.FECHA_HD,                          /* FECHA_HD */
                         doc.HORA_HD,                            /* HORA_HD */
                         doc.COD_ESTABLECIM,              /* COD_ESTABLECIM */
                         doc.COD_ESPECIALIDAD,          /* COD_ESPECIALIDAD */
                         doc.COD_RAMA,                          /* COD_RAMA */
                         doc.ESTADO_PS_HD,                  /* ESTADO_PS_HD */
                         doc.RUN_PROFESIONAL,            /* RUN_PROFESIONAL */
                         doc.DV_PROFESIONAL,              /* DV_PROFESIONAL */
                         doc.FEC_DIGITACION,              /* FEC_DIGITACION */
                         doc.USUARIO_DIGITA,              /* USUARIO_DIGITA */
                         doc.UNIDAD_DIGITA);               /* UNIDAD_DIGITA */

            num_insert_rows := num_insert_rows + 1;

            IF (MOD (num_insert_rows, 1000) = 0)
            THEN
               endeca_pck_log.endeca_pro_Avance (
                  v_id_proceso,
                  ' AVANCE '
                  || TO_CHAR ( (num_insert_rows / num_total_rows) * 100,
                              '990.0')
                  || '%');

               SELECT TO_NUMBER (PARA_DSC_VALOR)
                 INTO Flag
                 FROM SIS.SIS_TAB_PARA
                WHERE PARA_COD_PARA = 50586;

               IF Flag <> 1
               THEN
                  RAISE PROCESO_ABORTADO;
               END IF;

               COMMIT;
            END IF;

            IF (num_insert_rows = 1)
            THEN
               primera_pk := doc.ID_HD;
               primera_Fecha := NULL;
               ultima_Fecha := NULL;
               ultima_pk := doc.ID_HD;
               endeca_pck_log.endeca_pro_SetLeidos (v_id_proceso,
                                                    num_total_rows);
            END IF;

            IF doc.ID_HD < primera_pk
            THEN
               primera_pk := doc.ID_HD;
               primera_Fecha := NULL;
            END IF;

            IF doc.ID_HD > ultima_pk
            THEN
               ultima_pk := doc.ID_HD;
               ultima_Fecha := NULL;
            END IF;
         END IF;                                                -- caso valido
      END LOOP;

      COMMIT;
      endeca_pck_log.endeca_pro_SetProcesados (v_id_proceso, num_insert_rows);
      endeca_pck_log.endeca_pro_SetPK (v_id_proceso, primera_pk, ultima_pk);
      endeca_pck_log.endeca_pro_SetFecha (v_id_proceso,
                                          primera_Fecha,
                                          ultima_Fecha);
      endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_OK');
   EXCEPTION
      WHEN PROCESO_ABORTADO
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || '  Abortado por Usuario Operador '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'ABORTADO ');
      WHEN OTHERS
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || ' Error en endeca_fun_GetPkAnterior '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_ERR');
   END;                                                          -- FIN FRM_HD

   PROCEDURE ENDECA_PRC_CARGA_FRM_EXCGO (p_HastaPK NUMBER)
   IS
      num_total_rows      NUMBER (15);
      num_insert_rows     NUMBER (15);
      ultima_pk           NUMBER (15);
      primera_pk          NUMBER (15);
      ultima_Fecha        TIMESTAMP (6);
      primera_Fecha       TIMESTAMP (6);
      v_ultimo_anterior   NUMBER (15);
      codigoProceso       VARCHAR2 (25);
      v_id_proceso        NUMBER (15);
      v_ficha_Clinica     VARCHAR2 (20 BYTE);
      v_Direccion         VARCHAR2 (256 BYTE);
      v_Comuna            NUMBER (12);
      v_telefono          VARCHAR2 (20 BYTE);
      errnum              NUMBER (12);
      errmsg              VARCHAR2 (200);
      MaxRegistros        NUMBER (15);
      PROCESO_ABORTADO    EXCEPTION;
      Flag                NUMBER (2);
      v_caso_valido       VARCHAR2 (2) := 'SI';
      k                   NUMBER (15);
   BEGIN
      codigoProceso := 'Carga FRM_EXCGO Nuevo';
      v_id_proceso := endeca_pck_log.endeca_fun_IniciaProceso (codigoProceso);
      num_insert_rows := 0;
      v_ultimo_anterior :=
         endeca_pck_log.endeca_fun_GetPkAnterior (codigoProceso);

      IF v_ultimo_anterior = 0
      THEN
         --v_ultimo_anterior := 1000363749 - 1; -- para que inicie desde 01-01-2010 en este caso sera del 02-01-2010
         v_ultimo_anterior := 57-1;
      END IF;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Registrada:' || v_ultimo_anterior);

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Considerada:' || p_HastaPK);

      SELECT TO_NUMBER (PARA_DSC_VALOR)
        INTO MaxRegistros
        FROM SIS.SIS_TAB_PARA
       WHERE PARA_COD_PARA = 50583;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (v_id_proceso,
                                            'MaxRegistros:' || MaxRegistros);

      /**/
      SELECT COUNT (1)
        INTO num_total_rows
        FROM sis.sis_tab_DOCU_34 D,
             sis.SIS_TAB_REGESTINSDOC R
       WHERE     D.DOCU_34_COL_8200 > v_ultimo_anterior
             AND D.DOCU_34_COL_8200 <= p_HastaPK
             AND D.DOCU_34_COL_8202 >= to_date('01/07/2005','DD/MM/RRRR')
             AND R.REGESTINSDOC_NUM_VALORPK = D.DOCU_34_COL_8200
             AND R.CAMP_COD_CAMP = 8200
             AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
             AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
             AND R.REGESTINSDOC_FEC_VCTO IS NULL;
             --AND ROWNUM <= MaxRegistros;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'num_total_rows:' || num_total_rows);

      /**/
      FOR doc
         IN (SELECT D.DOCU_34_COL_8200 ID_EXCGO,
                    D.DOCU_34_COL_8207 ID_CASO,
                    D.DOCU_34_COL_8202 FECHA_EXCGO,
                    D.DOCU_34_COL_8203 HORA_EXCGO,
                    D.DOCU_34_COL_8201 COD_ESTABLECIM,
                    D.DOCU_34_COL_8229 COD_ESPECIALIDAD,
                    D.DOCU_34_COL_8208 CODIGO_GO,
                    D.DOCU_34_COL_8209 CAUSAL_EXCEPCION,
                    D.DOCU_34_COL_8214 COD_PROFESIONAL,
                    R.REGESTINSDOC_FEC_VIGE FEC_DIGITACION,
                    R.USUA_COD_USUA USUARIO_DIGITA,
                    R.UNI_COD_UNI UNIDAD_DIGITA
               FROM sis.sis_tab_DOCU_34 D,
                    sis.SIS_TAB_REGESTINSDOC R
              WHERE     D.DOCU_34_COL_8200 > v_ultimo_anterior
                    AND D.DOCU_34_COL_8200 <= p_HastaPK
                    AND R.REGESTINSDOC_NUM_VALORPK = D.DOCU_34_COL_8200
                    AND R.CAMP_COD_CAMP = 8200
                    AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
                    AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
                    AND R.REGESTINSDOC_FEC_VCTO IS NULL)
                    --AND ROWNUM <= MaxRegistros)
      LOOP
         BEGIN
            v_caso_valido := 'SI';

            SELECT C.CASOBENEF_COD_CASOBENEF
              INTO k
              FROM sis.SIS_TAB_CASOBENEF C
             WHERE C.CASOBENEF_COD_CASOBENEF = doc.ID_CASO        --1020251434
                   AND C.BOO_COD_CASOVALIDO = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_caso_valido := 'NO';                              --no valido
         END;

         IF (v_caso_valido = 'SI')
         THEN
            INSERT INTO ENDECA.ENDECA_TAB_EXCGO (CPROCESO_ID_PROCESO,
                                                 ID_EXCGO,
                                                 ID_CASO,
                                                 FECHA_EXCGO,
                                                 HORA_EXCGO,
                                                 COD_ESTABLECIM,
                                                 COD_ESPECIALIDAD,
                                                 CODIGO_GO,
                                                 CAUSAL_EXCEPCION,
                                                 COD_PROFESIONAL,
                                                 FEC_DIGITACION,
                                                 USUARIO_DIGITA,
                                                 UNIDAD_DIGITA)
                 VALUES (v_id_proceso,               /* CPROCESO_ID_PROCESO */
                         doc.ID_EXCGO,                          /* ID_EXCGO */
                         doc.ID_CASO,                            /* ID_CASO */
                         doc.FECHA_EXCGO,                    /* FECHA_EXCGO */
                         doc.HORA_EXCGO,                      /* HORA_EXCGO */
                         doc.COD_ESTABLECIM,              /* COD_ESTABLECIM */
                         doc.COD_ESPECIALIDAD,          /* COD_ESPECIALIDAD */
                         doc.CODIGO_GO,                        /* CODIGO_GO */
                         doc.CAUSAL_EXCEPCION,          /* CAUSAL_EXCEPCION */
                         doc.COD_PROFESIONAL,            /* COD_PROFESIONAL */
                         doc.FEC_DIGITACION,              /* FEC_DIGITACION */
                         doc.USUARIO_DIGITA,              /* USUARIO_DIGITA */
                         doc.UNIDAD_DIGITA);               /* UNIDAD_DIGITA */

            num_insert_rows := num_insert_rows + 1;

            IF (MOD (num_insert_rows, 1000) = 0)
            THEN
               endeca_pck_log.endeca_pro_Avance (
                  v_id_proceso,
                  ' AVANCE '
                  || TO_CHAR ( (num_insert_rows / num_total_rows) * 100,
                              '990.0')
                  || '%');

               SELECT TO_NUMBER (PARA_DSC_VALOR)
                 INTO Flag
                 FROM SIS.SIS_TAB_PARA
                WHERE PARA_COD_PARA = 50586;

               IF Flag <> 1
               THEN
                  RAISE PROCESO_ABORTADO;
               END IF;

               COMMIT;
            END IF;

            IF (num_insert_rows = 1)
            THEN
               primera_pk := doc.ID_EXCGO;
               primera_Fecha := NULL;
               ultima_Fecha := NULL;
               ultima_pk := doc.ID_EXCGO;
               endeca_pck_log.endeca_pro_SetLeidos (v_id_proceso,
                                                    num_total_rows);
            END IF;

            IF doc.ID_EXCGO < primera_pk
            THEN
               primera_pk := doc.ID_EXCGO;
               primera_Fecha := NULL;
            END IF;

            IF doc.ID_EXCGO > ultima_pk
            THEN
               ultima_pk := doc.ID_EXCGO;
               ultima_Fecha := NULL;
            END IF;
         END IF;                                                -- caso valido
      END LOOP;

      COMMIT;
      endeca_pck_log.endeca_pro_SetProcesados (v_id_proceso, num_insert_rows);
      endeca_pck_log.endeca_pro_SetPK (v_id_proceso, primera_pk, ultima_pk);
      endeca_pck_log.endeca_pro_SetFecha (v_id_proceso,
                                          primera_Fecha,
                                          ultima_Fecha);
      endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_OK');
   EXCEPTION
      WHEN PROCESO_ABORTADO
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || '  Abortado por Usuario Operador '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'ABORTADO ');
      WHEN OTHERS
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || ' Error en endeca_fun_GetPkAnterior '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_ERR');
   END;                                                       -- FIN FRM_EXCGO

   PROCEDURE ENDECA_PRC_CARGA_FRM_CC (p_HastaPK NUMBER)
   IS
      num_total_rows      NUMBER (15);
      num_insert_rows     NUMBER (15);
      ultima_pk           NUMBER (15);
      primera_pk          NUMBER (15);
      ultima_Fecha        TIMESTAMP (6);
      primera_Fecha       TIMESTAMP (6);
      v_ultimo_anterior   NUMBER (15);
      codigoProceso       VARCHAR2 (25);
      v_id_proceso        NUMBER (15);
      v_ficha_Clinica     VARCHAR2 (20 BYTE);
      v_Direccion         VARCHAR2 (256 BYTE);
      v_Comuna            NUMBER (12);
      v_telefono          VARCHAR2 (20 BYTE);
      errnum              NUMBER (12);
      errmsg              VARCHAR2 (200);
      MaxRegistros        NUMBER (15);
      PROCESO_ABORTADO    EXCEPTION;
      Flag                NUMBER (2);
      v_caso_valido       VARCHAR2 (2) := 'SI';
      k                   NUMBER (15);
   BEGIN
      codigoProceso := 'Carga FRM_CC Nuevo';
      v_id_proceso := endeca_pck_log.endeca_fun_IniciaProceso (codigoProceso);
      num_insert_rows := 0;
      v_ultimo_anterior := 3275 - 1;
       --endeca_pck_log.endeca_fun_GetPkAnterior (codigoProceso);

      IF v_ultimo_anterior = 0
      THEN
         --v_ultimo_anterior := 3275 - 1; -- para que considere desde el 01-07-2005
         v_ultimo_anterior := 3275 - 1;
      END IF;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Registrada:' || v_ultimo_anterior);

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Considerada:' || p_HastaPK);

      SELECT TO_NUMBER (PARA_DSC_VALOR)
        INTO MaxRegistros
        FROM SIS.SIS_TAB_PARA
       WHERE PARA_COD_PARA = 50583;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (v_id_proceso,
                                            'MaxRegistros:' || MaxRegistros);

      /**/
      SELECT COUNT (1)
        INTO num_total_rows
        FROM sis.SIS_TAB_CIERRECASO D,
             sis.SIS_TAB_REGESTINSDOC R
       WHERE     D.CIERRECASO_COD_CIERRECASO > v_ultimo_anterior
             AND D.CIERRECASO_COD_CIERRECASO <= p_HastaPK
             AND D.CIERRECASO_FEC_CIERRECASO >= to_date('01/07/2005','DD/MM/RRRR')
             AND R.REGESTINSDOC_NUM_VALORPK = D.CIERRECASO_COD_CIERRECASO
             AND R.CAMP_COD_CAMP = 6000
             AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
             AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
             AND R.REGESTINSDOC_FEC_VCTO IS NULL;
             --AND ROWNUM <= MaxRegistros;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'num_total_rows:' || num_total_rows);

      /**/
      FOR doc
         IN (SELECT                       /*+ INDEX(R SIS_INDX_VALOR_PK_01) */
                   D.CIERRECASO_COD_CIERRECASO ID_CC,
                    D.CASOBENEF_COD_CASOBENEF ID_CASO,
                    D.CIERRECASO_FEC_CIERRECASO FECHA_CC,
                    D.CIERRECASO_HORA_CIERRECASO HORA_CC,
                    D.CIERRECASO_NUM_FOLIO FOLIO_DOCUMENTO,
                    D.UNI_COD_EST COD_ESTABLECIM,
                    D.ESPECIALIDAD_COD_ESPECIALIDAD COD_ESPECIALIDAD,
                    D.TIPCIECA_COD_TIPCIECA CAUSAL_CIERRE_CASO,
                    D.PROFESIONAL_COD_PROFESIONAL COD_PROFESIONAL,
                    R.REGESTINSDOC_FEC_VIGE FEC_DIGITACION,
                    R.USUA_COD_USUA USUARIO_DIGITA,
                    R.UNI_COD_UNI UNIDAD_DIGITA
               FROM sis.SIS_TAB_CIERRECASO D,
                    sis.SIS_TAB_REGESTINSDOC R
              WHERE D.CIERRECASO_COD_CIERRECASO > v_ultimo_anterior
                    AND D.CIERRECASO_COD_CIERRECASO <= p_HastaPK
                    AND R.REGESTINSDOC_NUM_VALORPK =
                           D.CIERRECASO_COD_CIERRECASO
                    AND R.CAMP_COD_CAMP = 6000
                    AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
                    AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
                    AND R.REGESTINSDOC_FEC_VCTO IS NULL)
                    --AND ROWNUM <= MaxRegistros)
      LOOP
         BEGIN
            v_caso_valido := 'SI';

            SELECT C.CASOBENEF_COD_CASOBENEF
              INTO k
              FROM sis.SIS_TAB_CASOBENEF C
             WHERE C.CASOBENEF_COD_CASOBENEF = doc.ID_CASO        --1020251434
                   AND C.BOO_COD_CASOVALIDO = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_caso_valido := 'NO';                              --no valido
         END;

         IF (v_caso_valido = 'SI')
         THEN
            INSERT INTO ENDECA.ENDECA_TAB_CC (CPROCESO_ID_PROCESO,
                                              ID_CC,
                                              ID_CASO,
                                              FECHA_CC,
                                              HORA_CC,
                                              FOLIO_DOCUMENTO,
                                              COD_ESTABLECIM,
                                              COD_ESPECIALIDAD,
                                              CAUSAL_CIERRE_CASO,
                                              COD_PROFESIONAL,
                                              FEC_DIGITACION,
                                              USUARIO_DIGITA,
                                              UNIDAD_DIGITA)
                 VALUES (v_id_proceso,               /* CPROCESO_ID_PROCESO */
                         doc.ID_CC,                                /* ID_CC */
                         doc.ID_CASO,                            /* ID_CASO */
                         doc.FECHA_CC,                          /* FECHA_CC */
                         TO_CHAR (doc.HORA_CC, 'hh24:mi'),       /* HORA_CC */
                         doc.FOLIO_DOCUMENTO,            /* FOLIO_DOCUMENTO */
                         doc.COD_ESTABLECIM,              /* COD_ESTABLECIM */
                         doc.COD_ESPECIALIDAD,          /* COD_ESPECIALIDAD */
                         doc.CAUSAL_CIERRE_CASO,      /* CAUSAL_CIERRE_CASO */
                         doc.COD_PROFESIONAL,            /* COD_PROFESIONAL */
                         doc.FEC_DIGITACION,              /* FEC_DIGITACION */
                         doc.USUARIO_DIGITA,              /* USUARIO_DIGITA */
                         doc.UNIDAD_DIGITA);               /* UNIDAD_DIGITA */

            num_insert_rows := num_insert_rows + 1;

            IF (MOD (num_insert_rows, 1000) = 0)
            THEN
               endeca_pck_log.endeca_pro_Avance (
                  v_id_proceso,
                  ' AVANCE '
                  || TO_CHAR ( (num_insert_rows / num_total_rows) * 100,
                              '990.0')
                  || '%');

               SELECT TO_NUMBER (PARA_DSC_VALOR)
                 INTO Flag
                 FROM SIS.SIS_TAB_PARA
                WHERE PARA_COD_PARA = 50586;

               IF Flag <> 1
               THEN
                  RAISE PROCESO_ABORTADO;
               END IF;

               COMMIT;
            END IF;

            IF (num_insert_rows = 1)
            THEN
               primera_pk := doc.ID_CC;
               primera_Fecha := NULL;
               ultima_Fecha := NULL;
               ultima_pk := doc.ID_CC;
               endeca_pck_log.endeca_pro_SetLeidos (v_id_proceso,
                                                    num_total_rows);
            END IF;

            IF doc.ID_CC < primera_pk
            THEN
               primera_pk := doc.ID_CC;
               primera_Fecha := NULL;
            END IF;

            IF doc.ID_CC > ultima_pk
            THEN
               ultima_pk := doc.ID_CC;
               ultima_Fecha := NULL;
            END IF;
         END IF;                                                -- caso valido
      END LOOP;

      COMMIT;
      endeca_pck_log.endeca_pro_SetProcesados (v_id_proceso, num_insert_rows);
      endeca_pck_log.endeca_pro_SetPK (v_id_proceso, primera_pk, ultima_pk);
      endeca_pck_log.endeca_pro_SetFecha (v_id_proceso,
                                          primera_Fecha,
                                          ultima_Fecha);
      endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_OK');
   EXCEPTION
      WHEN PROCESO_ABORTADO
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || '  Abortado por Usuario Operador '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'ABORTADO ');
      WHEN OTHERS
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || ' Error en endeca_fun_GetPkAnterior '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_ERR');
   END;                                                          -- FIN FRM_CC

   PROCEDURE ENDECA_PRC_CARGA_FRM_CAC (p_HastaPK NUMBER)
   IS
      num_total_rows      NUMBER (15);
      num_insert_rows     NUMBER (15);
      ultima_pk           NUMBER (15);
      primera_pk          NUMBER (15);
      ultima_Fecha        TIMESTAMP (6);
      primera_Fecha       TIMESTAMP (6);
      v_ultimo_anterior   NUMBER (15);
      codigoProceso       VARCHAR2 (25);
      v_id_proceso        NUMBER (15);
      v_ficha_Clinica     VARCHAR2 (20 BYTE);
      v_Direccion         VARCHAR2 (256 BYTE);
      v_Comuna            NUMBER (12);
      v_telefono          VARCHAR2 (20 BYTE);
      errnum              NUMBER (12);
      errmsg              VARCHAR2 (200);
      MaxRegistros        NUMBER (15);
      PROCESO_ABORTADO    EXCEPTION;
      Flag                NUMBER (2);
      v_caso_valido       VARCHAR2 (2) := 'SI';
      k                   NUMBER (15);
   BEGIN
      codigoProceso := 'Carga FRM_CAC Nuevo';
      v_id_proceso := endeca_pck_log.endeca_fun_IniciaProceso (codigoProceso);
      num_insert_rows := 0;
      v_ultimo_anterior :=
         endeca_pck_log.endeca_fun_GetPkAnterior (codigoProceso);

      IF v_ultimo_anterior = 0
      THEN
         --v_ultimo_anterior := 196 - 1; -- para que considere desde el 01-07-2005 en este caso del 12-07-2005
         v_ultimo_anterior := 184-1;
      END IF;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Registrada:' || v_ultimo_anterior);

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Considerada:' || p_HastaPK);

      SELECT TO_NUMBER (PARA_DSC_VALOR)
        INTO MaxRegistros
        FROM SIS.SIS_TAB_PARA
       WHERE PARA_COD_PARA = 50583;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (v_id_proceso,
                                            'MaxRegistros:' || MaxRegistros);

      /**/

      SELECT COUNT (1)
        INTO num_total_rows
        FROM sis.SIS_TAB_DOCU_33 D,
             sis.SIS_TAB_REGESTINSDOC R,
             sis.SIS_TAB_CASOBENEF C
       WHERE     D.DOCU_33_COL_8100 > v_ultimo_anterior --196 es el primero encontrado desde el 01-07-2005 en adelante (12-07-2005)
             AND D.DOCU_33_COL_8100 <= p_HastaPK
             AND D.DOCU_33_COL_8102 >= to_date('01/07/2005','DD/MM/RRRR')
	     AND C.CASOBENEF_COD_CASOBENEF = D.DOCU_33_COL_8115
             AND C.BOO_COD_CASOVALIDO = 1
             AND R.REGESTINSDOC_NUM_VALORPK = D.DOCU_33_COL_8100
             AND R.CAMP_COD_CAMP = 8100
             AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
             AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
             AND R.REGESTINSDOC_FEC_VCTO IS NULL;
             --AND ROWNUM <= MaxRegistros;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'num_total_rows:' || num_total_rows);

      /**/
      FOR doc
         IN (SELECT                        /*+ INDEX(D SIS_INDX_DOCU_33_C1) */
                   D.DOCU_33_COL_8100 ID_CAC,
                    D.DOCU_33_COL_8115 ID_CASO,
                    D.DOCU_33_COL_8102 FECHA_CAC,
                    D.DOCU_33_COL_8103 HORA_CAC,
                    D.DOCU_33_COL_8101 FOLIO_DOCUMENTO,
                    D.DOCU_33_COL_8105 COD_ESTABLECIM,
                    D.DOCU_33_COL_8107 COD_ESPECIALIDAD,
                    D.DOCU_33_COL_8118 CAUSAL_CIERRE_CASO,
                    D.DOCU_33_COL_8116 COD_PROFESIONAL,
                    R.REGESTINSDOC_FEC_VIGE FEC_DIGITACION,
                    R.USUA_COD_USUA USUARIO_DIGITA,
                    R.UNI_COD_UNI UNIDAD_DIGITA
               FROM sis.SIS_TAB_DOCU_33 D,
                    sis.SIS_TAB_REGESTINSDOC R,
                    sis.SIS_TAB_CASOBENEF C
              WHERE     D.DOCU_33_COL_8100 > v_ultimo_anterior -- v_ultimo_anterior --196 es el primero encontrado desde el 01-07-2005 en adelante (12-07-2005)
                    AND D.DOCU_33_COL_8100 <= p_HastaPK           -- p_HastaPK
                    AND C.CASOBENEF_COD_CASOBENEF = D.DOCU_33_COL_8115
                    AND C.BOO_COD_CASOVALIDO = 1
                    AND R.REGESTINSDOC_NUM_VALORPK = D.DOCU_33_COL_8100
                    AND R.CAMP_COD_CAMP = 8100
                    AND R.TIPESTVIGINSDOC_COD_TIPESTVIGI = 1
                    AND R.TIPESTVALINSDOC_COD_TIPESTVALI = 1
                    AND R.REGESTINSDOC_FEC_VCTO IS NULL)
                    --AND ROWNUM <= MaxRegistros)
      LOOP
         BEGIN
            v_caso_valido := 'SI';

            SELECT C.CASOBENEF_COD_CASOBENEF
              INTO k
              FROM sis.SIS_TAB_CASOBENEF C
             WHERE C.CASOBENEF_COD_CASOBENEF = doc.ID_CASO        --1020251434
                   AND C.BOO_COD_CASOVALIDO = 1;
         EXCEPTION
            WHEN OTHERS
            THEN
               v_caso_valido := 'NO';                              --no valido
         END;

         IF (v_caso_valido = 'SI')
         THEN
            INSERT INTO ENDECA.ENDECA_TAB_CAC (CPROCESO_ID_PROCESO,
                                               ID_CAC,
                                               ID_CASO,
                                               FECHA_CAC,
                                               HORA_CAC,
                                               FOLIO_DOCUMENTO,
                                               COD_ESTABLECIM,
                                               COD_ESPECIALIDAD,
                                               CAUSAL_CIERRE_CASO,
                                               COD_PROFESIONAL,
                                               FEC_DIGITACION,
                                               USUARIO_DIGITA,
                                               UNIDAD_DIGITA)
                 VALUES (v_id_proceso,               /* CPROCESO_ID_PROCESO */
                         doc.ID_CAC,                              /* ID_CAC */
                         doc.ID_CASO,                            /* ID_CASO */
                         doc.FECHA_CAC,                        /* FECHA_CAC */
                         doc.HORA_CAC,                          /* HORA_CAC */
                         doc.FOLIO_DOCUMENTO,            /* FOLIO_DOCUMENTO */
                         doc.COD_ESTABLECIM,              /* COD_ESTABLECIM */
                         doc.COD_ESPECIALIDAD,          /* COD_ESPECIALIDAD */
                         doc.CAUSAL_CIERRE_CASO,      /* CAUSAL_CIERRE_CASO */
                         doc.COD_PROFESIONAL,            /* COD_PROFESIONAL */
                         doc.FEC_DIGITACION,              /* FEC_DIGITACION */
                         doc.USUARIO_DIGITA,              /* USUARIO_DIGITA */
                         doc.UNIDAD_DIGITA);               /* UNIDAD_DIGITA */

            num_insert_rows := num_insert_rows + 1;

            IF (MOD (num_insert_rows, 1000) = 0)
            THEN
               endeca_pck_log.endeca_pro_Avance (
                  v_id_proceso,
                  ' AVANCE '
                  || TO_CHAR ( (num_insert_rows / num_total_rows) * 100,
                              '990.0')
                  || '%');

               SELECT TO_NUMBER (PARA_DSC_VALOR)
                 INTO Flag
                 FROM SIS.SIS_TAB_PARA
                WHERE PARA_COD_PARA = 50586;

               IF Flag <> 1
               THEN
                  RAISE PROCESO_ABORTADO;
               END IF;

               COMMIT;
            END IF;

            IF (num_insert_rows = 1)
            THEN
               primera_pk := doc.ID_CAC;
               primera_Fecha := NULL;
               ultima_Fecha := NULL;
               ultima_pk := doc.ID_CAC;
               endeca_pck_log.endeca_pro_SetLeidos (v_id_proceso,
                                                    num_total_rows);
            END IF;

            IF doc.ID_CAC < primera_pk
            THEN
               primera_pk := doc.ID_CAC;
               primera_Fecha := NULL;
            END IF;

            IF doc.ID_CAC > ultima_pk
            THEN
               ultima_pk := doc.ID_CAC;
               ultima_Fecha := NULL;
            END IF;
         END IF;                                                -- caso valido
      END LOOP;

      COMMIT;
      endeca_pck_log.endeca_pro_SetProcesados (v_id_proceso, num_insert_rows);
      endeca_pck_log.endeca_pro_SetPK (v_id_proceso, primera_pk, ultima_pk);
      endeca_pck_log.endeca_pro_SetFecha (v_id_proceso,
                                          primera_Fecha,
                                          ultima_Fecha);
      endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_OK');
   EXCEPTION
      WHEN PROCESO_ABORTADO
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || '  Abortado por Usuario Operador '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'ABORTADO ');
      WHEN OTHERS
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || ' Error en endeca_fun_GetPkAnterior '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_ERR');
   END;                                                         -- FIN FRM_CAC

   PROCEDURE ENDECA_PRC_CARGA_FRM_OA (p_HastaPK NUMBER)
   IS
      num_total_rows      NUMBER (15);
      num_insert_rows     NUMBER (15);
      ultima_pk           NUMBER (15);
      primera_pk          NUMBER (15);
      ultima_Fecha        TIMESTAMP (6);
      primera_Fecha       TIMESTAMP (6);
      v_ultimo_anterior   NUMBER (15);
      codigoProceso       VARCHAR2 (25);
      v_id_proceso        NUMBER (15);
      v_ficha_Clinica     VARCHAR2 (20 BYTE);
      v_Direccion         VARCHAR2 (256 BYTE);
      v_Comuna            NUMBER (12);
      v_telefono          VARCHAR2 (20 BYTE);
      errnum              NUMBER (12);
      errmsg              VARCHAR2 (200);
      MaxRegistros        NUMBER (15);
      PROCESO_ABORTADO    EXCEPTION;
      Flag                NUMBER (2);
      v_caso_valido       VARCHAR2 (2) := 'SI';
      k                   NUMBER (15);

      CURSOR c2 (p_key NUMBER)
      IS
         SELECT DOCU_3_COL_1081 ID_OA,
                DOCU_11_COL_5204 COD_PRESTACION,
                DOCU_11_COL_6026 DERIVACION_PO,
                DOCU_11_COL_6031 ESPECIALIDAD_DESTINO,
                DOCU_11_COL_6041 EXTRASISTEMA,
                DOCU_11_COL_6029 PRESTADOR_EXTRASISTEMA,
                DOCU_11_COL_5203 ESTABLECIMIENTO_DESTINO
           FROM sis.sis_tab_docu_11
          WHERE DOCU_3_COL_1081 = p_key;
   BEGIN
      codigoProceso := 'Carga FRM_OA Nuevo';
      v_id_proceso := endeca_pck_log.endeca_fun_IniciaProceso (codigoProceso);
      num_insert_rows := 0;

      v_ultimo_anterior :=  4235379 - 1;
         --endeca_pck_log.endeca_fun_GetPkAnterior (codigoProceso);

      IF v_ultimo_anterior = 0
      THEN
         v_ultimo_anterior := 4235379 - 1; -- para que considere desde el 01-07-2005
      END IF;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Registrada:' || v_ultimo_anterior);

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'ultima PK Considerada:' || p_HastaPK);

      SELECT TO_NUMBER (PARA_DSC_VALOR)
        INTO MaxRegistros
        FROM SIS.SIS_TAB_PARA
       WHERE PARA_COD_PARA = 50583;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (v_id_proceso,
                                            'MaxRegistros:' || MaxRegistros);

      /**/

      SELECT                                              /*+ INDEX_DESC(D) */
            COUNT (1)
        INTO num_total_rows
        FROM sis.SIS_TAB_docu_3 D,
             sis.sis_tab_regestinsdoc r
       WHERE     D.docu_3_COL_1081 > v_ultimo_anterior
             AND D.docu_3_COL_1081 <= p_HastaPK
             AND D.docu_3_COL_1079 > 0
             AND D.docu_3_COL_1007 >= to_date('01/07/2005','DD/MM/RRRR')
	     AND r.regestinsdoc_num_valorpk = D.docu_3_COL_1081
             AND r.camp_cod_camp = 1081
             AND r.tipestviginsdoc_cod_tipestvigi = 1
             AND r.tipestvalinsdoc_cod_tipestvali = 1
             AND r.regestinsdoc_fec_vcto IS NULL;
             --AND ROWNUM <= MaxRegistros;

      ENDECA_PCK_LOG.ENDECA_PRO_ESCRIBELOG (
         v_id_proceso,
         'num_total_rows:' || num_total_rows);

      /**/
      FOR doc
         IN (SELECT                                       /*+ INDEX_DESC(D) */
                    D.docu_3_COL_1081 ID_OA,
                    D.docu_3_COL_1079 ID_CASO,
                    D.docu_3_COL_1007 FECHA_OA,
                    D.docu_3_COL_1010 HORA_OA,
                    D.docu_3_COL_1014 COD_ESTABLECIM,
                    D.docu_3_COL_5212 COD_ESPECIALIDAD,
                    D.docu_3_COL_1067 RUN_PROFESIONAL,
                    D.docu_3_COL_1069 DV_PROFESIONAL,
                    R.REGESTINSDOC_FEC_VIGE FEC_DIGITACION,
                    R.USUA_COD_USUA USUARIO_DIGITA,
                    R.UNI_COD_UNI UNIDAD_DIGITA,
                    D.docu_3_COL_1005 FOLIO_OA
               FROM sis.SIS_TAB_docu_3 D,
                    sis.sis_tab_regestinsdoc r
              WHERE     D.docu_3_COL_1081 > v_ultimo_anterior
                    AND D.docu_3_COL_1081 <= p_HastaPK
                    AND D.docu_3_COL_1079 > 0
                    AND r.regestinsdoc_num_valorpk = D.docu_3_COL_1081
                    AND r.camp_cod_camp = 1081
                    AND r.tipestviginsdoc_cod_tipestvigi = 1
                    AND r.tipestvalinsdoc_cod_tipestvali = 1
                    AND r.regestinsdoc_fec_vcto IS NULL)
                    --AND ROWNUM <= MaxRegistros)
      LOOP
         BEGIN
            BEGIN
               v_caso_valido := 'SI';

               SELECT C.CASOBENEF_COD_CASOBENEF
                 INTO k
                 FROM sis.SIS_TAB_CASOBENEF C
                WHERE C.CASOBENEF_COD_CASOBENEF = doc.ID_CASO     --1020251434
                      AND C.BOO_COD_CASOVALIDO = 1;
            EXCEPTION
               WHEN OTHERS
               THEN
                  v_caso_valido := 'NO';                           --no valido
            END;

            IF (v_caso_valido = 'SI')
            THEN
               INSERT INTO ENDECA.ENDECA_TAB_OA (CPROCESO_ID_PROCESO,
                                                 ID_OA,
                                                 ID_CASO,
                                                 FECHA_OA,
                                                 HORA_OA,
                                                 COD_ESTABLECIM,
                                                 COD_ESPECIALIDAD,
                                                 RUN_PROFESIONAL,
                                                 DV_PROFESIONAL,
                                                 FEC_DIGITACION,
                                                 USUARIO_DIGITA,
                                                 UNIDAD_DIGITA,
                                                 FOLIO_OA)
                    VALUES (v_id_proceso,            /* CPROCESO_ID_PROCESO */
                            doc.ID_OA,                             /* ID_OA */
                            doc.ID_CASO,                         /* ID_CASO */
                            doc.FECHA_OA,                       /* FECHA_OA */
                            doc.HORA_OA,                         /* HORA_OA */
                            doc.COD_ESTABLECIM,           /* COD_ESTABLECIM */
                            doc.COD_ESPECIALIDAD,       /* COD_ESPECIALIDAD */
                            doc.RUN_PROFESIONAL,         /* RUN_PROFESIONAL */
                            doc.DV_PROFESIONAL,           /* DV_PROFESIONAL */
                            doc.FEC_DIGITACION,           /* FEC_DIGITACION */
                            doc.USUARIO_DIGITA,           /* USUARIO_DIGITA */
                            doc.UNIDAD_DIGITA,            /* UNIDAD_DIGITA */
                            doc.FOLIO_OA);            /* FOLIO_OA */

               num_insert_rows := num_insert_rows + 1;

               /**********************************************************************/
               IF (num_insert_rows = 1)
               THEN
                  primera_pk := doc.ID_OA;
                  primera_Fecha := NULL;
                  ultima_Fecha := NULL;
                  ultima_pk := doc.ID_OA;
                  endeca_pck_log.endeca_pro_SetLeidos (v_id_proceso,
                                                       num_total_rows);
               END IF;

               IF doc.ID_OA < primera_pk
               THEN
                  primera_pk := doc.ID_OA;
                  primera_Fecha := NULL;
               END IF;

               IF doc.ID_OA > ultima_pk
               THEN
                  ultima_pk := doc.ID_OA;
                  ultima_Fecha := NULL;
               END IF;

               FOR det IN c2 (doc.ID_OA)
               LOOP
                  BEGIN
                     INSERT
                       INTO ENDECA.ENDECA_TAB_OAPO (CPROCESO_ID_PROCESO,
                                                    ID_OA,
                                                    COD_PRESTACION,
                                                    DERIVACION_PO,
                                                    ESPECIALIDAD_DESTINO,
                                                    EXTRASISTEMA,
                                                    PRESTADOR_EXTRASISTEMA,
                                                    ESTABLECIMIENTO_DESTINO)
                     VALUES (v_id_proceso,           /* CPROCESO_ID_PROCESO */
                             doc.ID_OA,                            /* ID_OA */
                             det.COD_PRESTACION,          /* COD_PRESTACION */
                             det.DERIVACION_PO,            /* DERIVACION_PO */
                             det.ESPECIALIDAD_DESTINO, /* ESPECIALIDAD_DESTINO */
                             det.EXTRASISTEMA,              /* EXTRASISTEMA */
                             det.PRESTADOR_EXTRASISTEMA, /* PRESTADOR_EXTRASISTEMA */
                             det.ESTABLECIMIENTO_DESTINO); /* ESTABLECIMIENTO_DESTINO */
                  END;
               END LOOP;

               /**********************************************************************/

               IF (MOD (num_insert_rows, 10) = 0)
               THEN
                  endeca_pck_log.endeca_pro_Avance (
                     v_id_proceso,
                     ' AVANCE '
                     || TO_CHAR ( (num_insert_rows / num_total_rows) * 100,
                                 '990.0')
                     || '%');

                  SELECT TO_NUMBER (PARA_DSC_VALOR)
                    INTO Flag
                    FROM SIS.SIS_TAB_PARA
                   WHERE PARA_COD_PARA = 50586;

                  IF Flag <> 1
                  THEN
                     RAISE PROCESO_ABORTADO;
                  END IF;

                  COMMIT;
               END IF;
            END IF;                                               -- si existe
         END;
      END LOOP;

      COMMIT;
      endeca_pck_log.endeca_pro_SetProcesados (v_id_proceso, num_insert_rows);
      endeca_pck_log.endeca_pro_SetPK (v_id_proceso, primera_pk, ultima_pk);
      endeca_pck_log.endeca_pro_SetFecha (v_id_proceso,
                                          primera_Fecha,
                                          ultima_Fecha);
      endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_OK');
   EXCEPTION
      WHEN PROCESO_ABORTADO
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || '  Abortado por Usuario Operador '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'ABORTADO ');
      WHEN OTHERS
      THEN
         endeca_pck_log.endeca_pro_EscribeLog (
            v_id_proceso,
               'Para proceso '
            || codigoProceso
            || ' Error en endeca_fun_GetPkAnterior '
            || SQLCODE
            || ' -ERROR- '
            || SQLERRM);
         endeca_pck_log.endeca_pro_FinProceso (v_id_proceso, 'TERMINADO_ERR');
   END;                                                          -- FIN FRM_OA
END ENDECA_PCK_FORMULARIO_0;
/

