﻿INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT (RESPONSABLE,

                                        NOMBRE_SCRIPT,
                                        DESCRIPCION,
                                        FECHA_EJECUCION,
                                        NUMERO_OT)
     VALUES ('Iván Aguilera',
             '(001)[AT.ENDECA] IA ELIMINA 8 TABLAS ENDECA F3.sql',
             'ELIMINA tablas ENDECA Fase 3',
             SYSDATE,
             'ENDECA FASE 3');
COMMIT;             
--------------------------------------------------------------------------------
DROP TABLE ENDECA.ENDECA_TAB_CAC   CASCADE CONSTRAINTS;
DROP TABLE ENDECA.ENDECA_TAB_CC    CASCADE CONSTRAINTS;
DROP TABLE ENDECA.ENDECA_TAB_EXCGO CASCADE CONSTRAINTS;
DROP TABLE ENDECA.ENDECA_TAB_HD    CASCADE CONSTRAINTS;
DROP TABLE ENDECA.ENDECA_TAB_IPD   CASCADE CONSTRAINTS;
DROP TABLE ENDECA.ENDECA_TAB_OA    CASCADE CONSTRAINTS;
DROP TABLE ENDECA.ENDECA_TAB_OAPO  CASCADE CONSTRAINTS;
DROP TABLE ENDECA.ENDECA_TAB_SIC   CASCADE CONSTRAINTS;