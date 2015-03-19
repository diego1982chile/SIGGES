CREATE OR REPLACE PACKAGE BODY SIS.SIS_PCK_PRESTACION AS

/******************************************************************************
   NAME:       SIS_PCK_PRESTACION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02-02-2015      Diego       1. Created this package body.
******************************************************************************/

  FUNCTION Existe(
  tabla in varchar2,
  clave in varchar2
  ) RETURN number IS
  v_pk number(12):=0;
  BEGIN

    case tabla
        when 'rama' then
            /* Seleccionar la rama más reciente según vigencia, usando como clave de búsqueda la glosa dada */
             for c1 in ( select RAMA.RAMA_COD_RAMA pk from sis_tab_rama rama
                            where convert(upper(trim(rama_dsc_rama)),'US7ASCII')=convert(upper(trim(clave)),'US7ASCII')
                            and RAMA.RAMA_FEC_VIGE>= fecha
                            and rownum<=1 )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
        when 'probsalud' then
            /* Seleccionar el probsalud usando como clave de búsqueda la glosa de la rama dada */
             for c1 in ( select PROBSALUD.PROBLSALUD_COD_PROBLSALUD pk from sis_tab_problsalud probsalud
                            where convert(upper(trim(PROBSALUD.PROBLSALUD_DSC_NOMBRE)),'US7ASCII') like '%'||convert(upper(trim(clave)),'US7ASCII')||'%'
                            and rownum=1 )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
        when 'famrama' then
            /* Seleccionar la famrama(familia) más reciente según vigencia, usando como clave de búsqueda la glosa dada */
              for c1 in ( select FAMRAMA.FAMRAMA_COD_FAMRAMA pk
                          from sis_tab_famrama famrama
                          where convert(upper(trim(famrama_dsc_famrama)),'US7ASCII')=convert(upper(trim(clave)),'US7ASCII')
                          and FAMRAMA.FAMRAMA_FEC_VIGE>=fecha
                          and rownum<=1 )
                loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
        when 'prestacion' then
            /* Seleccionar la prestación más reciente según vigencia, usando como clave de búsqueda, el código de prestación dado */
                for c1 in ( select PRESTACION.PRESTACION_COD_PRESTACION pk
                                from sis_tab_prestacion prestacion
                                where trim(PRESTACION.PRESTACION_DSC_CODUSUA)=trim(clave)
                                and rownum<=1
                                order by prestacion.prestacion_FEC_VIGE desc  )
                 loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
        when 'famrama_famramapres' then
                for c1 in ( select FAMRAMAPRES.FAMRAMAPRES_COD_FAMRAMAPRES pk  from sis_tab_famrama famrama inner join sis_tab_famramapres famramapres
                on FAMRAMA.FAMRAMA_COD_FAMRAMA=FAMRAMAPRES.FAMRAMA_COD_FAMRAMA
                where convert(upper(trim(FAMRAMA.FAMRAMA_DSC_FAMRAMA)),'US7ASCII')=convert(upper(trim(clave)),'US7ASCII')
                and FAMRAMA.FAMRAMA_FEC_VIGE>=fecha )
                loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
        when 'prestacion_famramapres' then
                for c1 in ( select FAMRAMAPRES.FAMRAMAPRES_COD_FAMRAMAPRES pk from sis_tab_prestacion prestacion inner join sis_tab_famramapres famramapres
                on PRESTACION.PRESTACION_COD_PRESTACION=FAMRAMAPRES.PRESTACION_COD_PRESTACION
                where trim(PRESTACION.PRESTACION_DSC_CODUSUA)=trim(clave)
                order by prestacion.prestacion_FEC_VIGE desc )
                loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
         when 'rama_famrama' then
                for c1 in ( select RAMA.RAMA_COD_RAMA pk from sis_tab_rama rama inner join sis_tab_famrama famrama
                on RAMA.RAMA_COD_RAMA=FAMRAMA.RAMA_COD_RAMA
                where convert(upper(trim( RAMA.RAMA_DSC_RAMA)),'US7ASCII')=convert(upper(trim(clave)),'US7ASCII')
                and RAMA.RAMA_FEC_VIGE >= fecha )
                loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
        when 'probsalud_rama' then
                for c1 in ( select RAMA.RAMA_COD_RAMA pk from sis_tab_problsalud probsalud inner join sis_tab_rama rama
                on PROBSALUD.PROBLSALUD_COD_PROBLSALUD=RAMA.PROBLSALUD_COD_PROBLSALUD
                where convert(upper(trim( PROBSALUD.PROBLSALUD_DSC_NOMBRE )),'US7ASCII')=convert(upper(trim(clave)),'US7ASCII')
                and PROBSALUD.PROBLSALUD_FEC_VIGE >= fecha )
                loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
    end case;

    return v_pk;
  END;

  FUNCTION Existe(
  tabla in varchar2,
  clave in number
  ) RETURN number IS
  v_pk number(12):=0;
  BEGIN
    case tabla
        when 'familia' then
            /* Seleccionar la familia, usando como clave de búsqueda la pk de la famrama */
              for c1 in ( select familia.FAMILIA_COD_FAMILIA pk
                          from NCAT.NCAT_TAB_FAMILIA familia
                          where FAMILIA.FAMILIA_COD_FAMILIA= clave )
                loop
                    --DBMS_OUTPUT.PUT_LINE('c1.pk= '||c1.pk);
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
    end case;

    return v_pk;
  END;

  FUNCTION Existe(
  tabla in varchar2,
  clave1 in number,
  clave2 in number
  ) RETURN number IS
  v_pk number(12):=0;
  BEGIN

    case tabla
        when 'famramapres' then
            /* Seleccionar la rama usando como clave de búsqueda la glosa dada */
             for c1 in ( select FAMRAMAPRES.FAMRAMAPRES_COD_FAMRAMAPRES pk from sis_tab_famramapres famramapres
             where FAMRAMAPRES.FAMRAMA_COD_FAMRAMA= clave1
             and FAMRAMAPRES.PRESTACION_COD_PRESTACION= clave2 )
             loop
                --DBMS_OUTPUT.PUT_LINE('c1.pk= '||c1.pk);
                v_pk:= c1.pk;
                exit; -- only care about one record, so exit.
              end loop;
    end case;

    return v_pk;
  END;

