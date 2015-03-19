INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(003) [AT.VAL] DS MD VAL_PCK_VALORIZA.pks', 
 'Creación de especificación package VAL.VAL_PCK_VALORIZA',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE VAL.VAL_PCK_VALORIZA AS
/******************************************************************************
   NAME:       SIS_PCK_VAL_VALORIZA
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05-02-2015      Diego       1. Created this package.
******************************************************************************/
valoriza_filas_afectadas number;
revalpres_filas_afectadas number;
revalps_filas_afectadas number;

v_nomproc VARCHAR2(255);
v_codora NUMBER;
v_codlog NUMBER;
v_msgora VARCHAR2(1000);
v_dsc_log  VARCHAR2(1000):='';

auge boolean;

fecha_ini date;
fecha_fin date;
out_error number(12);
cod_docu number(2);

v_pk_probsalud number(12);
v_pk_rama number(12);
v_pk_famrama number(12);
v_pk_familia number(12);
v_pk_pres number(12);
v_pk_famramapres number(12);

v_pk_union number(12);

  FUNCTION Existe(
  tabla in varchar2,
  clave in number
  ) RETURN number;

  FUNCTION Existe(
  tabla in varchar2,
  clave1 in number,
  clave2 in number
  ) RETURN number;

    FUNCTION Existe2(
  tabla in varchar2,
  clave1 in number,
  clave2 in number
  ) RETURN number;
  
  FUNCTION Existe2(
  tabla in varchar2,
  clave1 in number,
  clave2 in number,
  clave3 in number,
  clave4 in number
  ) RETURN number;

  PROCEDURE AgregarValPrograma
(p_auge in varchar2);

  PROCEDURE QuitarValPrograma
(p_auge in varchar2);

  PROCEDURE AgregarValorizaNoAuge(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_pres in varchar2,
  arancel in number);

  PROCEDURE QuitarValorizaNoAuge(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_pres in varchar2,
  arancel in number);

  PROCEDURE AgregarValorizaAuge(
  dsc_probsalud in varchar2,
  cod_ps_gen in number,
  cod_ps in number,
  cod_ps_aux in number,  
  cod_rama in number,
  dsc_famrama in varchar2,
  cod_familia in number,
  cod_pres in varchar2,
  arancel in number);

  PROCEDURE QuitarValorizaAuge(
  dsc_probsalud in varchar2,
  cod_ps_gen in number,
  cod_ps in number,
  cod_ps_aux in number,  
  cod_rama in number,
  dsc_famrama in varchar2,
  cod_familia in number,
  cod_pres in varchar2,
  arancel in number);

END VAL_PCK_VALORIZA; 
/

