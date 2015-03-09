INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(002) [AT.VAL] DS MD CREACION_SECUENCIAS', 
 'Creación de secuencia VAL.VAL_SEQ_VALORIZA',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------
 
 /*
Nombre objeto      :  SIS_SEQ_PROBLSALUD
Objetivo      :  Secuencia para tabla sis.sis_tab_famrama
Tipo objeto          : package
Tipo retorno      :

Creado por          :  Diego Soto
Modificado el      : 06-02-2016 
Observación      : 
*/

declare nextvalue number(12);

begin 

SELECT MAX(VALORIZA.VALORIZA_COD_VALORIZA)+1 into nextvalue from VAL.VAL_TAB_VALORIZA VALORIZA;

EXECUTE IMMEDIATE 'CREATE SEQUENCE VAL.VAL_SEQ_VALORIZA
  START WITH '||nextvalue||'
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER';
	
end;
/