PROCEDURE AgregarPrograma
(auge IN varchar2)
IS
dia number(2):=1;
mes number(2):=1;
anyo number(5):=EXTRACT(YEAR FROM sysdate);

probsalud_nulo exception;
famrama_nulo exception;
prestacion_nulo exception;

v_data number(12);
--fecha date;
BEGIN    
    v_dsc_log:='Info: Iniciando proceso';
    Sis.Sis_Pro_Log ('AgregarPrograma', 1, 0, '.',  v_dsc_log, out_error);

    --Chequear que la tabla inputbuffer tenga data
    SELECT 1 into v_data  FROM sis.inputbuffer WHERE ROWNUM=1;

    -- Setear la fecha de vigencia según caso (auge/no auge)
    if(upper(auge)='AUGE') then
        anyo:=1000;
        fecha:=TO_DATE(dia||'/'||mes||'/'||anyo,'DD/MM/RRRR');
    else
        fecha:=TO_DATE(dia||'/'||mes||'/'||anyo,'DD/MM/RRRR');
    end if;
    
    /* Resetear secuencias involucradas en la transacción */
    SIS_PCK_HELPER.RESETSEQ('SIS_TAB_PROBLSALUD','SIS_SEQ_PROBLSALUD');
    SIS_PCK_HELPER.RESETSEQ('SIS_TAB_RAMA','SIS_SEQ_RAMA');
    SIS_PCK_HELPER.RESETSEQ('SIS_TAB_FAMRAMA','SIS_SEQ_FAMRAMA');
    SIS_PCK_HELPER.RESETSEQ('SIS_TAB_PRESTACION','SIS_SEQ_PRESTACION');
    SIS_PCK_HELPER.RESETSEQ('SIS_TAB_FAMRAMAPRES','SIS_SEQ_FAMRAMAPRES');
    
     for c in ( select IB.PROBLSALUD probsalud, IB.RAMA rama, IB.FAMRAMA famrama, IB.PRESTACION prestacion
                          from SIS.INPUTBUFFER ib )
                loop
                    --DBMS_OUTPUT.PUT_LINE('c1.pk= '||c1.pk);
                    if(c.probsalud is null) then
                        raise probsalud_nulo;                        
                    end if;
                    if(c.famrama is null) then
                        raise famrama_nulo;
                    end if;
                    if(c.prestacion is null) then
                        raise prestacion_nulo;
                    end if;
                    AgregarPrestacion(c.probsalud, c.rama, c.famrama, c.prestacion);                                  
                end loop;
                
        -- Vaciar la tabla inputbuffer
        delete from sis.inputbuffer;
                         
        SIS_PCK_PRESTACION.v_dsc_log:='Info: Proceso terminado con éxito.';
                                                               
        Sis.Sis_Pro_Log ('AgregarPrograma', 1, 0, 'OK', SIS_PCK_PRESTACION.v_dsc_log, SIS_PCK_PRESTACION.out_error);   
                  
        commit;
           
        exception
        when no_data_found then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'Tabla "inputbuffer" vacía. No hay registros a procesar';
            Sis.Sis_Pro_Log ('AgregarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            DBMS_OUTPUT.PUT_LINE('Tabla "inputbuffer" vacía. No hay registros a procesar');
        when probsalud_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "probsalud" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log ('AgregarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            DBMS_OUTPUT.PUT_LINE('El parámetro "probsalud" es null. Revisar archivo .csv');
        when famrama_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "famrama" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log ('AgregarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            DBMS_OUTPUT.PUT_LINE('El parámetro "famrama" es null. Revisar archivo .csv');
        when prestacion_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "prestacion" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log ('AgregarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            DBMS_OUTPUT.PUT_LINE('El parámetro "prestacion" es null. Revisar archivo .csv');
        when others then       
            rollback;
            Sis.Sis_Pro_Log ('AgregarPrograma', SIS_PCK_PRESTACION.V_CODLOG, SQLCODE, SQLERRM,  SIS_PCK_PRESTACION.v_dsc_log, SIS_PCK_PRESTACION.out_error);    
END;

PROCEDURE QuitarPrograma
(auge IN varchar2)
IS
dia number(2):=1;
mes number(2):=1;
anyo number(5):=EXTRACT(YEAR FROM sysdate);

probsalud_nulo exception;
famrama_nulo exception;
prestacion_nulo exception;

v_data number(12);
--fecha date;
BEGIN    
    v_dsc_log:='Info: Iniciando proceso';
    Sis.Sis_Pro_Log ('QuitarPrograma', 1, 0, '.',  v_dsc_log, out_error);
    
    --Chequear que la tabla inputbuffer tenga data
    SELECT 1 into v_data  FROM sis.inputbuffer WHERE ROWNUM=1;

    -- Setear la fecha de vigencia según caso (auge/no auge)
    if(upper(auge)='AUGE') then
        anyo:=1000;
        fecha:=TO_DATE(dia||'/'||mes||'/'||anyo,'DD/MM/RRRR');
    else
        fecha:=TO_DATE(dia||'/'||mes||'/'||anyo,'DD/MM/RRRR');
    end if;
    
     for c in ( select IB.PROBLSALUD probsalud, IB.RAMA rama, IB.FAMRAMA famrama, IB.PRESTACION prestacion
                          from SIS.INPUTBUFFER ib )
                loop
                    --DBMS_OUTPUT.PUT_LINE('c1.pk= '||c1.pk);
                    if(c.probsalud is null) then
                        raise probsalud_nulo;                        
                    end if;
                    if(c.famrama is null) then
                        raise famrama_nulo;
                    end if;
                    if(c.prestacion is null) then
                        raise prestacion_nulo;
                    end if;
                    QuitarPrestacion(c.probsalud, c.rama, c.famrama, c.prestacion);                                  
                end loop;
                
        /* Resetear secuencias involucradas en la transacción */
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_PROBLSALUD','SIS_SEQ_PROBLSALUD');
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_RAMA','SIS_SEQ_RAMA');
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_FAMRAMA','SIS_SEQ_FAMRAMA');
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_PRESTACION','SIS_SEQ_PRESTACION');
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_FAMRAMAPRES','SIS_SEQ_FAMRAMAPRES');
        
        -- Vaciar la tabla inputbuffer
        delete from sis.inputbuffer;
                        
        SIS_PCK_PRESTACION.v_dsc_log:='Info: Proceso terminado con éxito.';                                                       
        Sis.Sis_Pro_Log ('QuitarPrograma', 1, 0, 'OK', SIS_PCK_PRESTACION.v_dsc_log, SIS_PCK_PRESTACION.out_error);   
        
        commit; 
               
        exception
        when no_data_found then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'Tabla "inputbuffer" vacía. No hay registros a procesar';
            Sis.Sis_Pro_Log ('QuitarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            DBMS_OUTPUT.PUT_LINE('Tabla "inputbuffer" vacía. No hay registros a procesar');
        when probsalud_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "probsalud" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log ('AgregarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            DBMS_OUTPUT.PUT_LINE('El parámetro "probsalud" es null. Revisar archivo .csv');
        when famrama_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "famrama" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log ('AgregarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            DBMS_OUTPUT.PUT_LINE('El parámetro "famrama" es null. Revisar archivo .csv');
        when prestacion_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "prestacion" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log ('QuitarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            DBMS_OUTPUT.PUT_LINE('El parámetro "prestacion" es null. Revisar archivo .csv');
        when others then       
            rollback;
            Sis.Sis_Pro_Log (SIS_PCK_PRESTACION.v_nomproc_1, SIS_PCK_PRESTACION.V_CODLOG, SQLCODE, SQLERRM,  SIS_PCK_PRESTACION.v_dsc_log, SIS_PCK_PRESTACION.out_error);    
END;

  PROCEDURE AgregarPrestacion(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_pres in varchar2)
  --OUT_ERROR  OUT NUMBER)
  IS
    v_pk_probsalud number(12):=0;
    v_pk_rama number(12);
    v_pk_famrama number(12);
    v_pk_pres number(12);
    v_pk_famramapres number(12);
    v_pk_familia number(12);

    begin

    --DBMS_OUTPUT.PUT_LINE('dsc_probsalud='||dsc_probsalud);
    --DBMS_OUTPUT.PUT_LINE('dsc_rama='||dsc_rama);
    --DBMS_OUTPUT.PUT_LINE('dsc_famrama='||dsc_famrama);
    --DBMS_OUTPUT.PUT_LINE('cod_pres='||cod_pres);

    v_pk_probsalud:=Existe('probsalud',dsc_probsalud);

    if(v_pk_probsalud=0) then
        /*  TODO: Si no existe el probsalud, crear el nuevo probsalud */
        --DBMS_OUTPUT.PUT_LINE('SIS: No existe el probsalud de glosa '||dsc_probsalud||', se procede a insertar el nuevo probsalud');
        select SIS_SEQ_PROBLSALUD.nextval into v_pk_probsalud from dual;

        insert into sis_tab_problsalud (problsalud_cod_problsalud, entregistro_fec_fecha, entregistro_fec_hora, entregistro_cod_usuario, entregistro_fec_ingreso, problsalud_dsc_datos, boo_cod_garantizado,
                                                    problsalud_dsc_nombre, problsalud_cod_ordennom, boo_cod_casosinrama, boo_cod_casomanual, boo_cod_especial, problsalud_fec_vige, relaps_cod_relaps, decreto_cod_decreto,
                                                    problsalud_fec_adesplegar)
        values (v_pk_probsalud, fecha, fecha, 1, fecha, dsc_probsalud, 2, dsc_probsalud, 99.4, 2, 2, 2, fecha, 1, 2, fecha);        
        --commit;
    --else
        --DBMS_OUTPUT.PUT_LINE('SIS: ya existe el probsalud de glosa '||dsc_probsalud||', no se inserta');
    end if;

    v_pk_rama:=Existe('rama',dsc_rama);

    --DBMS_OUTPUT.PUT_LINE('v_pk_rama= '||v_pk_rama);

    if(v_pk_rama=0) then
        --DBMS_OUTPUT.PUT_LINE('SIS: No existe la rama de glosa '||dsc_rama||', se procede a insertar nueva rama');
        select SIS_SEQ_RAMA.nextval into v_pk_rama from dual;

        insert into sis_tab_rama (rama_cod_rama, rama_dsc_rama, problsalud_cod_problsalud, rama_fec_vige, boo_cod_raiz)
        values (v_pk_rama, dsc_rama, v_pk_probsalud, fecha, 1);        
        --commit;
    --else
        --DBMS_OUTPUT.PUT_LINE('SIS: ya existe una rama vigente de glosa '||dsc_rama||', no se inserta');
    end if;

    v_pk_famrama:=Existe('famrama',dsc_famrama);

    if(v_pk_famrama=0) then
        /* Si no existe la famrama o no está vigente, crear la nueva famrama */
        --DBMS_OUTPUT.PUT_LINE('SIS: No existe la famrama de glosa '||dsc_famrama||', se procede a insertar nueva famrama');
        select SIS_SEQ_FAMRAMA.nextval into v_pk_famrama from dual;
        insert into sis_tab_famrama (famrama_cod_famrama, rama_cod_rama, famrama_fec_vige, famrama_fec_vcto, famrama_dsc_famrama)
        values (v_pk_famrama, v_pk_rama, fecha, null, dsc_famrama);        
        --commit;
    --else
        --DBMS_OUTPUT.PUT_LINE('SIS: ya existe una famrama vigente de glosa '||dsc_famrama||', no se inserta');
    end if;

    --DBMS_OUTPUT.PUT_LINE('v_pk_famrama='||v_pk_famrama);

    /* Replicar la famrama en la tabla familia del usuario NCAT */

     v_pk_familia:=Existe('familia',v_pk_famrama);

    if(v_pk_familia=0) then
        /* Si no existe la familia o no está vigente, crear la nueva familia */
        --DBMS_OUTPUT.PUT_LINE('NCAT: No existe la familia de glosa '||dsc_famrama||', se procede a insertar nueva familia');
        insert into NCAT.NCAT_TAB_FAMILIA(familia_cod_familia, docu_cod_docu, familia_dsc_familia)
        values (v_pk_famrama, 15, dsc_famrama);        
        --commit;
    --else
        --DBMS_OUTPUT.PUT_LINE('NCAT: ya existe una familia de glosa '||dsc_famrama||', no se inserta');
    end if;

    --DBMS_OUTPUT.PUT_LINE('v_pk_famrama='||v_pk_famrama);

    v_pk_pres:=Existe('prestacion',cod_pres);

    if(v_pk_pres=0) then
        /* Si no existe la prestacion, crear la nueva prestacion */
        --DBMS_OUTPUT.PUT_LINE('SIS: No existe la prestación de código '||cod_pres||', se procede a insertar nueva prestación');
        select SIS_SEQ_PRESTACION.nextval into v_pk_pres from dual;

        insert into sis_tab_prestacion(prestacion_cod_prestacion, referencia_cod_referencia, prestacion_dsc_codusua, prestacion_dsc_prestacion, prestacion_fec_vige, prestacion_num_arancel)
        values (v_pk_pres, null, cod_pres, dsc_famrama, fecha, null);        
        --commit;
    --else
        --DBMS_OUTPUT.PUT_LINE('SIS: ya existe una prestacion de código '||cod_pres||', no se inserta');
    end if;

    --DBMS_OUTPUT.PUT_LINE('v_pk_prestacion='||v_pk_pres);

    v_pk_famramapres:=Existe('famramapres',v_pk_famrama,v_pk_pres);

    /*Para esta famrama y esta prestación, chequear si existe una famramapres */

    if(v_pk_famramapres=0) then
        /* Si no existe la famramapres, crear una nueva famramapres con las pk de famrama y prestacion obtenidas */
        --DBMS_OUTPUT.PUT_LINE('SIS: No existe la famramapres para la famrama de glosa '||dsc_famrama||' y prestación de código '||cod_pres||'. Se procede a insertar la famrama');
        insert into sis_tab_famramapres (famramapres_cod_famramapres,famrama_cod_famrama, prestacion_cod_prestacion, famramapres_fec_vige, famramapres_fec_vcto, famramapres_cod_migracion, famramapres_fecha_migracion)
        values (SIS_SEQ_FAMRAMAPRES.nextval, v_pk_famrama, v_pk_pres, fecha, null, null, null);        
        --commit;
    else
        --DBMS_OUTPUT.PUT_LINE('Ya existe una famramapres para la famrama de glosa: '||dsc_famrama||' con v_pk_famrama='||v_pk_famrama||' y prestación de código: '||cod_pres||' con v_pk_pres='||v_pk_pres||' no se inserta');
        v_dsc_log:='Warning: Ya existe una famramapres para la famrama de glosa: '||dsc_famrama||' con v_pk_famrama='||v_pk_famrama||' y prestación de código: '||cod_pres||' con v_pk_pres='||v_pk_pres||' no se inserta';
        Sis.Sis_Pro_Log (v_nomproc_1, 1, 0, '.',  v_dsc_log,out_error);
    end if;   

    exception
        when others then
            --rollback;
            v_codora  := SQLCODE;
            v_msgora  := SQLERRM;
            v_codlog  := 1;
            v_dsc_log := 'Excepción inesperada';
            --Sis.Sis_Pro_Log (v_nomproc_1, v_codlog,v_Codora, v_msgora, v_dsc_log,out_error);
            --DBMS_OUTPUT.PUT_LINE('SIS.SIS_PCK_PROGRAMAS_NO_AUGE:  Error inesperado: cod_oracle='||v_codora||' msg_ora='||v_msgora);
            raise;
end;

PROCEDURE QuitarPrestacion(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_pres in varchar2)
  --OUT_ERROR  OUT NUMBER)
  IS
    v_pk_probsalud number(12);
    v_pk_rama number(12);
    v_pk_famrama number(12);
    v_pk_familia number(12);
    v_pk_pres number(12);
    v_pk_famramapres number(12);

    v_num_regs number(12);

    probsalud_inexistente exception;
    rama_inexistente exception;
    famrama_inexistente exception;
    familia_inexistente exception;
    prestacion_inexistente exception;

begin

    /* Chequear que exista un probsalud vigente con la glosa dada  */
    v_pk_probsalud:=Existe('probsalud',dsc_probsalud);

    if(v_pk_probsalud=0) then
        /* Si no existe la rama o no está vigente, levantamos la excepcion */
        --DBMS_OUTPUT.PUT_LINE('No existe el probsalud de glosa '||dsc_probsalud||', no hay registro a eliminar');
        raise probsalud_inexistente;
    end if;

    /* Chequear que exista una rama vigente con la glosa dada  */
    v_pk_rama:=Existe('rama',dsc_rama);

    if(v_pk_rama=0) then
        /* Si no existe la rama o no está vigente, levantamos la excepcion */
        --DBMS_OUTPUT.PUT_LINE('No existe la rama de glosa '||dsc_rama||', no hay registro a eliminar');
        raise rama_inexistente;
    end if;

    --DBMS_OUTPUT.PUT_LINE('pk_rama='||v_pk_rama);

    /* Chequear que exista una famrama vigente con la glosa dada  */
    v_pk_famrama:=Existe('famrama',dsc_famrama);

    if(v_pk_famrama=0) then
        /* Si no existe la famrama o no está vigente, levantamos la excepcion */
        --DBMS_OUTPUT.PUT_LINE('No existe la famrama de glosa '||dsc_famrama||', no hay registro a eliminar');
        raise famrama_inexistente;
    end if;

    --DBMS_OUTPUT.PUT_LINE('v_pk_famrama='||v_pk_famrama);

    /* Chequear que exista una familia para esta famrama  */
    v_pk_familia:=Existe('familia',v_pk_famrama);

    if(v_pk_familia=0) then
        /* Si no existe la familia o no está vigente, levantamos la excepcion */
        --DBMS_OUTPUT.PUT_LINE('No existe la familia para la famrama de glosa '||dsc_famrama||', no hay registro a eliminar');
        raise familia_inexistente;
    end if;

    /* Chequear que exista una prestacion con el código dado  */
    v_pk_pres:=Existe('prestacion',cod_pres);

    if(v_pk_pres=0) then
        /* Si no existe la prestacion, levantar la excepción */
        --DBMS_OUTPUT.PUT_LINE('No existe la prestación de código '||cod_pres||', no hay registro a eliminar');
        raise prestacion_inexistente;
    end if;

    /*Si se cumplen las precondiciones, procedemos a eliminar la prestación */

    v_pk_famramapres:= Existe('famramapres',v_pk_famrama,v_pk_pres);

    if(v_pk_famramapres=0) then
        --DBMS_OUTPUT.PUT_LINE('No existe la famramapres asociada a la famrma de glosa '||dsc_famrama||' y a la prestación de código '||cod_pres||', no hay registro a eliminar');
        v_dsc_log:='Warning: No existe la famramapres asociada a la famrma de glosa '||dsc_famrama||' y a la prestación de código '||cod_pres||', no hay registro a eliminar';
        Sis.Sis_Pro_Log (v_nomproc_1, 1, 0, '.',  v_dsc_log,out_error);
    else
    /* 1o eliminamos la famramapres que fue solicitada en la planilla */
        delete from sis_tab_famramapres famramapres
        where FAMRAMAPRES.FAMRAMAPRES_COD_FAMRAMAPRES=v_pk_famramapres;        
        --commit;
    end if;

    /* Luego hacemos un cruce entre famrama y famramapres con la famrama especificada en la planilla,
    si este cruce da vacío, entonces eliminamos la famrama */

    v_pk_famramapres:=Existe('famrama_famramapres',dsc_famrama);

    if(v_pk_famramapres=0) then
        /* Si el cruce es vacío, procedemos a eliminar la ultima famrama ingresada */
        --DBMS_OUTPUT.PUT_LINE('No existen famramapres asociados a la famrama de glosa '||dsc_famrama||', se procede a eliminar la famrama ultima famrama ingresada');
        delete from sis_tab_famrama famrama
        where FAMRAMA.FAMRAMA_COD_FAMRAMA=v_pk_famrama;        

        /* Además, por consistencia debemos eliminar la familia correspondiente a la famrama */
        --DBMS_OUTPUT.PUT_LINE('Se procede a eliminar familia de pk_famrama='||v_pk_famrama);
        delete from NCAT.NCAT_TAB_FAMILIA familia
        where FAMILIA.FAMILIA_COD_FAMILIA=v_pk_famrama;        
        --commit;
    end if;

    v_pk_famramapres:=Existe('prestacion_famramapres',cod_pres);

    /* Luego hacemos un cruce entre prestacion y famramapres con la prestación especificada en la planilla,
    si este cruce da vacío, entonces eliminamos la prestación */

    if(v_pk_famramapres=0) then
        /* Si el cruce es vacío, procedemos a eliminar la famrama */
        --DBMS_OUTPUT.PUT_LINE('No existen famramapres asociados a la prestación de código '||cod_pres||', se procede a eliminar la prestación');
        delete from sis_tab_prestacion prestacion
        where PRESTACION.PRESTACION_COD_PRESTACION=v_pk_pres;        
        --commit;
    end if;

    v_pk_famrama:=Existe('rama_famrama',dsc_rama);

    /* Luego hacemos un cruce entre famrama y rama con la pk de la rama obtenida,
    si este cruce da vacío, entonces eliminamos la rama */

    if(v_pk_famrama=0) then
        /* Si el cruce es vacío, procedemos a eliminar la rama */
        --DBMS_OUTPUT.PUT_LINE('No existen famrama asociados a la rama de glosa '||dsc_rama||', se procede a eliminar la rama');
        delete from sis_tab_rama rama
        where RAMA.RAMA_COD_RAMA=v_pk_rama;       
        --commit;
    end if;

    v_pk_rama:=Existe('probsalud_rama',dsc_probsalud);

    /* Por ultimo, hacemos un cruce entre rama y probsalud con la pk del probsalud obtenida,
    si este cruce da vacío, entonces eliminamos el probsalud */

    if(v_pk_rama=0) then
        /* Si el cruce es vacío, procedemos a eliminar el probsalud */
        --DBMS_OUTPUT.PUT_LINE('No existen rama asociados al probsalud de glosa '||dsc_rama||', se procede a eliminar el probsalud');
        delete from sis_tab_problsalud probsalud
        where PROBSALUD.PROBLSALUD_COD_PROBLSALUD=v_pk_probsalud;        
        --commit;
    end if;

    exception
            when probsalud_inexistente then
                --rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'probsalud inexistente para glosa '||dsc_probsalud;
                --Sis.Sis_Pro_Log (v_nomproc_2, v_codlog,v_Codora, v_msgora, v_dsc_log,out_error);
                --DBMS_OUTPUT.PUT_LINE('Excepción: Rama inexistente para glosa '||dsc_probsalud);
                raise;
            when rama_inexistente then
                --rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'rama inexistente para glosa '||dsc_rama;
                --Sis.Sis_Pro_Log (v_nomproc_2, v_codlog,v_Codora, v_msgora, v_dsc_log,out_error);
                --DBMS_OUTPUT.PUT_LINE('Excepción: Rama inexistente para glosa '||dsc_rama);
                raise;
            when famrama_inexistente then
                --rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'famrama inexistente para glosa '||dsc_famrama;
                --Sis.Sis_Pro_Log (v_nomproc_2, v_codlog,v_Codora, v_msgora, v_dsc_log,out_error);
                --DBMS_OUTPUT.PUT_LINE('Excepción: famrama inexistente para glosa '||dsc_famrama);
                raise;
            when familia_inexistente then
                --rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'familia inexistente para glosa '||dsc_famrama;
                --Sis.Sis_Pro_Log (v_nomproc_2, v_codlog,v_Codora, v_msgora, v_dsc_log,out_error);
                --DBMS_OUTPUT.PUT_LINE('Excepción: familia inexistente para glosa '||dsc_famrama);
                raise;
            when prestacion_inexistente then
                --rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'prestación inexistente para código '||cod_pres;
                --Sis.Sis_Pro_Log (v_nomproc_2, v_codlog,v_Codora, v_msgora, v_dsc_log,out_error);
                --DBMS_OUTPUT.PUT_LINE('Excepción: prestación inexistente para código '||cod_pres);
                raise;
            when others then
                --rollback;
                v_codora  := SQLCODE;
                v_msgora  := SQLERRM;
                v_codlog  := 1;
                v_dsc_log := 'Excepción inesperada';
                --Sis.Sis_Pro_Log (v_nomproc_2, v_codlog,v_Codora, v_msgora, v_dsc_log,out_error);
                --DBMS_OUTPUT.PUT_LINE('Excepción inesperada: cod_oracle='||v_codora||' msg_ora='||v_msgora);
                raise;
end;

END SIS_PCK_PRESTACION;
/

