INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT (RESPONSABLE,

                                        NOMBRE_SCRIPT,
                                        DESCRIPCION,
                                        FECHA_EJECUCION,
                                        NUMERO_OT)
     VALUES ('Iván Aguilera',
             '(001)[AT.SIS] IA ELIMINA PARAMETROS ENDECA F3.sql',
             'Elimina Parametros por Reversa  ENDECA Fase 3',
             SYSDATE,
             'ENDECA FASE 3');
COMMIT;             
--------------------------------------------------------------------------------
/* Borra Parametros */
DELETE FROM SIS.SIS_TAB_PARA WHERE PARA_COD_PARA=50581;
DELETE FROM SIS.SIS_TAB_PARA WHERE PARA_COD_PARA=50582;
DELETE FROM SIS.SIS_TAB_PARA WHERE PARA_COD_PARA=50583;
DELETE FROM SIS.SIS_TAB_PARA WHERE PARA_COD_PARA=50584;
DELETE FROM SIS.SIS_TAB_PARA WHERE PARA_COD_PARA=50585;
DELETE FROM SIS.SIS_TAB_PARA WHERE PARA_COD_PARA=50586;
