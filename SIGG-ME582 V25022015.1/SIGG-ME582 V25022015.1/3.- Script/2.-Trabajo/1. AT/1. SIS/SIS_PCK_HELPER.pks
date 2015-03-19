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
    
    FUNCTION is_number (p_string IN VARCHAR2)
    RETURN boolean;
    
    function compare(
    p_string1 in varchar2,
    p_string2 in varchar2,
    p_approx in boolean
    ) return boolean;

    PROCEDURE ResetSeq(
      t_Name  IN VARCHAR2,
      p_name IN VARCHAR2
    );    
    
    function getGlosa(
    t_name in varchar2,
    pk in number
    ) return varchar2;    
    
  FUNCTION Existe(
  tabla in varchar2,
  clave in varchar2
  ) return number;    

END SIS_PCK_HELPER; 
/

