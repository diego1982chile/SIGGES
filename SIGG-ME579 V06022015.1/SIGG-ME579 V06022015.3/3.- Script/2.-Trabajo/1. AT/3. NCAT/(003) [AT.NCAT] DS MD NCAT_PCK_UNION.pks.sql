INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(003) [AT.NCAT] DS MD NCAT_PCK_UNION.pks', 
 'Creación de especificación de package NCAT_PCK_UNION',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE NCAT.NCAT_PCK_UNION AS
/******************************************************************************
   NAME:       NCAT_PCK_UNION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        16-02-2015      Diego       1. Created this package.
******************************************************************************/

v_nomproc VARCHAR2(255);
v_codora NUMBER;
v_codlog NUMBER;
v_msgora VARCHAR2(1000);
v_dsc_log  VARCHAR2(1000):='';

out_error number(12);

fecha_ini date;
fecha_fin date;

auge boolean;

tiptrapa number(12);
cod_docu number(2);

v_pk_probsalud number(12);
v_pk_rama number(12);
v_pk_famrama number(12);
v_pk_pres number(12);
v_pk_famramapres number(12);
v_pk_familia number(12);
v_pk_valoriza number(12);

v_pk_union number(12);

v_pk_tipinter number(12);
v_pk_tipinter_aux number(12);

v_pk_unedad number(12);
v_pk_genero number(12);

v_pk_unsexo number(12);

v_pk_period number(12);

v_pk_unfrec number(12);

v_pk_unexcpre number(12);
v_pk_unincpre number(12);

v_pk_unpsra number(12);

v_pk_relaunre number(12);

FUNCTION Existe(
  tabla in varchar2,
  clave in number
  ) RETURN number;

FUNCTION Existe(
tabla in varchar2,
clave1 in number,
clave2 in number
) RETURN number;

FUNCTION Existe(
  tabla in varchar2,
  clave in varchar2
  ) RETURN number;

PROCEDURE AgregarNcatPrograma
(p_auge IN varchar2);


PROCEDURE QuitarNcatPrograma
(p_auge IN varchar2);

PROCEDURE AgregarUnionNoAuge(
dsc_probsalud in varchar2,
dsc_rama in varchar2,
dsc_famrama in varchar2,
cod_pres in varchar2,
arancel in number,
edad in varchar2,
sexo in varchar2,
frecuencia in varchar2,
excluyentes in varchar2
);

PROCEDURE QuitarUnionNoAuge(
dsc_probsalud in varchar2,
dsc_rama in varchar2,
dsc_famrama in varchar2,
cod_pres in varchar2,
arancel in number,
edad in varchar2,
sexo in varchar2,
frecuencia in varchar2,
excluyentes in varchar2
);

PROCEDURE AgregarUnionAuge(
dsc_probsalud in varchar2,
dsc_rama in varchar2,
dsc_famrama in varchar2,
cod_pres in varchar2,
arancel in number,
edad in varchar2,
sexo in varchar2,
frecuencia in varchar2,
excluyentes in varchar2
);

PROCEDURE QuitarUnionAuge(
dsc_probsalud in varchar2,
dsc_rama in varchar2,
dsc_famrama in varchar2,
cod_pres in varchar2,
arancel in number,
edad in varchar2,
sexo in varchar2,
frecuencia in varchar2,
excluyentes in varchar2
);

END NCAT_PCK_UNION;
/

