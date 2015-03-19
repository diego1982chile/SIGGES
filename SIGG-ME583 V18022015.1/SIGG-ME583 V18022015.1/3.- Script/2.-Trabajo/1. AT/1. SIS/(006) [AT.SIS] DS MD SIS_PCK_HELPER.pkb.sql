INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(006) [AT.SIS] DS MD SIS_PCK_HELPER.pkb', 
 'Creación de definición de package SIS_PCK_HELPER',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY SIS.SIS_PCK_HELPER AS
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
  ) return varchar2 is
    c1_name varchar2(30);
    c2_name varchar2(30);
    c3_name varchar2(30);
    begin
       select REGEXP_SUBSTR(s, '[^_]+', 1, 1) a,
       REGEXP_SUBSTR(s, '[^_]+', 1, 2) b,
       REGEXP_SUBSTR(s, '[^_]+', 1, 3) c  into c1_name, c2_name, c3_name
       from (select t_name s from dual);
       --SIS.SIS_PCK_HELPER.LOG('Info: Call to "SIS.SIS_PCK_HELPER.Split", resultado= '||c3_name);
       ---DBMS_OUTPUT.Put_Line( 'c3_name='||c3_name);
       return c3_name;
    end;

    function Split2
    (
    p_list varchar2,
    p_del varchar2 --:= ','
    ) return split_tbl pipelined
    is
        l_idx    pls_integer;
        l_list    varchar2(32767) := p_list;
        l_value    varchar2(32767);
    begin
        loop
            l_idx := instr(l_list,p_del);
            if l_idx > 0 then
                pipe row(substr(l_list,1,l_idx-1));
                l_list := substr(l_list,l_idx+length(p_del));
            else
                pipe row(l_list);
                exit;
            end if;
        end loop;
        return;
    end Split2;

    function Split3
    (
    p_list varchar2
    ) return split_tbl pipelined
    is
    v_length number;
    v_cnt number := 1;
    v_token1 char(1);
    v_token2 char(1);
    v_token3 char(1);
    v_flag_sim1 boolean:=false;
    v_flag_sim2 boolean:=false;
    v_flag_num1 boolean:=false;
    v_flag_num2 boolean:=false;
    begin
        v_length := length(p_list);
        while (v_cnt < v_length+1)
            loop
            v_token1 := substr(p_list, v_cnt, 1);
            v_token2 := substr(p_list, v_cnt+1, 1);
            v_token3 := substr(p_list, v_cnt+2, 1);
            --DBMS_OUTPUT.Put_Line('v_token1="'||v_token1||'" v_token2="'||v_token2||'"');

            v_flag_sim1:=false;
            v_flag_sim2:=false;
            v_flag_num1:=false;
            v_flag_num2:=false;
                        
            if(v_token3 in ('>','<','=') and v_token2=' ' and v_token1 in ('y','o')) then
                pipe row(v_token1);
            end if;

            if(v_token1='<' or v_token1='>') then
                v_flag_sim1:=true;
            end if;

            if(v_token2='=') then
                v_flag_sim2:=true;
            end if;

            if(v_token1 in ('1','2','3','4','5','6','7','8','9') ) then
                 v_flag_num1:=true;
             end if;

            if(v_token2 in ('0','1','2','3','4','5','6','7','8','9') ) then
                 v_flag_num2:=true;
            end if;

            if(v_flag_sim1 and v_flag_sim2) then
                --DBMS_OUTPUT.Put_Line('caso1: v_token1="'||v_token1||'" v_token2="'||v_token2||'"');
                pipe row(v_token1||v_token2);
                v_cnt:=v_cnt+2;
            elsif(v_flag_sim1 and not v_flag_sim2) then
                --DBMS_OUTPUT.Put_Line('caso2: v_token1="'||v_token1||'" v_token2="'||v_token2||'"');
                pipe row(v_token1);
                v_cnt:=v_cnt+1;
            elsif(v_flag_num1 and v_flag_num2) then
                --DBMS_OUTPUT.Put_Line('caso3: v_token1="'||v_token1||'" v_token2="'||v_token2||'"');
                pipe row(v_token1||v_token2);
                v_cnt:=v_cnt+2;
            elsif(v_flag_num1 and not v_flag_num2) then
                --DBMS_OUTPUT.Put_Line('caso4: v_token1="'||v_token1||'" v_token2="'||v_token2||'"');
                pipe row(v_token1);
                v_cnt:=v_cnt+1;
                             
            else
                v_cnt:=v_cnt+1;
            end if;

            end loop;
      return;
    end Split3;

