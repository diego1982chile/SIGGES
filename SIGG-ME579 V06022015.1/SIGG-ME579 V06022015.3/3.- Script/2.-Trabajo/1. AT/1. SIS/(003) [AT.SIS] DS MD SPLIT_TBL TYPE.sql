
INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(003) [AT.SIS] DS MD SPLIT_TBL TYPE', 
 'Creación tipo split_tbl',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------
create or replace type split_tbl as table of varchar2(32767);
/