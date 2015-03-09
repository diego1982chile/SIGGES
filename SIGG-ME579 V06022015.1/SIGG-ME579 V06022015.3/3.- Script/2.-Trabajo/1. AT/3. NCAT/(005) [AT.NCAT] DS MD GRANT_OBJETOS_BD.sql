INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(005) [AT.NCAT] DS MD GRANT_OBJETOS_BD', 
 'Grants de objetos de BD de User NCAT a Users SIS y VAL',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------

GRANT SELECT,INSERT,DELETE ON NCAT.NCAT_TAB_FAMILIA TO SIS, VAL;
GRANT ALL ON NCAT.NCAT_PCK_UNION TO SIS, VAL;
GRANT ALL ON NCAT.NCAT_SEQ_FAMILIA_AUGE TO SIS, VAL;

/