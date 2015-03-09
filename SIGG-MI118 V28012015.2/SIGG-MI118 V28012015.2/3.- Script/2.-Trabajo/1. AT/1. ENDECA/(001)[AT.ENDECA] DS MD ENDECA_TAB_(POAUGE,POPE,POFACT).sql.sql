INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(001)[AT.ENDECA] DS MD ENDECA_TAB_(POAUGE,ENDECA_TAB_POPE,ENDECA_TAB_POFACT).sql', 
 'Se agregan comentarios a los campos de las tablas: ENDECA_TAB_POAUGE, ENDECA_TAB_POPE y ENDECA_TAB_POFACT',  
  SYSDATE, 
  'SIGG-MI118'); 
 -----------------------------------------------
comment on column endeca.ENDECA_TAB_POAUGE.CPROCESO_ID_PROCESO IS 'Identificador que corresponde al n�mero de proceso de carga';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_ID_CASO IS 'Corresponde al c�digo caso, al cual est� asociada esta prestaci�n (ver tabla CASO o tabla CASOVIH)';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_ID_PRESTACION IS 'Corresponde al c�digo �nico del registro de la prestaci�n';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_COD_PRESTACION IS 'C�digo SIGGES de la prestaci�n (ver tabla ENDECA_VW_PRESTACION) ';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_OTORGAMIENTO_DESDE IS 'Fecha inicio de otorgamiento de la prestacion';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_OTORGAMIENTO_HASTA IS 'Fecha t�rmino de otorgamiento de la prestacion';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_COD_ESPECIALIDAD IS 'C�digo de la especialidad (ver tabla ENDECA_VW_ESPECIALIDAD)';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_ESTAB_SOLICITA IS 'C�digo del establecimiento que solicita la prestacion (ver tabla ENDECA_VW_ESTABLECIMIENTO)';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_ESTAB_OTORGA IS 'C�digo del establecimiento que realiza la prestacion (ver tabla ENDECA_VW_ESTABLECIMIENTO)';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_EXTRASISTEMA IS 'Identificador:  1= SI, es extrasistema; 2=NO es extrasistema';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_PRESTADOR IS 'Nombre del prestador del extrasistema';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_FECHA_DIGITACION  IS 'Fecha de digitaci�n de la prestaci�n en el sistema SIGGES';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_USUARIO_DIGITA IS 'C�digo del usuario que digit� la prestaci�n (ver tabla ENDECA_VW_USUARIO)';
comment on column endeca.ENDECA_TAB_POAUGE.POAUGE_ESTABLECIM_DIGITA IS 'C�digo establecimiento de conexi�n desde donde se digit� la prestaci�n (ver tabla ENDECA_VW_ESTABLECIMIENTO)';
comment on column endeca.ENDECA_TAB_POPE.CPROCESO_ID_PROCESO IS 'Identificador que corresponde al n�mero de proceso de carga';
comment on column endeca.ENDECA_TAB_POPE.POPE_ID_BENEFICIARIO IS 'Corresponde al c�digo beneficiario (ver tabla BENEFICIARIO)';
comment on column endeca.ENDECA_TAB_POPE.POPE_ID_POPE IS 'Corresponde al c�digo �nico del registro de la prestaci�n';
comment on column endeca.ENDECA_TAB_POPE.POPE_CODIGO_PE IS 'Corresponde al c�digo del sub-programa, (ver tabla ENDECA_VW_RAMA)';
comment on column endeca.ENDECA_TAB_POPE.POPE_COD_FAMILIA IS 'C�digo de la familia (ver tabla ENDECA_VW_FAMILIA)';
comment on column endeca.ENDECA_TAB_POPE.POPE_COD_PRESTACION IS 'C�digo SIGGES de la prestaci�n (ver tabla ENDECA_VW_PRESTACION) ';
comment on column endeca.ENDECA_TAB_POPE.POPE_OTORGAMIENTO_DESDE IS 'Fecha inicio de otorgamiento de la prestacion';
comment on column endeca.ENDECA_TAB_POPE.POPE_OTORGAMIENTO_HASTA IS 'Fecha t�rmino de otorgamiento de la prestacion';
comment on column endeca.ENDECA_TAB_POPE.POPE_ESTAB_SOLICITA IS 'C�digo del establecimiento que solicita la prestacion (ver tabla ENDECA_VW_ESTABLECIMIENTO)';
comment on column endeca.ENDECA_TAB_POPE.POPE_ESTAB_OTORGA IS 'C�digo del establecimiento que realiza la prestacion (ver tabla ENDECA_VW_ESTABLECIMIENTO)';
comment on column endeca.ENDECA_TAB_POPE.POPE_EXTRASISTEMA IS 'Identificador:  1= SI, es extrasistema; 2=NO es extrasistema';
comment on column endeca.ENDECA_TAB_POPE.POPE_PRESTADOR IS 'Nombre del prestador del extrasistema';
comment on column endeca.ENDECA_TAB_POPE.POPE_FECHA_DIGITACION  IS 'Fecha de digitaci�n de la prestaci�n en el sistema SIGGES';
comment on column endeca.ENDECA_TAB_POPE.POPE_USUARIO_DIGITA IS 'C�digo del usuario que digit� la prestaci�n (ver tabla ENDECA_VW_USUARIO)';
comment on column endeca.ENDECA_TAB_POPE.POPE_ESTABLECIM_DIGITA IS 'C�digo establecimiento de conexi�n desde donde se digit� la prestaci�n (ver tabla ENDECA_VW_ESTABLECIMIENTO)';
comment on column endeca.ENDECA_TAB_POFACT.CPROCESO_ID_PROCESO IS 'Identificador que corresponde al n�mero de proceso de carga';
comment on column endeca.ENDECA_TAB_POFACT.POFACT_PROCESO_FACTURACION IS 'Corresponde al identificador del proceso de facturaci�n (ver tabla ENDECA_VW_FACTPROC)';
comment on column endeca.ENDECA_TAB_POFACT.POFACT_TIPO_PRESTACION IS 'Identificador: 10=prestaci�n AUGE; 15= prestaci�n NO AUGE (programa especial)';
comment on column endeca.ENDECA_TAB_POFACT.POFACT_ID_PRESTACION IS 'Corresponde al c�digo �nico del registro de la prestaci�n. (Si el tipo_prestacion=10, ver tabla POAUGE;  si el tipo_prestacion=15, ver tabla POPE)';
comment on column endeca.ENDECA_TAB_POFACT.POFACT_COD_IS IS 'Identificador de Intervenci�n Sanitaria: 1= Sospecha; 2= Diagn�stico; 3=  Diagn�stico y Tratamiento; 4=Confirmaci�n; 5=Tratamiento; 6=Seguimiento';
comment on column endeca.ENDECA_TAB_POFACT.POFACT_COD_FAMILIA IS 'C�digo de la familia (ver tabla ENDECA_VW_FAMILIA)';
comment on column endeca.ENDECA_TAB_POFACT.POFACT_CANTIDAD IS 'Cantidad (Q) de prestaciones';
comment on column endeca.ENDECA_TAB_POFACT.POFACT_PRECIO IS 'Corresponde al Arancel de la prestaci�n (precio=P)';
comment on column endeca.ENDECA_TAB_POFACT.POFACT_TOTAL IS 'Total = P*Q';