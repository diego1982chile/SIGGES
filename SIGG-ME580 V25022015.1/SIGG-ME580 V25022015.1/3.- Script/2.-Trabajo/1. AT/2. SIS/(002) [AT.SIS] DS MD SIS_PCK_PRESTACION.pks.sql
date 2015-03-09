CREATE OR REPLACE PACKAGE SIS.SIS_PCK_PRESTACION AS
/******************************************************************************
   NAME:       SIS_PCK_PRESTACION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02-02-2015      Diego       1. Created this package.
******************************************************************************/

v_nomproc_1 VARCHAR2(255) := 'SIS.SIS_PCK_PRESTACION.AGREGARPROGRAMAS';
v_nomproc_2 VARCHAR2(255) := 'SIS.SIS_PCK_PRESTACION.QUITARPROGRAMAS';
v_codora NUMBER;
v_codlog NUMBER;
v_msgora VARCHAR2(1000);
v_dsc_log  VARCHAR2(1000):='';

out_error number(12);

fecha date;

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

PROCEDURE AgregarPrograma
(auge in varchar2);

PROCEDURE QuitarPrograma
(auge in varchar2);

 PROCEDURE AgregarPrestacion(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_pres in varchar2);
  --OUT_ERROR  OUT NUMBER);

  PROCEDURE QuitarPrestacion(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_pres in varchar2);
  --OUT_ERROR  OUT NUMBER);

END SIS_PCK_PRESTACION;
/

