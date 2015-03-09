INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(005) [AT.VAL] DS MD GRANT_OBJETOS_BD', 
 'Grants de objetos de BD de User VAL a Users SIS y NCAT',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------
GRANT ALL ON VAL.VAL_PCK_VALORIZA TO SIS, NCAT;
GRANT ALL ON VAL.VAL_SEQ_VALORIZA TO SIS, NCAT;

/