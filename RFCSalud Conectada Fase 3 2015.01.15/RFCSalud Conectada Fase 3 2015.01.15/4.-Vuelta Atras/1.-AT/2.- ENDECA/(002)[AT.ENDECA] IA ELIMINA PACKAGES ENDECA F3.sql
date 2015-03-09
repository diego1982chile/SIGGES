INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT (RESPONSABLE,

                                        NOMBRE_SCRIPT,
                                        DESCRIPCION,
                                        FECHA_EJECUCION,
                                        NUMERO_OT)
     VALUES ('Iván Aguilera',
             '(002)[AT.ENDECA] IA ELIMINA PACKAGES ENDECA F3.sql',
             'ELIMINA PACKAGES ENDECA Fase 3',
             SYSDATE,
             'ENDECA FASE 3');
COMMIT;             
--------------------------------------------------------------------------------

DROP  PACKAGE ENDECA.ENDECA_PCK_FORMULARIO;
COMMIT; 