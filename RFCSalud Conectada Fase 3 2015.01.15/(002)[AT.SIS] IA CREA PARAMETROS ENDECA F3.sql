INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT (RESPONSABLE,

                                        NOMBRE_SCRIPT,
                                        DESCRIPCION,
                                        FECHA_EJECUCION,
                                        NUMERO_OT)
     VALUES ('Iván Aguilera',
             '(002)[AT.SIS] IA CREA PARAMETROS ENDECA F3.sql',
             'CREA Parametros de control de Procesos  ENDECA Fase 3',
             SYSDATE,
             'ENDECA FASE 3');
COMMIT;             
--------------------------------------------------------------------------------

/* Crea Parametros */
INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50581,'Activa o Desactiva proceso (SIC) ','1','1:Activo     2:Desactivado ','01012014',null, 24 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50582,'Activa o Desactiva proceso (CAC) ','1','1:Activo     2:Desactivado ','01012014',null, 24 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50583,'Activa o Desactiva proceso (HD) ','1','1:Activo     2:Desactivado ','01012014',null, 24 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50584,'Activa o Desactiva proceso (EXCGO) ','1','1:Activo     2:Desactivado ','01012014',null, 24 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50585,'Activa o Desactiva proceso (CC) ','1','1:Activo     2:Desactivado ','01012014',null, 24 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50586,'Activa o Desactiva proceso (OA) ','1','1:Activo     2:Desactivado ','01012014',null, 24 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50587,'Activa o Desactiva proceso (IPD) ','1','1:Activo     2:Desactivado ','01012014',null, 24 );

------------------------------------------------------------------------------------------------------------------

/*
INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50588,'Cantidad Máxima a Procesar: (SIC) ','2000000','Valor = Cantidad de Registros ','01012014',null, 41 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50589,'Cantidad Máxima a Procesar: (CAC) ','2000000','Valor = Cantidad de Registros ','01012014',null, 41 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50590,'Cantidad Máxima a Procesar: (HD) ','2000000','Valor = Cantidad de Registros ','01012014',null, 41 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50591,'Cantidad Máxima a Procesar: (EXCGO) ','2000000','Valor = Cantidad de Registros ','01012014',null, 41 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50592,'Cantidad Máxima a Procesar: (CC) ','2000000','Valor = Cantidad de Registros ','01012014',null, 41 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50593,'Cantidad Máxima a Procesar: (OA) ','2000000','Valor = Cantidad de Registros ','01012014',null, 41 );

INSERT INTO SIS.SIS_TAB_PARA (
   PARA_COD_PARA, 
   PARA_DSC_NOMBRE, 
   PARA_DSC_VALOR, 
   PARA_DSC_PARA, 
   PARA_FEC_VIGE, 
   PARA_FEC_VCTO, 
   TIPPAR_COD_TIPPAR) 
VALUES (50594,'Cantidad Máxima a Procesar: (IPD) ','2000000','Valor = Cantidad de Registros ','01012014',null, 41 );
*/