PROCEDURE ResetSeq
(t_Name  IN VARCHAR2,
p_name IN VARCHAR2)
IS
v_num  NUMBER;
p_val NUMBER;
v_increment number(1);
BEGIN
    --SIS.SIS_PCK_HELPER.LOG('Info: Call to "SIS.SIS_PCK_HELPER.ResetSeq"');
    --DBMS_OUTPUT.Put_Line( 'SELECT MAX('||split(t_Name)||'_COD_'||split(t_Name)||')+1  from  '||t_Name||' ');
    if(p_name = 'NCAT.NCAT_SEQ_FAMILIA_AUGE') then
        EXECUTE IMMEDIATE 'SELECT MIN('||split(t_Name)||'_COD_'||split(t_Name)||')-1  from  '||t_Name||' ' INTO p_val;
        --DBMS_OUTPUT.Put_Line( 'SELECT '||p_Name||'.NEXTVAL FROM DUAL');
        EXECUTE IMMEDIATE 'SELECT '||p_Name||'.NEXTVAL FROM DUAL' INTO v_num;

        --DBMS_OUTPUT.Put_Line( 'p_val='||p_val||' v_num='||v_num);

        --DBMS_OUTPUT.Put_Line('ALTER SEQUENCE '||p_Name||' INCREMENT BY -1 MINVALUE -9999999999');
        EXECUTE IMMEDIATE 'ALTER SEQUENCE '||p_Name||' INCREMENT BY '||(p_val - v_num  + 1)||' MINVALUE -9999999999';
        EXECUTE IMMEDIATE 'SELECT '||p_Name||'.NEXTVAL FROM DUAL' INTO v_num;
        EXECUTE IMMEDIATE 'ALTER SEQUENCE '||p_Name||' INCREMENT BY -1 ';
    else
        --DBMS_OUTPUT.Put_Line('t_Name='||t_Name||' split(t_Name)='||split(t_Name));  
        EXECUTE IMMEDIATE 'SELECT MAX('||substr(split(t_Name)||'_COD_'||split(t_Name),0,30)||')+1  from  '||t_Name||' ' INTO p_val;                      
        --DBMS_OUTPUT.Put_Line( 'SELECT '||p_Name||'.NEXTVAL FROM DUAL');
        EXECUTE IMMEDIATE 'SELECT '||p_Name||'.NEXTVAL FROM DUAL' INTO v_num;        

        --DBMS_OUTPUT.Put_Line('ALTER SEQUENCE '||p_Name||' INCREMENT BY '||(p_val - v_num - 1)||' MINVALUE 1');
        EXECUTE IMMEDIATE 'ALTER SEQUENCE '||p_Name||' INCREMENT BY '||(p_val - v_num  - 1)||' MINVALUE 1';
        EXECUTE IMMEDIATE 'SELECT '||p_Name||'.NEXTVAL FROM DUAL' INTO v_num;
        EXECUTE IMMEDIATE 'ALTER SEQUENCE '||p_Name||' INCREMENT BY 1 ';
    end if;

    --DBMS_OUTPUT.Put_Line('Sequence '||p_Name||' IS NOW AT '||p_val);
    --SIS.SIS_PCK_HELPER.LOG('Info: Sequence '||p_Name||' IS NOW AT '||p_val);
END;

FUNCTION is_number (p_string IN VARCHAR2)
   RETURN boolean
IS
   v_new_num NUMBER;
BEGIN
   v_new_num := TO_NUMBER(p_string);
   RETURN true;
EXCEPTION
WHEN VALUE_ERROR THEN
   RETURN false;
END;

function compare(
p_string1 in varchar2,
p_string2 in varchar2,
p_approx in boolean
) return boolean
is
begin
    if(p_approx) then
        return (convert(upper(trim(p_string2)),'US7ASCII') like '%'||convert(upper(trim(p_string1)),'US7ASCII')||'%') or
               (convert(upper(trim(p_string1)),'US7ASCII') like '%'||convert(upper(trim(p_string2)),'US7ASCII')||'%');
    else
        return (convert(upper(trim(p_string1)),'US7ASCII') = convert(upper(trim(p_string2)),'US7ASCII'));
    end if;
end compare;

END SIS_PCK_HELPER; 
/

