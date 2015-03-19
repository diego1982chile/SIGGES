INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(002) [AT.NCAT] DS MD CREACION_SECUENCIAS', 
 'Creación de secuencia NCAT.NCAT_SEQ_FAMILIA_AUGE',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------

declare nextvalue number(12);

begin 
SELECT MIN(FAMILIA.FAMILIA_COD_FAMILIA)-1 into nextvalue from NCAT.NCAT_TAB_FAMILIA FAMILIA;

EXECUTE IMMEDIATE 'CREATE SEQUENCE NCAT.NCAT_SEQ_FAMILIA_AUGE
  START WITH '||nextvalue||'
  MAXVALUE -1
  MINVALUE -9999999999999999999999999999
  NOCYCLE
  NOCACHE
  NOORDER';
	
end;
/