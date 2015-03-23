INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(009) [AT.SIS] DS MD SIS_PCK_EVEGAROPAT.pks', 
 'Creación de especificación de package SIS_PCK_EVEGAROPAT',  
  SYSDATE, 
  'SIGG-ME587'); 
  
---------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE SIS.SIS_PCK_EVEGAROPAT AS
/******************************************************************************
   NAME:       SIS_PCK_EVEGAROPAT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        16-03-2015             1. Created this package.
******************************************************************************/

v_nomproc VARCHAR2(255);
v_codora NUMBER;
v_codlog NUMBER;
v_msgora VARCHAR2(1000);
v_dsc_log  VARCHAR2(1000):='';

out_error number(12);

fecha date;

  FUNCTION ExisteEvegaropat(  
  clave1 in number,
  clave2 in number,
  clave3 in number,
  clave4 in number,
  clave5 in date
  ) RETURN number;
  
 FUNCTION ExistePara(  
  clave1 in varchar2,
  clave2 in date  
  ) RETURN number;  
  
  PROCEDURE ParametrizarEventos;
  
  PROCEDURE VueltaAtras;
   
  PROCEDURE AgregarEventoCaso(
  v_pk_rama in number,
  v_pk_garoporpat in number,  
  cods_pres in varchar2,
  cods_espe in varchar2    
  );
  
  PROCEDURE QuitarEventoCaso(
  v_pk_rama in number,
  v_pk_garoporpat in number,  
  cods_pres in varchar2,
  cods_espe in varchar2      
  );  

END SIS_PCK_EVEGAROPAT; 
/

