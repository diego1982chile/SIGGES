INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(004) [AT.SIS] DS MD CREACION_SECUENCIAS', 
 'Creación secuencias: SIS.SIS_SEQ_PROBLSALUD, SIS.SIS_SEQ_FAMRAMA y SIS.SIS_SEQ_PRESTACION',  
  SYSDATE, 
  'SIGG-ME587'); 
  
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

SELECT MAX(PROBSALUD.PROBLSALUD_COD_PROBLSALUD)+1 into nextvalue from sis.sis_tab_problsalud PROBSALUD;

EXECUTE IMMEDIATE 'CREATE SEQUENCE SIS.SIS_SEQ_PROBLSALUD
  START WITH '||nextvalue||'
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER';
  
SELECT MAX(FAMRAMA.FAMRAMA_COD_FAMRAMA)+1 into nextvalue from sis.sis_tab_famrama FAMRAMA;

EXECUTE IMMEDIATE 'CREATE SEQUENCE SIS.SIS_SEQ_FAMRAMA
  START WITH '||nextvalue||'
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER';
    
SELECT MAX(PRESTACION.PRESTACION_COD_PRESTACION)+1 into nextvalue from sis.sis_tab_prestacion prestacion;

EXECUTE IMMEDIATE 'CREATE SEQUENCE SIS.SIS_SEQ_PRESTACION
  START WITH '||nextvalue||'
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER';
  
SELECT MAX(evegaropat.evegaropat_cod_evegaropat)+1 into nextvalue from sis.sis_tab_evegaropat evegaropat;

EXECUTE IMMEDIATE 'CREATE SEQUENCE SIS.SIS_SEQ_EVEGAROPAT
  START WITH '||nextvalue||'
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER';  
  
SELECT MAX(evegaropar.evegaropar_cod_evegaropar)+1 into nextvalue from sis.sis_tab_evegaropar evegaropar;

EXECUTE IMMEDIATE 'CREATE SEQUENCE SIS.SIS_SEQ_EVEGAROPAR
  START WITH '||nextvalue||'
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER';    
	
end;
/