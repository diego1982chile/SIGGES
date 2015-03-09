
INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT (RESPONSABLE,

                                        NOMBRE_SCRIPT,
                                        DESCRIPCION,
                                        FECHA_EJECUCION,
                                        NUMERO_OT)
     VALUES ('Iván Aguilera',
             '(003)[AT.ENDECA] IA ELIMINA 4 VISTAS ENDECA F3.sql',
             'ELIMINA vista ENDECA Fase 3',
             SYSDATE,
             'ENDECA FASE 3');
COMMIT;             
--------------------------------------------------------------------------------

DROP VIEW ENDECA.ENDECA_VW_CAUSALCAC;
DROP VIEW ENDECA.ENDECA_VW_CAUSALCCEXGO;
DROP VIEW ENDECA.ENDECA_VW_DIAGNOSTICOPS;
DROP VIEW ENDECA.ENDECA_VW_NODOHD;