INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(005) [AT.SIS] DS MD SIS_PCK_HELPER.pks', 
 'Creación de especificación de package SIS_PCK_HELPER',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE SIS.SIS_PCK_HELPER AS
/******************************************************************************
   NAME:       SIS_PCK_HELPER
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05-02-2015      Diego       1. Created this package.
******************************************************************************/

function Split(
  t_name in varchar2
  ) return varchar2;

  function Split2
    (
    p_list varchar2,
    p_del varchar2 := ','
    ) return split_tbl pipelined;

    function Split3
    (
    p_list varchar2
    ) return split_tbl pipelined;

    PROCEDURE ResetSeq(
      t_Name  IN VARCHAR2,
      p_name IN VARCHAR2
      );

END SIS_PCK_HELPER;
/

