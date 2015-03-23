INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(007) [AT.SIS] DS MD SIS_PCK_PRESTACION.pks', 
 'Creación de especificación de package SIS_PCK_PRESTACION',  
  SYSDATE, 
  'SIGG-ME587'); 
  
---------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE SIS.SIS_PCK_PRESTACION AS
/******************************************************************************
   NAME:       SIS_PCK_PRESTACION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02-02-2015      Diego       1. Created this package.
******************************************************************************/

v_nomproc VARCHAR2(255);
v_codora NUMBER;
v_codlog NUMBER;
v_msgora VARCHAR2(1000);
v_dsc_log  VARCHAR2(1000):='';

out_error number(12);

auge boolean;
cod_docu number(2);
fecha date;

v_pk_probsalud number(12);
v_pk_rama number(12);
v_pk_famrama number(12);
v_pk_pres number(12);
v_pk_famramapres number(12);
v_pk_familia number(12);

v_pk_union number(12);
v_pk_valoriza number(12);

  FUNCTION Existe(
  tabla in varchar2,
  clave in varchar2
  ) return number;  

  FUNCTION Existe(
  tabla in varchar2,
  clave1 in number,
  clave2 in number
  ) RETURN number;

 FUNCTION Existe(
  tabla in varchar2,
  clave in number
  ) RETURN number;

  FUNCTION Existe(
  tabla in varchar2,
  clave1 in varchar2,
  clave2 in number
  ) RETURN number;

  FUNCTION GetGlosa(
  tabla in varchar2,
  clave in number
  ) RETURN varchar2;

PROCEDURE AgregarPrograma
(p_auge in varchar2);

PROCEDURE QuitarPrograma
(p_auge in varchar2);

 PROCEDURE AgregarPrestacionNoAuge(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_pres in varchar2);
  --OUT_ERROR  OUT NUMBER);

  PROCEDURE AgregarPrestacionAuge(
  dsc_probsalud in varchar2,
  cod_ps_gen in number,
  cod_ps in number,
  cod_ps_aux in number,
  cod_rama in number,
  dsc_famrama in varchar2,
  cod_familia in number,
  cod_pres in varchar2);

  PROCEDURE QuitarPrestacionNoAuge(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_pres in varchar2);

  PROCEDURE QuitarPrestacionAuge(
  dsc_probsalud in varchar2,
  cod_ps_gen in number,
  cod_ps in number,
  cod_ps_aux in number,
  cod_rama in number,
  dsc_famrama in varchar2,
  cod_familia in number,
  cod_pres in varchar2);
  --OUT_ERROR  OUT NUMBER);

END SIS_PCK_PRESTACION; 
/

