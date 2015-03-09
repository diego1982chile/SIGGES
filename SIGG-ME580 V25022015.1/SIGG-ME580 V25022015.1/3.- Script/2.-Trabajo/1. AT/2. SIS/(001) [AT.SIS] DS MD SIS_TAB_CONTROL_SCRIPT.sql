begin

INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(001) [AT.SIS] DS MD GRANT_NCAT_TO_SIS.sql', 
 'Grant select, insert y delete de tabla ncat.ncat_tab_familia para usuario sis',  
  SYSDATE, 
  'SIGG-ME578'); 

INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(002) [AT.SIS] DS MD SIS_SEQ_FAMRAMA.sql', 
 'Secuencia para tabla sis.sis_tab_famrama',  
  SYSDATE, 
  'SIGG-ME578'); 
  
  INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(003) [AT.SIS] DS MD SIS_SEQ_FAMRAMA.sql', 
 'Secuencia para tabla sis.sis_tab_famrama',  
  SYSDATE, 
  'SIGG-ME578'); 
  
INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(004) [AT.SIS] DS MD SIS_PCK_HELPER.pks.sql', 
 'Package de utilidades',  
  SYSDATE, 
  'SIGG-ME578'); 
  
  INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(005) [AT.SIS] DS MD SIS_PCK_HELPER.pkb.sql', 
 'Package de utilidades',  
  SYSDATE, 
  'SIGG-ME578');   

INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(006) [AT.SIS] DS MD SIS_PCK_PROGRAMAS_NO_AUGE.pks.sql', 
 'Se agrega procedimiento para agregar programas no auge',  
  SYSDATE, 
  'SIGG-ME578');   
  
 
 INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(007) [AT.SIS] DS MD SIS_PCK_PROGRAMAS_NO_AUGE.pkb.sql', 
 'Se agrega procedimiento para agregar programas no auge',  
  SYSDATE, 
  'SIGG-ME578'); 
  
  INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(008) [AT.SIS] DS MD SIS_TAB_(RAMA, FAMRAMA,PRESTACION,FAMRAMAPRES).pks.sql', 
 'Script que agrega una prestación de programa no ayge',  
  SYSDATE, 
  'SIGG-ME578');   
  
commit;
  
 end;
 /
 