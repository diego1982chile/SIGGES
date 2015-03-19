CREATE OR REPLACE PACKAGE BODY NCAT.NCAT_PCK_UNION AS
/******************************************************************************
   NAME:       NCAT_PCK_UNION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        16-02-2015      Diego       1. Created this package body.
******************************************************************************/

FUNCTION Existe(
  tabla in varchar2,
  clave in number
  ) RETURN number IS
  v_pk number(12):=null;
  BEGIN

    case tabla
        when 'union' then
            /* Seleccionar la union más reciente según vigencia, usando como clave de búsqueda la pk de la famrama dada */
             for c1 in ( select un.union_cod_union pk from NCAT.NCAT_TAB_UNION un
                            where un.union_fec_vige>=fecha_ini
                            and un.UNION_PGGENER_O_FAMRAMA=clave
                            and rownum<=1 )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
        when 'unedad' then
            /* Seleccionar la union más reciente según vigencia, usando como clave de búsqueda la pk de la famrama dada */
             for c1 in ( select ue.UNEDAD_COD_UNEDAD pk from NCAT.NCAT_TAB_UNEDAD ue
                            where ue.UNION_COD_UNION=clave )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
        when 'unsexo' then
            /* Seleccionar la union más reciente según vigencia, usando como clave de búsqueda la pk de la famrama dada */
             for c1 in ( select us.UNSEXO_COD_UNSEXO pk from NCAT.NCAT_TAB_UNSEXO us
                         where us.UNION_COD_UNION=clave )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
        when 'unfrec' then
            /* Seleccionar la union más reciente según vigencia, usando como clave de búsqueda la pk de la famrama dada */
             for c1 in ( select uf.UNFREC_COD_UNFREC pk from NCAT.NCAT_TAB_UNFREC uf
                         where uf.UNION_COD_UNION=clave )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
        when 'unincpre' then
            /* Seleccionar la union más reciente según vigencia, usando como clave de búsqueda la pk de la famrama dada */
             for c1 in ( select unp.UNINCPRE_COD_UNINCPRE pk from NCAT.NCAT_TAB_UNINCPRE unp
                         where unp.UNION_COD_UNION=clave )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
        when 'unpsra' then
            /* Seleccionar la union más reciente según vigencia, usando como clave de búsqueda la pk de la famrama dada */
             for c1 in ( select unps.UNPSRA_COD_UNPSRA pk from NCAT.NCAT_TAB_UNPSRA unps
                         where unps.UNION_COD_UNION=clave )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
        when 'relaunre' then
            /* Seleccionar la union más reciente según vigencia, usando como clave de búsqueda la pk de la famrama dada */
             for c1 in ( select r.RELAUNRE_COD_RELAUNRE pk from NCAT.NCAT_TAB_RELAUNRE r
                         where r.UNION_COD_UNION=clave )
             loop
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
  v_pk number(12):=null;
  BEGIN

    case tabla
        when 'unexcpre' then
            /* Seleccionar la union más reciente según vigencia, usando como clave de búsqueda la pk de la famrama dada */
             for c1 in ( select unex.UNEXCPRE_COD_UNEXCPRE pk from NCAT.NCAT_TAB_UNEXCPRE unex
                         where unex.UNION_COD_UNION=clave1
                         and unex.PRESTACION_COD_PRESTACION=clave2 )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
        when 'union_unincpre' then
            /* Seleccionar la union más reciente según vigencia, usando como clave de búsqueda la pk de la famrama dada */
             for c1 in ( select u.UNION_COD_UNION pk from ncat.ncat_tab_union u inner join ncat.ncat_tab_unincpre up
                         on u.UNION_COD_UNION=up.UNION_COD_UNION
                         where u.UNION_PGGENER_O_FAMRAMA=clave1
                         and up.PRESTACION_COD_PRESTACION=clave2
                         and u.UNION_FEC_VIGE=fecha_ini )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;                           
    end case;

    return v_pk;
  END;

  FUNCTION Existe(
  tabla in varchar2,
  clave in varchar2
  ) RETURN number IS
  v_pk number(12):=null;
  BEGIN

    case tabla
        when 'tipinter' then
            /* Seleccionar el tipo de intervalo, por busqueda aproximada, usando como clave de búsqueda la glosa dada */
             for c1 in (select T.TIPINTER_COD_TIPINTER pk from ncat.ncat_tab_tipinter t
                           where T.TIPINTER_DSC_TIPINTER like clave||' %')
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
    end case;

    return v_pk;
  END;
  
  FUNCTION Existe(
  tabla in varchar2,
  clave1 in number,
  clave2 in number,
  clave3 in number
  ) RETURN number IS
  v_pk number(12):=null;
  BEGIN

    case tabla  
          when 'union_unincpre_unpsra' then
            /* Seleccionar la union más reciente según vigencia, usando como clave de búsqueda la pk de la famrama dada */
             for c1 in ( select u.UNION_COD_UNION pk
                         from ncat.ncat_tab_union u inner join ncat.ncat_tab_unincpre up                                                  
                         on u.UNION_COD_UNION=up.UNION_COD_UNION    
                         inner join ncat.ncat_tab_unpsra upr
                         on u.UNION_COD_UNION=upr.UNION_COD_UNION
                         where u.UNION_PGGENER_O_FAMRAMA=clave1
                         and up.PRESTACION_COD_PRESTACION=clave2
                         and upr.PROBLSALUD_COD_PROBLSALUD=clave3
                         and u.UNION_FEC_VIGE=fecha_ini )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop; 
    end case;

    return v_pk;
  END;               

PROCEDURE AgregarNcatPrograma
(p_auge IN varchar2)
IS
dia_ini number(2):=1;
mes_ini number(2):=1;
dia_fin number(2):=31;
mes_fin number(2):=12;
anyo number(5):=EXTRACT(YEAR FROM sysdate);

probsalud_nulo exception;
famrama_nulo exception;
prestacion_nulo exception;
codfamilia_nulo exception;

v_data number(12);
--fecha date;
BEGIN
    v_dsc_log:='Info: Iniciando proceso';

    fecha_ini:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');
    fecha_fin:=TO_DATE(dia_fin||'/'||mes_fin||'/'||anyo,'DD/MM/RRRR');
    sis.sis_pck_prestacion.fecha:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');
    val.val_pck_valoriza.fecha_ini:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');

    -- Setear la fecha de vigencia según caso (auge/no auge)
    if(upper(p_auge)='AUGE') then
        auge:=true;
        cod_docu:=10;
        tiptrapa:=1;
        --tiptrapa:=;
        --anyo:=1000;
        v_nomproc:='AgregarNcatProgramaAuge';
    else
        auge:=false;
        cod_docu:=15;
        tiptrapa:=1;
        v_nomproc:='AgregarNcatProgramaNoAuge';
    end if;
    
    Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log, out_error);
    
    --Chequear que la tabla inputbuffer tenga data
    SELECT 1 into v_data  FROM sis.inputbuffer WHERE ROWNUM=1;

    /* Resetear secuencias involucradas en la transacción */

    SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNION','NCAT.NCAT_SEQ_UNION');
    SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNEDAD','NCAT.NCAT_SEQ_UNEDAD');
    SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNSEXO','NCAT.NCAT_SEQ_UNSEXO');
    SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNFREC','NCAT.NCAT_SEQ_UNFREC');
    SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNEXCPRE','NCAT.NCAT_SEQ_UNEXCPRE');
    SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNINCPRE','NCAT.NCAT_SEQ_UNINCPRE');
    SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNPSRA','NCAT.NCAT_SEQ_UNPSRA');
    SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_RELAUNRE','NCAT.NCAT_SEQ_RELAUNRE');

    for c in ( select IB.PROBLSALUD probsalud, ib.COD_PS_GEN cod_ps_gen, ib.COD_PS cod_ps, ib.COD_PS_AUX cod_ps_aux, ib.rama rama, IB.cod_rama cod_rama, 
               IB.FAMRAMA famrama, IB.COD_FAMILIA cod_familia, IB.PRESTACION prestacion, ib.ARANCEL arancel, ib.EDAD edad, ib.SEXO sexo, 
               ib.FRECUENCIA frecuencia, ib.EXCLUYENTES excluyentes
               from SIS.INPUTBUFFER ib order by IB.ID )
                loop
                    if(c.probsalud is null) then
                        raise probsalud_nulo;
                    end if;
                    if(c.famrama is null) then
                        raise famrama_nulo;
                    end if;
                    if(c.prestacion is null) then
                        raise prestacion_nulo;
                    end if;
                    if(auge) then
                        AgregarUnionAuge(c.probsalud, c.cod_ps_gen, c.cod_ps, c.cod_ps_aux, c.rama, c.famrama, c.cod_familia, c.prestacion, c.arancel, c.edad, c.sexo, c.frecuencia, c.excluyentes);
                    else
                        AgregarUnionNoAuge(c.probsalud, c.rama, c.famrama, c.prestacion, c.arancel, c.edad, c.sexo, c.frecuencia, c.excluyentes);
                    end if;
                end loop;

        -- Vaciar la tabla inputbuffer
        delete from sis.inputbuffer;

        v_dsc_log:='Info: Proceso terminado con éxito.';

        Sis.Sis_Pro_Log (v_nomproc, 1, 0, 'OK', v_dsc_log, out_error);

        commit;

        exception
        when no_data_found then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'Tabla "inputbuffer" vacía. No hay registros a procesar';
            Sis.Sis_Pro_Log ('AgregarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when probsalud_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "probsalud" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log ('AgregarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when famrama_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "famrama" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log ('AgregarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when prestacion_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "prestacion" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log ('AgregarPrograma', v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when others then
            rollback;
            if(v_dsc_log is null or v_codlog is null) then
                v_dsc_log := 'Error';
                v_codlog  := -1;
            end if;
            Sis.Sis_Pro_Log ( v_nomproc, V_CODLOG, SQLCODE, SQLERRM, v_dsc_log, out_error);

END;

PROCEDURE QuitarNcatPrograma
(p_auge IN varchar2)
IS
dia_ini number(2):=1;
mes_ini number(2):=1;
dia_fin number(2):=31;
mes_fin number(2):=12;
anyo number(5):=EXTRACT(YEAR FROM sysdate);

probsalud_nulo exception;
famrama_nulo exception;
prestacion_nulo exception;
codfamilia_nulo exception;

v_data number(12);
--fecha date;
BEGIN
    v_dsc_log:='Info: Iniciando proceso';

    fecha_ini:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');
    fecha_fin:=TO_DATE(dia_fin||'/'||mes_fin||'/'||anyo,'DD/MM/RRRR');
    sis.sis_pck_prestacion.fecha:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');
    val.val_pck_valoriza.fecha_ini:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');

    -- Setear la fecha de vigencia según caso (auge/no auge)
    if(upper(p_auge)='AUGE') then
        auge:=true;
        cod_docu:=10;
        tiptrapa:=1;
        --anyo:=1000;
        v_nomproc:='QuitarNcatProgramaAuge';        
    else
        auge:=false;
        cod_docu:=15;
        tiptrapa:=1;
        v_nomproc:='QuitarNcatProgramaNoAuge';
    end if;
    
    Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log, out_error);
    
    --Chequear que la tabla inputbuffer tenga data
    SELECT 1 into v_data  FROM sis.inputbuffer WHERE ROWNUM=1;

    for c in ( select IB.PROBLSALUD probsalud, ib.COD_PS_GEN cod_ps_gen, ib.COD_PS cod_ps, ib.COD_PS_AUX cod_ps_aux, ib.rama rama, IB.cod_rama cod_rama, 
               IB.FAMRAMA famrama, IB.COD_FAMILIA cod_familia, IB.PRESTACION prestacion, ib.ARANCEL arancel, ib.EDAD edad, ib.SEXO sexo, 
               ib.FRECUENCIA frecuencia, ib.EXCLUYENTES excluyentes
               from SIS.INPUTBUFFER ib order by IB.ID  )
    loop
        if(c.probsalud is null) then
            raise probsalud_nulo;
        end if;
        if(c.famrama is null) then
            raise famrama_nulo;
        end if;
        if(c.prestacion is null) then
            raise prestacion_nulo;
        end if;
        if(auge) then
            QuitarUnionAuge(c.probsalud, c.cod_ps_gen, c.cod_ps, c.cod_ps_aux, c.cod_rama, c.famrama, c.cod_familia, c.prestacion, c.arancel, c.edad, c.sexo, c.frecuencia, c.excluyentes);          
        else
            QuitarUnionNoAuge(c.probsalud, c.rama, c.famrama, c.prestacion, c.arancel, c.edad, c.sexo, c.frecuencia, c.excluyentes);
        end if;
    end loop;

         /* Resetear secuencias involucradas en la transacción */
        SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNION','NCAT.NCAT_SEQ_UNION');
        SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNEDAD','NCAT.NCAT_SEQ_UNEDAD');
        SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNSEXO','NCAT.NCAT_SEQ_UNSEXO');
        SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNFREC','NCAT.NCAT_SEQ_UNFREC');
        SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNEXCPRE','NCAT.NCAT_SEQ_UNEXCPRE');
        SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNINCPRE','NCAT.NCAT_SEQ_UNINCPRE');
        SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_UNPSRA','NCAT.NCAT_SEQ_UNPSRA');
        SIS.SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_RELAUNRE','NCAT.NCAT_SEQ_RELAUNRE');

        -- Vaciar la tabla inputbuffer
        delete from sis.inputbuffer;

        v_dsc_log:='Info: Proceso terminado con éxito.';

        Sis.Sis_Pro_Log (v_nomproc, 1, 0, 'OK', v_dsc_log, out_error);

        commit;

        exception
        when no_data_found then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'Tabla "inputbuffer" vacía. No hay registros a procesar';
            Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when probsalud_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "probsalud" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when famrama_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "famrama" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when prestacion_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'El parámetro "prestacion" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when others then
            rollback;
            if(v_dsc_log is null or v_codlog is null) then
                v_dsc_log := 'Error';
                v_codlog  := -1;
            end if;
            Sis.Sis_Pro_Log ( v_nomproc, V_CODLOG, SQLCODE, SQLERRM, v_dsc_log, out_error);

END;


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
  )
  IS
    v_numedad number(2);
    v_numedad_aux number(2):=null;
    v_boo_cod number(1):=null;
    v_num_cantmax number(2);
    v_pk_presaux number(12):=null;
    v_regla_edad boolean:=false;
    v_regla_frec boolean:=false;

    probsalud_inexistente exception;
    rama_inexistente exception;
    famrama_inexistente exception;
    familia_inexistente exception;
    prestacion_inexistente exception;
    famramapres_inexistente exception;
    valoriza_inexistente exception;
    union_existente exception;
    genero_inexistente exception;
    prestexcluyente_inexistente exception;

    unedad_existente exception;
    unsexo_existente exception;
    unfrec_existente exception;
    unexcpre_existente exception;
    unincpre_existente exception;
    unpsra_existente exception;
    relaunre_existente exception;

    begin

    v_pk_tipinter_aux:=null;

    -- Obtener pk del probsalud usando como clave de búsqueda la glosa dada
    v_pk_probsalud:=SIS.SIS_PCK_PRESTACION.EXISTE('probsalud',dsc_probsalud);

    if(v_pk_probsalud is null) then
        raise probsalud_inexistente;
    end if;

    -- Obtener pk de la rama usando como clave de búsqueda la glosa dada
    v_pk_rama:=SIS.SIS_PCK_PRESTACION.EXISTE('rama',dsc_rama);

    if(v_pk_rama is null) then
         --  Si no existe la rama, levantar excepción
        raise rama_inexistente;
    end if;

    --Seleccionar la famrama más reciente según vigencia, usando como clave de búsqueda la glosa dada
    v_pk_famrama:=SIS.SIS_PCK_PRESTACION.EXISTE('famrama',dsc_famrama);

    if(v_pk_famrama is null) then
        -- Si no existe la famrama o no está vigente, levantar la excepcion
        raise famrama_inexistente;
    end if;

    -- Seleccionar la familia correspondiente a la famrama
    v_pk_familia:=SIS.SIS_PCK_PRESTACION.EXISTE('familia',v_pk_famrama);

    if(v_pk_familia is null) then
        -- Si no existe la familia, levantar la excepcion
        raise familia_inexistente;
    end if;

    v_pk_pres:= SIS.SIS_PCK_PRESTACION.EXISTE('prestacion',cod_pres);

    -- Seleccionar la prestación más reciente según vigencia, usando como clave de búsqueda, el código de prestación dado
    if(v_pk_pres is null) then
        -- Si no existe la prestacion, levantar excepción
        raise prestacion_inexistente;
    end if;

    v_pk_famramapres:=SIS.SIS_PCK_PRESTACION.EXISTE('famramapres',v_pk_famrama,v_pk_pres);

    -- Ahora verificar que existe una famramapres con las pk obtenidas
    if(v_pk_famramapres is null) then
         -- Si no existe la famramapres, levantar la excepción
        raise famramapres_inexistente;
    end if;

    -- Chequear si existe una valoriza asociada a esta prestación o a esta familia, y que además esté vigente
    v_pk_valoriza:= VAL.VAL_PCK_VALORIZA.Existe2('valoriza',v_pk_famrama,v_pk_pres);

    if(v_pk_valoriza is null) then
        raise valoriza_inexistente;
    end if;

    --Si se cumplen las precondiciones, proceder a insertar la union para esta prestacion

    -- 1o insertar la union con: tiptrapa, cod_docu, fec_ini, fec_fin

    v_pk_union:=NCAT.NCAT_PCK_UNION.Existe('union_unincpre',v_pk_famrama, v_pk_pres);

    if(v_pk_union is null) then
        select ncat.ncat_seq_union.nextval into v_pk_union from dual;
        insert into ncat.ncat_tab_union(UNION_COD_UNION, TIPTRAPA_COD_TIPTRAPA, DOCU_COD_DOCU, UNION_FEC_VIGE, UNION_FEC_VCTO, UNION_FEC_CREACION,
                                                     UNION_FEC_MODIFICACION, UNION_PGGENER_O_FAMRAMA)
        values (v_pk_union, tiptrapa, cod_docu, fecha_ini,  fecha_fin, fecha_ini, sysdate, v_pk_famrama);
    else
        raise union_existente;
    end if;

    -- Luego insertar la regla de edad

    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT3(edad)) )
    loop
        v_regla_edad:=true;
        case c.num_param
            when 1 then
                v_pk_tipinter:=NCAT.NCAT_PCK_UNION.Existe('tipinter',c.param);
            when 2 then
                v_numedad:=c.param;
            when 3 then
                case c.param
                    when 'y' then
                        v_boo_cod:=1;
                    when 'o' then
                        v_boo_cod:=2;   
                end case;
            when 4 then
                v_pk_tipinter_aux:=NCAT.NCAT_PCK_UNION.Existe('tipinter',c.param);
            when 5 then
                v_numedad_aux:=c.param;
        end case;
    end loop;

    if(v_regla_edad) then
        -- TODO: Chequear que no exista regla para este cod_union
        if(Existe('unedad',v_pk_union) is null) then
            select NCAT.NCAT_SEQ_UNEDAD.nextval into v_pk_unedad from dual;
            insert into NCAT.NCAT_TAB_UNEDAD(unedad_cod_unedad, union_cod_union, tipinter_cod_tipinter, unedad_num_edadano, tipinter_cod_tipinter_aux, unedad_num_edadano_aux, boo_cod_and)
            values (v_pk_unedad, v_pk_union, v_pk_tipinter, v_numedad, v_pk_tipinter_aux, v_numedad_aux, v_boo_cod);
        else
            raise unedad_existente;
        end if;
    end if;

    -- Luego insertar la regla de sexo
    if(trim(sexo) is not null) then
        v_pk_genero:=SIS.SIS_PCK_helper.Existe('genero',sexo);

        if(v_pk_genero is not null) then
            -- TODO: Chequear que no exista regla para este cod_union y esta prestacion
            if(Existe('unsexo',v_pk_union) is null) then
                select NCAT.NCAT_SEQ_UNSEXO.nextval into v_pk_unsexo from dual;
                insert into NCAT.NCAT_TAB_UNSEXO(unsexo_cod_unsexo, union_cod_union, genero_cod_genero)
                values (v_pk_unsexo, v_pk_union, v_pk_genero);
            else
                raise unsexo_existente;
            end if;
        else
            v_dsc_log:='Warning: género inexistente para glosa '||sexo||' asociado a la famrama de glosa '||dsc_famrama||'. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log,out_error);
        end if;
    end if;

    -- Luego insertar la regla de frecuencia
    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT2(trim(frecuencia),' ')) )
    loop
        if(c.param is not null) then
            v_regla_frec:=true;
            case c.num_param
                when 1 then
                    v_num_cantmax:=c.param;
                when 2 then
                    v_pk_period:= SIS.SIS_PCK_helper.Existe('period',c.param);
            end case;
        end if;
    end loop;

    if(v_regla_frec) then
        -- TODO: Chequear que no exista regla para este cod_union
        if(Existe('unfrec',v_pk_union) is null) then
            select NCAT.NCAT_SEQ_UNFREC.nextval into v_pk_unfrec from dual;
            insert into NCAT.NCAT_TAB_UNFREC(unfrec_cod_unfrec, union_cod_union, period_cod_period, unfrec_num_cantper, unfrec_num_cantmax)
            values (v_pk_unfrec, v_pk_union, v_pk_period, 1, v_num_cantmax);
        else
            raise unfrec_existente;
        end if;
    end if;

    -- Luego insertar la regla de excluyentes
    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT2(trim(excluyentes),',')) )
    loop
        if(c.param is not null) then
            -- TODO: Chequear que no exista regla para este cod_union y esta prestacion
            v_pk_presaux:=sis.sis_pck_prestacion.EXISTE('prestacion',c.param);

            if(v_pk_presaux is not null) then
                if(Existe('unexcpre',v_pk_union, v_pk_presaux) is null) then
                    select NCAT.NCAT_SEQ_UNEXCPRE.nextval into v_pk_unexcpre from dual;
                    insert into NCAT.NCAT_TAB_UNEXCPRE(unexcpre_cod_unexcpre, union_cod_union, prestacion_cod_prestacion)
                    values (v_pk_unexcpre, v_pk_union, v_pk_presaux);
                else
                    raise unexcpre_existente;
                end if;
            end if;
        end if;
    end loop;

    -- Luego insertar unincpre (prestaciones)
    -- TODO: Chequear que no exista regla para este cod_union
    if(Existe('unincpre',v_pk_union) is null) then
        select NCAT.NCAT_SEQ_UNINCPRE.nextval into v_pk_unincpre from dual;
        insert into NCAT.NCAT_TAB_UNINCPRE(unincpre_cod_unincpre, union_cod_union, prestacion_cod_prestacion)
        values (v_pk_unincpre, v_pk_union, v_pk_pres);
    else
        raise unincpre_existente;
    end if;

    -- Luego insertar unspra (probsalud, rama)
    -- TODO: Chequear que no exista regla para este cod_union
    if(Existe('unpsra',v_pk_union) is null) then
        select NCAT.NCAT_SEQ_UNPSRA.nextval into v_pk_unpsra from dual;
        insert into NCAT.NCAT_TAB_UNPSRA(unpsra_cod_unpsra, union_cod_union, problsalud_cod_problsalud, rama_cod_rama, is_cod_is, familia_cod_familia)
        values (v_pk_unpsra, v_pk_union, v_pk_probsalud, v_pk_rama, 5, v_pk_famrama);
    else
        raise unpsra_existente;
    end if;

    -- Luego insertar relaunre
    -- TODO: Chequear que no exista regla para este cod_union
    if(Existe('relaunre',v_pk_union) is null) then
        --select NCAT.NCAT_SEQ_RELAUNRE.nextval into v_pk_relaunre from dual;
        select max(rel.RELAUNRE_COD_RELAUNRE) into v_pk_relaunre from ncat.ncat_tab_relaunre rel;
        insert into NCAT.NCAT_TAB_RELAUNRE(relaunre_cod_relaunre, regla_cod_regla, union_cod_union, tipmotor_cod_tipmotor, relaunre_fec_vige)
        select v_pk_relaunre+rownum id, r.REGLA_COD_REGLA, v_pk_union, 2, fecha_ini from NCAT.NCAT_TAB_REGLA r order by id;
    else
        raise relaunre_existente;
    end if;

    -- en otro caso levantar excepción
    exception
        when probsalud_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'probsalud inexistente para glosa '||dsc_probsalud;
            raise;
        when rama_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'rama inexistente para glosa '||dsc_rama;
            raise;
        when famrama_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'famrama inexistente para glosa '||dsc_famrama;
            raise;
        when familia_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'familia inexistente para famrama de glosa '||dsc_famrama;
            raise;
        when prestacion_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'prestación inexistente para código '||cod_pres;
            raise;
        when famramapres_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'famramapres inexistente para glosa '||dsc_famrama||' y código '||cod_pres;
            raise;
        when valoriza_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'valoriza inexistente para famrama de glosa '||dsc_famrama||' y código de prestación '||cod_pres;
            raise;
        when union_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'union existente para famrama de glosa '||dsc_famrama||', prestación de código '||cod_pres||'. Union de pk='||v_pk_union;
            raise;
        when genero_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'género existente para glosa '||sexo||' asociado a la famrama de glosa '||dsc_famrama||'. Revisar archivo .csv';
            raise;
        when unedad_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unedad existente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unsexo_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unsexo existente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unfrec_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unfrec existente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unincpre_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unincpre existente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unexcpre_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unexcpre existente para union de pk='||v_pk_union||' y prestación de pk='||v_pk_pres;
            raise;
        when unpsra_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unpsra existente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when relaunre_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'hay relaunre existentes para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when prestexcluyente_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'hay prestaciones excluyentes inexistentes para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
    end;


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
  )
  IS
    v_numedad number(2);
    v_numedad_aux number(2):=null;
    v_num_cantmax number(2);
    v_boo_cod number(1):=null;
    v_pk_presaux number(12):=null;
    v_regla_edad boolean:=false;
    v_regla_frec boolean:=false;

    probsalud_inexistente exception;
    rama_inexistente exception;
    famrama_inexistente exception;
    familia_inexistente exception;
    prestacion_inexistente exception;
    famramapres_inexistente exception;
    valoriza_inexistente exception;
    union_inexistente exception;
    genero_inexistente exception;
    unedad_inexistente exception;
    unsexo_inexistente exception;
    unfrec_inexistente exception;
    unexcpre_inexistente exception;
    unincpre_inexistente exception;
    unpsra_inexistente exception;
    relaunre_inexistente exception;
    prestexcluyente_inexistente exception;

    begin

    -- Obtener pk del probsalud usando como clave de búsqueda la glosa dada
    v_pk_probsalud:=SIS.SIS_PCK_PRESTACION.EXISTE('probsalud',dsc_probsalud);

    if(v_pk_probsalud is null) then
        raise probsalud_inexistente;
    end if;

    -- Obtener pk de la rama usando como clave de búsqueda la glosa dada
    v_pk_rama:=SIS.SIS_PCK_PRESTACION.EXISTE('rama',dsc_rama);

    if(v_pk_rama is null) then
         --  Si no existe la rama, levantar excepción
        raise rama_inexistente;
    end if;

    --Seleccionar la famrama más reciente según vigencia, usando como clave de búsqueda la glosa dada
    v_pk_famrama:=SIS.SIS_PCK_PRESTACION.EXISTE('famrama',dsc_famrama);

    if(v_pk_famrama is null) then
        -- Si no existe la famrama o no está vigente, levantar la excepcion
        raise famrama_inexistente;
    end if;

    -- Seleccionar la familia correspondiente a la famrama
    v_pk_familia:=SIS.SIS_PCK_PRESTACION.EXISTE('familia',v_pk_famrama);

    if(v_pk_familia is null) then
        -- Si no existe la familia, levantar la excepcion
        raise familia_inexistente;
    end if;

    v_pk_pres:= SIS.SIS_PCK_PRESTACION.EXISTE('prestacion',cod_pres);

    -- Seleccionar la prestación más reciente según vigencia, usando como clave de búsqueda, el código de prestación dado
    if(v_pk_pres is null) then
        -- Si no existe la prestacion, levantar excepción
        raise prestacion_inexistente;
    end if;

    v_pk_famramapres:=SIS.SIS_PCK_PRESTACION.EXISTE('famramapres',v_pk_famrama,v_pk_pres);

    -- Ahora verificar que existe una famramapres con las pk obtenidas
    if(v_pk_famramapres is null) then
         -- Si no existe la famramapres, levantar la excepción
        raise famramapres_inexistente;
    end if;

    -- Chequear si existe una valoriza asociada a esta prestación o a esta familia, y que además esté vigente
    v_pk_valoriza:= VAL.VAL_PCK_VALORIZA.Existe2('valoriza',v_pk_famrama,v_pk_pres);

    if(v_pk_valoriza is null) then
        raise valoriza_inexistente;
    end if;

    --Si se cumplen las precondiciones, proceder a eliminar la union para esta prestacion

    v_pk_union:=NCAT.NCAT_PCK_UNION.Existe('union_unincpre',v_pk_famrama, v_pk_pres);
    
    if(v_pk_union is null) then
        raise union_inexistente;
    end if;

    -- 1o eliminar los registros hijos de la union

    -- eliminar la regla de edad

    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT3(edad)) )
    loop
        v_regla_edad:=true;
        case c.num_param
            when 1 then
                v_pk_tipinter:=NCAT.NCAT_PCK_UNION.Existe('tipinter',c.param);
            when 2 then
                v_numedad:=c.param;
            when 3 then
                case c.param
                    when 'y' then
                        v_boo_cod:=1;
                    when 'o' then
                        v_boo_cod:=2;   
                end case;
            when 4 then
                v_pk_tipinter_aux:=NCAT.NCAT_PCK_UNION.Existe('tipinter',c.param);
            when 5 then
                v_numedad_aux:=c.param;
        end case;
    end loop;

    if(v_regla_edad) then
        -- TODO: Chequear que no exista regla para este cod_union
        v_pk_unedad:=Existe('unedad',v_pk_union);
        if(v_pk_unedad is not null) then
            delete from NCAT.NCAT_TAB_UNEDAD ue where ue.UNEDAD_COD_UNEDAD=v_pk_unedad;
        else
            raise unedad_inexistente;
        end if;
    end if;

    -- Luego eliminar la regla de sexo

    if(trim(sexo) is not null) then
        v_pk_genero:=SIS.SIS_PCK_helper.Existe('genero',sexo);

        if(v_pk_genero is not null) then
            -- TODO: Chequear que no exista regla para este cod_union y esta prestacion
            v_pk_unsexo:=Existe('unsexo',v_pk_union);
            if(v_pk_unsexo is not null) then
                delete from NCAT.NCAT_TAB_UNSEXO us where us.UNSEXO_COD_UNSEXO=v_pk_unsexo;
            else
                raise unsexo_inexistente;
            end if;
        else
            v_dsc_log:='Warning: género inexistente para glosa '||sexo||' asociado a la famrama de glosa '||dsc_famrama||'. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log,out_error);
        end if;
    end if;

    -- Luego eliminar la regla de frecuencia
    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT2(trim(frecuencia),' ')) )
    loop
        if(c.param is not null) then
            v_regla_frec:=true;
            case c.num_param
                when 1 then
                    v_num_cantmax:=c.param;
                when 2 then
                    v_pk_period:= SIS.SIS_PCK_helper.Existe('period',c.param);
            end case;
        end if;
    end loop;

    if(v_regla_frec) then
        -- TODO: Chequear que no exista regla para este cod_union
        v_pk_unfrec:=Existe('unfrec',v_pk_union);
        if(v_pk_unfrec is not null) then
            delete from NCAT.NCAT_TAB_UNFREC uf where uf.UNFREC_COD_UNFREC=v_pk_unfrec;
        else
            raise unfrec_inexistente;
        end if;
    end if;

    -- Luego eliminar la regla de excluyentes
    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT2(trim(excluyentes),',')) )
    loop
        if(c.param is not null) then
            -- TODO: Chequear que no exista regla para este cod_union y esta prestacion
            v_pk_presaux:=sis.sis_pck_prestacion.EXISTE('prestacion',c.param);

            if(v_pk_presaux is not null) then
                if(Existe('unexcpre',v_pk_union, v_pk_presaux) is not null) then
                    v_pk_unexcpre:=Existe('unexcpre',v_pk_union, v_pk_presaux);
                    if(v_pk_unexcpre is not null) then
                        delete NCAT.NCAT_TAB_UNEXCPRE unex where unex.UNEXCPRE_COD_UNEXCPRE=v_pk_unexcpre;
                    else
                        raise unexcpre_inexistente;
                    end if;
                end if;
            end if;
        end if;
    end loop;

    -- Luego eliminat unincpre (prestaciones)
    -- TODO: Chequear que no exista regla para este cod_union
    v_pk_unincpre:=Existe('unincpre',v_pk_union);
    if(v_pk_unincpre is not null) then
        delete from NCAT.NCAT_TAB_UNINCPRE unin where unin.UNINCPRE_COD_UNINCPRE=v_pk_unincpre;
    else
        raise unincpre_inexistente;
    end if;

    -- Luego eliminar unspra (probsalud, rama)
    -- TODO: Chequear que no exista regla para este cod_union
    v_pk_unpsra:=Existe('unpsra',v_pk_union);
    if(v_pk_unpsra is not null) then
        delete from NCAT.NCAT_TAB_UNPSRA unp where unp.UNPSRA_COD_UNPSRA=v_pk_unpsra;
    else
        raise unpsra_inexistente;
    end if;

    -- Luego eliminar relaunre
    -- TODO: Chequear que no exista regla para este cod_union
    if(Existe('relaunre',v_pk_union) is not null) then
        delete from NCAT.NCAT_TAB_RELAUNRE rel where rel.UNION_COD_UNION=v_pk_union;
    end if;

    -- finalmente eliminar la union con: tiptrapa, cod_docu, fec_ini, fec_fin
    if(v_pk_union is not null) then
        delete from ncat.ncat_tab_union u where u.UNION_COD_UNION=v_pk_union;
    else
        raise union_inexistente;
    end if;

    -- en otro caso levantar excepción

    exception
        when probsalud_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'probsalud inexistente para glosa '||dsc_probsalud;
            raise;
        when rama_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'rama inexistente para glosa '||dsc_rama;
            raise;
        when famrama_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'famrama inexistente para glosa '||dsc_famrama;
            raise;
        when familia_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'familia inexistente para famrama de glosa '||dsc_famrama;
            raise;
        when prestacion_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'prestación inexistente para código '||cod_pres;
            raise;
        when famramapres_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'famramapres inexistente para glosa '||dsc_famrama||' y código '||cod_pres;
            raise;
        when valoriza_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'valoriza inexistente para famrama de glosa '||dsc_famrama||' y código de prestación '||cod_pres;
            raise;
        when union_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'union inexistente para famrama de glosa '||dsc_famrama||', prestación de código '||cod_pres;
            raise;
        when genero_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'género inexistente para glosa '||sexo||' asociado a la famrama de glosa '||dsc_famrama||'. Revisar archivo .csv';
            raise;
        when unedad_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unedad inexistente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unsexo_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unsexo inexistente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unfrec_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unfrec inexistente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unincpre_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unincpre inexistente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unexcpre_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unexcpre inexistente para union de pk='||v_pk_union||' y prestación de pk='||v_pk_pres;
            raise;
        when unpsra_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unpsra inexistente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when relaunre_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'hay relaunre existentes para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when prestexcluyente_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'hay prestaciones excluyentes inexistentes para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
    end;

PROCEDURE AgregarUnionAuge(
  dsc_probsalud in varchar2,
  cod_ps_gen in number,
  cod_ps in number,
  cod_ps_aux in number,  
  cod_rama in number,
  dsc_famrama in varchar2,
  cod_familia in number,
  cod_pres in varchar2,
  arancel in number,
  edad in varchar2,
  sexo in varchar2,
  frecuencia in varchar2,
  excluyentes in varchar2
  )
  IS
    v_numedad number(2);
    v_boo_cod number(1):=null;
    v_numedad_aux number(2);
    v_num_cantmax number(2);
    v_regla_edad boolean:=false;
    v_regla_frec boolean:=false;

    probsalud_inexistente exception;
    probsalud_inconsistente exception;
    rama_inexistente exception;
    famrama_inexistente exception;
    familia_inexistente exception;
    prestacion_inexistente exception;
    famramapres_inexistente exception;
    valoriza_inexistente exception;
    union_existente exception;
    genero_inexistente exception;

    unedad_existente exception;
    unsexo_existente exception;
    unfrec_existente exception;
    unexcpre_existente exception;
    unincpre_existente exception;
    unpsra_existente exception;
    relaunre_existente exception;
    familia_inconsistente exception;
    
    psgener_inexistente exception;
    psgener_inconsistente exception;        
    begin

    /* Chequear que exista un probsalud vigente con el codigo dado  */
    v_pk_probsalud:=SIS.SIS_PCK_PRESTACION.Existe('probsalud',cod_ps);        
    
    if(v_pk_probsalud is null) then
        /* Si no existe el probsalud o no está vigente, levantamos la excepcion */
        raise probsalud_inexistente;
    else
        if not(sis.sis_pck_helper.compare(SIS.SIS_PCK_PRESTACION.GetGlosa('probsalud',v_pk_probsalud),dsc_probsalud,true)) then
            raise probsalud_inconsistente;
        end if;
    end if; 
    
    if(cod_ps_aux is not null) then
        /* Chequear que exista un probsalud vigente con el codigo dado  */
        v_pk_probsalud:=SIS.SIS_PCK_PRESTACION.Existe('probsalud',cod_ps_aux);        
        
        if(v_pk_probsalud is null) then
            /* Si no existe el probsalud o no está vigente, levantamos la excepcion */
            raise probsalud_inexistente;
        else
            if not(sis.sis_pck_helper.compare(SIS.SIS_PCK_PRESTACION.GetGlosa('probsalud',v_pk_probsalud),dsc_probsalud,true)) then
                raise probsalud_inconsistente;
            end if;
        end if;         
    end if;   
    
    if(sis.sis_pck_prestacion.EXISTE('psgener',cod_ps_gen) is null) then
        raise psgener_inexistente;
        /* SE COMENTA POR INCONSISTENCIAS EN LA BD
    else         
        if not(sis.sis_pck_helper.compare(SIS.SIS_PCK_PRESTACION.GetGlosa('psgener',cod_ps_gen),dsc_probsalud,true)) then
            raise psgener_inconsistente;
        end if; 
        */               
    end if;                 

    /* Chequear que exista una rama con el cod_rama dado  */
    if(cod_rama is not null) then
        v_pk_rama:=SIS.SIS_PCK_PRESTACION.Existe('rama',cod_rama);
        
        if(v_pk_rama is null) then
            /* Si no existe la familia, levantar la excepcion */
            raise rama_inexistente;
        end if;
    else
        v_pk_rama:=null;
    end if;    

    if(cod_familia is not null) then
       /* buscar la familia en la tabla familia del usuario NCAT, usando como clave el cod_familia */
        v_pk_familia:=SIS.SIS_PCK_PRESTACION.Existe('familia', cod_familia);

        /* Si no existe la familia, levantamos la excepción */
        if(v_pk_familia is null) then
            raise familia_inexistente;
        else
            -- Si existe una familia para el cod_familia dado, chequear que las glosas coincidan. Si no coinciden, levantar la excepciòn
            if not(sis.sis_pck_helper.compare(SIS.SIS_PCK_PRESTACION.GetGlosa('familia',v_pk_familia),dsc_famrama,false)) then
                raise familia_inconsistente;
            end if;
        end if;   
    else
        /* buscar la familia en la tabla familia del usuario NCAT, usando como clave la glosa */
        v_pk_familia:=SIS.SIS_PCK_PRESTACION.Existe('familia', dsc_famrama);
        --dbms_output.put_line('v_pk_familia='||v_pk_familia);
        
        /* Si no existe la familia, levantamos la excepción */
        if(v_pk_familia is null) then
            raise familia_inexistente;
        end if;
    end if;                

    v_pk_pres:= SIS.SIS_PCK_PRESTACION.EXISTE('prestacion',cod_pres);

    /* Seleccionar la prestación, usando como clave de búsqueda, el código de prestación dado */
    if(v_pk_pres is null) then
        /* Si no existe la prestacion, levantar excepción */
        raise prestacion_inexistente;
    end if;                            

    /* Chequear si existe una valoriza asociada a esta prestación o a esta familia, y que además esté vigente */
    if(v_pk_rama is null) then
        v_pk_valoriza:= val.val_pck_valoriza.Existe2('valoriza2',v_pk_familia,v_pk_pres, v_pk_rama, v_pk_probsalud);
    else        
        v_pk_valoriza:= val.val_pck_valoriza.Existe2('valoriza1',v_pk_familia,v_pk_pres, v_pk_rama, v_pk_probsalud);
    end if;        

    if(v_pk_valoriza is null) then
        raise valoriza_inexistente;
    end if;

    --Si se cumplen las precondiciones, proceder a insertar la union para esta prestacion

    -- 1o insertar la union con: tiptrapa, cod_docu, fec_ini, fec_fin

    v_pk_union:=NCAT.NCAT_PCK_UNION.Existe('union_unincpre_unpsra', cod_ps_gen, v_pk_pres, cod_ps);

    if(v_pk_union is null) then
        select ncat.ncat_seq_union.nextval into v_pk_union from dual;
        insert into ncat.ncat_tab_union(UNION_COD_UNION, TIPTRAPA_COD_TIPTRAPA, DOCU_COD_DOCU, UNION_FEC_VIGE, UNION_FEC_VCTO, UNION_FEC_CREACION,
                                                     UNION_FEC_MODIFICACION, UNION_PGGENER_O_FAMRAMA)
        values (v_pk_union, tiptrapa, cod_docu, fecha_ini,  fecha_fin, fecha_ini, sysdate, cod_ps_gen);
    else
        raise union_existente;
    end if;

    -- Luego insertar la regla de edad

    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT3(edad)) )
    loop
        v_regla_edad:=true;
        case c.num_param
            when 1 then
                v_pk_tipinter:=NCAT.NCAT_PCK_UNION.Existe('tipinter',c.param);
            when 2 then
                v_numedad:=c.param;
            when 3 then
                case c.param
                    when 'y' then
                        v_boo_cod:=1;
                    when 'o' then
                        v_boo_cod:=2;   
                end case;
            when 4 then
                v_pk_tipinter_aux:=NCAT.NCAT_PCK_UNION.Existe('tipinter',c.param);
            when 5 then
                v_numedad_aux:=c.param;
        end case;
    end loop;

    if(v_regla_edad) then
        -- TODO: Chequear que no exista regla para este cod_union
        if(Existe('unedad',v_pk_union) is null) then
            select NCAT.NCAT_SEQ_UNEDAD.nextval into v_pk_unedad from dual;
            insert into NCAT.NCAT_TAB_UNEDAD(unedad_cod_unedad, union_cod_union, tipinter_cod_tipinter, unedad_num_edadano, tipinter_cod_tipinter_aux, unedad_num_edadano_aux)
            values (v_pk_unedad, v_pk_union, v_pk_tipinter, v_numedad, v_pk_tipinter_aux, v_numedad_aux);
        else
            raise unedad_existente;
        end if;
    end if;

    -- Luego insertar la regla de sexo

    if(trim(sexo) is not null) then
        v_pk_genero:=SIS.SIS_PCK_helper.Existe('genero',sexo);

        if(v_pk_genero is not null) then
            -- TODO: Chequear que no exista regla para este cod_union y esta prestacion
            if(Existe('unsexo',v_pk_union) is null) then
                select NCAT.NCAT_SEQ_UNSEXO.nextval into v_pk_unsexo from dual;
                insert into NCAT.NCAT_TAB_UNSEXO(unsexo_cod_unsexo, union_cod_union, genero_cod_genero)
                values (v_pk_unsexo, v_pk_union, v_pk_genero);
            else
                raise unsexo_existente;
            end if;
        else
            v_dsc_log:='Warning: género inexistente para glosa '||sexo||' asociado a la famrama de glosa '||dsc_famrama||'. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log,out_error);
        end if;
    end if;

    -- Luego insertar la regla de frecuencia
    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT2(trim(frecuencia),' ')) )
    loop
        if(c.param is not null) then
            v_regla_frec:=true;
            case c.num_param
                when 1 then
                    v_num_cantmax:=c.param;
                when 2 then
                    v_pk_period:= SIS.SIS_PCK_helper.Existe('period',c.param);
            end case;
        end if;        
    end loop;

    if(v_regla_frec) then
        -- TODO: Chequear que no exista regla para este cod_union
        if(Existe('unfrec',v_pk_union) is null) then
            select NCAT.NCAT_SEQ_UNFREC.nextval into v_pk_unfrec from dual;
            insert into NCAT.NCAT_TAB_UNFREC(unfrec_cod_unfrec, union_cod_union, period_cod_period, unfrec_num_cantper, unfrec_num_cantmax)
            values (v_pk_unfrec, v_pk_union, v_pk_period, 1, v_num_cantmax);
        else
            raise unfrec_existente;
        end if;
    end if;

    -- Luego insertar la regla de excluyentes

    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT2(excluyentes,',')) )
    loop
        -- TODO: Chequear que no exista regla para este cod_union y esta prestacion
        if(Existe('unexcpre',v_pk_union, c.param) is null) then
            select NCAT.NCAT_SEQ_UNEXCPRE.nextval into v_pk_unexcpre from dual;
            insert into NCAT.NCAT_TAB_UNEXCPRE(unexcpre_cod_unexcpre, union_cod_union, prestacion_cod_prestacion)
            values (v_pk_unexcpre, v_pk_union, to_number(c.param));
        else
            raise unexcpre_existente;
        end if;
    end loop;

    -- Luego insertar unincpre (prestaciones)
    -- TODO: Chequear que no exista regla para este cod_union
    if(Existe('unincpre',v_pk_union) is null) then
        select NCAT.NCAT_SEQ_UNINCPRE.nextval into v_pk_unincpre from dual;
        insert into NCAT.NCAT_TAB_UNINCPRE(unincpre_cod_unincpre, union_cod_union, prestacion_cod_prestacion)
        values (v_pk_unincpre, v_pk_union, v_pk_pres);
    else
        raise unincpre_existente;
    end if;

    -- Luego insertar unspra (probsalud, rama)
    -- TODO: Chequear que no exista regla para este cod_union
    if(Existe('unpsra',v_pk_union) is null) then
        select NCAT.NCAT_SEQ_UNPSRA.nextval into v_pk_unpsra from dual;
        insert into NCAT.NCAT_TAB_UNPSRA(unpsra_cod_unpsra, union_cod_union, problsalud_cod_problsalud, rama_cod_rama, is_cod_is, familia_cod_familia)
        values (v_pk_unpsra, v_pk_union, v_pk_probsalud, v_pk_rama, 5, v_pk_familia);
    else
        raise unpsra_existente;
    end if;   

    -- Luego insertar relaunre
    -- TODO: Chequear que no exista regla para este cod_union
    if(Existe('relaunre',v_pk_union) is null) then
        --select NCAT.NCAT_SEQ_RELAUNRE.nextval into v_pk_relaunre from dual;
        select max(rel.RELAUNRE_COD_RELAUNRE) into v_pk_relaunre from ncat.ncat_tab_relaunre rel;
        insert into NCAT.NCAT_TAB_RELAUNRE(relaunre_cod_relaunre, regla_cod_regla, union_cod_union, tipmotor_cod_tipmotor, relaunre_fec_vige)
        select v_pk_relaunre+rownum id, r.REGLA_COD_REGLA, v_pk_union, 2, fecha_ini from NCAT.NCAT_TAB_REGLA r order by id;
    else
        raise relaunre_existente;
    end if;

    -- en otro caso levantar excepción

    exception
        when probsalud_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'probsalud inexistente para glosa '||dsc_probsalud;
            raise;
        when probsalud_inconsistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1010;
            v_dsc_log := 'Existe el probsalud de pk='||v_pk_probsalud||', sin embargo la glosa '||dsc_probsalud||' no coincide, revisar archivo .csv';
            raise;   
        when psgener_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'psgener inexistente para cod_ps_gen '||cod_ps_gen;
            raise;
        when psgener_inconsistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1010;
            v_dsc_log := 'Existe el psgener de pk='||cod_ps_gen||', sin embargo la glosa '||dsc_probsalud||' no coincide, revisar archivo .csv';
            raise;                         
        when familia_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'familia inexistente para famrama de glosa '||dsc_famrama;
            raise;
        when familia_inconsistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'Existe la familia de pk '||cod_familia||', sin embargo la glosa no coincide, revisar archivo .csv';
            raise;       
        when prestacion_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'prestación inexistente para código '||cod_pres;
            raise;
        when valoriza_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'valoriza inexistente para famrama de glosa '||dsc_famrama||' y código de prestación '||cod_pres||'. (pk_familia='||v_pk_familia||',pk_pres='||v_pk_pres||',pk_rama='||v_pk_rama||',pk_probsalud='||v_pk_probsalud||')';
            raise;
        when union_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'union existente para famrama de glosa '||dsc_famrama||' (pk='||v_pk_familia||'), prestación de código '||cod_pres||' (pk='||v_pk_pres||') y cod_ps='||cod_ps||'. Union de pk='||v_pk_union;
            raise;
        when genero_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'género existente para glosa '||sexo||' asociado a la famrama de glosa '||dsc_famrama||'. Revisar archivo .csv';
            raise;
        when unedad_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unedad existente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unsexo_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unsexo existente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unfrec_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unfrec existente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unincpre_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unincpre existente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unexcpre_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unexcpre existente para union de pk='||v_pk_union||' y prestación de pk='||v_pk_pres;
            raise;
        when unpsra_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unpsra existente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when relaunre_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'hay relaunre existentes para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
    end;

PROCEDURE QuitarUnionAuge(
  dsc_probsalud in varchar2,
  cod_ps_gen in number,
  cod_ps in number,
  cod_ps_aux in number,  
  cod_rama in number,
  dsc_famrama in varchar2,
  cod_familia in number,
  cod_pres in varchar2,
  arancel in number,
  edad in varchar2,
  sexo in varchar2,
  frecuencia in varchar2,
  excluyentes in varchar2
  )
  IS
    v_numedad number(2);
    v_numedad_aux number(2):=null;
    v_num_cantmax number(2);
    v_pk_presaux number(12):=null;
    v_regla_edad boolean:=false;
    v_regla_frec boolean:=false;    

    probsalud_inexistente exception;
    probsalud_inconsistente exception;
    rama_inexistente exception;
    famrama_inexistente exception;
    familia_inexistente exception;
    familia_inconsistente exception;
    prestacion_inexistente exception;
    famramapres_inexistente exception;
    valoriza_inexistente exception;
    union_inexistente exception;
    genero_inexistente exception;
    unedad_inexistente exception;
    unsexo_inexistente exception;
    unfrec_inexistente exception;
    unexcpre_inexistente exception;
    unincpre_inexistente exception;
    unpsra_inexistente exception;
    relaunre_inexistente exception;
    
    psgener_inexistente exception;
    psgener_inconsistente exception;

    begin

     /* Chequear que exista un probsalud vigente con el codigo dado  */
    v_pk_probsalud:=SIS.SIS_PCK_PRESTACION.Existe('probsalud',cod_ps);        
    
    if(v_pk_probsalud is null) then
        /* Si no existe el probsalud o no está vigente, levantamos la excepcion */
        raise probsalud_inexistente;
    else
        if not(sis.sis_pck_helper.compare(SIS.SIS_PCK_PRESTACION.GetGlosa('probsalud',v_pk_probsalud),dsc_probsalud,true)) then
            raise probsalud_inconsistente;
        end if;
    end if;  
    
    if(cod_ps_aux is not null) then
        /* Chequear que exista un probsalud vigente con el codigo dado  */
        v_pk_probsalud:=SIS.SIS_PCK_PRESTACION.Existe('probsalud',cod_ps_aux);        
        
        if(v_pk_probsalud is null) then
            /* Si no existe el probsalud o no está vigente, levantamos la excepcion */
            raise probsalud_inexistente;
        else
            if not(sis.sis_pck_helper.compare(SIS.SIS_PCK_PRESTACION.GetGlosa('probsalud',v_pk_probsalud),dsc_probsalud,true)) then
                raise probsalud_inconsistente;
            end if;
        end if;         
    end if;       
    
    if(sis.sis_pck_prestacion.EXISTE('psgener',cod_ps_gen) is null) then
        raise psgener_inexistente;
        /* SE COMENTA POR INCONSISTENCIAS EN LA BD
    else         
        if not(sis.sis_pck_helper.compare(SIS.SIS_PCK_PRESTACION.GetGlosa('psgener',cod_ps_gen),dsc_probsalud,true)) then
            raise psgener_inconsistente;
        end if; 
        */               
    end if;    
 
    /* Chequear que exista una rama con el cod_rama dado  */
    if(cod_rama is not null) then
        v_pk_rama:=SIS.SIS_PCK_PRESTACION.Existe('rama',cod_rama);
        
        if(v_pk_rama is null) then
            /* Si no existe la familia, levantar la excepcion */
            raise rama_inexistente;
        end if;
    else
        v_pk_rama:=null;
    end if;    

    if(cod_familia is not null) then
       /* buscar la familia en la tabla familia del usuario NCAT, usando como clave el cod_familia */
        v_pk_familia:=SIS.SIS_PCK_PRESTACION.Existe('familia', cod_familia);

        /* Si no existe la familia, levantamos la excepción */
        if(v_pk_familia is null) then
            raise familia_inexistente;
        else
            -- Si existe una familia para el cod_familia dado, chequear que las glosas coincidan. Si no coinciden, levantar la excepciòn
            if not(sis.sis_pck_helper.compare(SIS.SIS_PCK_PRESTACION.GetGlosa('familia',v_pk_familia),dsc_famrama,false)) then
                raise familia_inconsistente;
            end if;
        end if;   
    else
        /* buscar la familia en la tabla familia del usuario NCAT, usando como clave la glosa */
        v_pk_familia:=SIS.SIS_PCK_PRESTACION.Existe('familia', dsc_famrama);
        --dbms_output.put_line('v_pk_familia='||v_pk_familia);
        
        /* Si no existe la familia, levantamos la excepción */
        if(v_pk_familia is null) then
            raise familia_inexistente;
        end if;
    end if;
    
    /* Chequear que exista una prestacion con el código dado  */
    v_pk_pres:=SIS.SIS_PCK_PRESTACION.Existe('prestacion',cod_pres);

    if(v_pk_pres is null) then
        /* Si no existe la prestacion, levantar la excepción */
        raise prestacion_inexistente;
    end if;        
    
    /* Chequear si existe una valoriza asociada a esta prestación o a esta familia, y que además esté vigente */
    if(v_pk_rama is null) then
        v_pk_valoriza:= val.val_pck_valoriza.Existe2('valoriza2',v_pk_familia,v_pk_pres, v_pk_rama, v_pk_probsalud);
    else
        v_pk_valoriza:= val.val_pck_valoriza.Existe2('valoriza1',v_pk_familia,v_pk_pres, v_pk_rama, v_pk_probsalud);
    end if;       

    if(v_pk_valoriza is null) then
        raise valoriza_inexistente;
    end if;

    --Si se cumplen las precondiciones, proceder a insertar la union para esta prestacion

    -- 1o eliminar la union con: tiptrapa, cod_docu, fec_ini, fec_fin
    
    v_pk_union:=NCAT.NCAT_PCK_UNION.Existe('union_unincpre_unpsra', cod_ps_gen, v_pk_pres, cod_ps);

    if(v_pk_union is null) then
        raise union_inexistente;
    end if;

    -- Luego eliminar la regla de edad

    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT3(edad)) )
    loop
        v_regla_edad:=true;
        case c.num_param
            when 1 then
                v_pk_tipinter:=NCAT.NCAT_PCK_UNION.Existe('tipinter',c.param);
            when 2 then
                v_numedad:=c.param;
            when 3 then
                v_pk_tipinter_aux:=NCAT.NCAT_PCK_UNION.Existe('tipinter',c.param);
            when 4 then
                v_numedad_aux:=c.param;
        end case;
    end loop;

    if(v_regla_edad) then
        -- TODO: Chequear que no exista regla para este cod_union
        v_pk_unedad:=Existe('unedad',v_pk_union);
        if(v_pk_unedad is not null) then
            delete from NCAT.NCAT_TAB_UNEDAD ue where ue.UNEDAD_COD_UNEDAD=v_pk_unedad;
        else
            raise unedad_inexistente;
        end if;
    end if;

    -- Luego eliminar la regla de sexo

    if(trim(sexo) is not null) then
        v_pk_genero:=SIS.SIS_PCK_helper.Existe('genero',sexo);

        if(v_pk_genero is not null) then
            -- TODO: Chequear que no exista regla para este cod_union y esta prestacion
            v_pk_unsexo:=Existe('unsexo',v_pk_union);
            if(v_pk_unsexo is not null) then
                delete from NCAT.NCAT_TAB_UNSEXO us where us.UNSEXO_COD_UNSEXO=v_pk_unsexo;
            else
                raise unsexo_inexistente;
            end if;
        else
            v_dsc_log:='Warning: género inexistente para glosa '||sexo||' asociado a la famrama de glosa '||dsc_famrama||'. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log,out_error);
        end if;
    end if;

    -- Luego eliminar la regla de frecuencia
    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT2(trim(frecuencia),' ')) )
    loop
        if(c.param is not null) then
            v_regla_frec:=true;
            case c.num_param
                when 1 then
                    v_num_cantmax:=c.param;
                when 2 then
                    v_pk_period:= SIS.SIS_PCK_helper.Existe('period',c.param);
            end case;
        end if;
    end loop;

    if(v_regla_frec) then
        -- TODO: Chequear que no exista regla para este cod_union
        v_pk_unfrec:=Existe('unfrec',v_pk_union);
        if(v_pk_unfrec is not null) then
            delete from NCAT.NCAT_TAB_UNFREC uf where uf.UNFREC_COD_UNFREC=v_pk_unfrec;
        else
            raise unfrec_inexistente;
        end if;
    end if;

    -- Luego insertar la regla de excluyentes

    -- Luego eliminar la regla de excluyentes
    for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT2(trim(excluyentes),',')) )
    loop
        if(c.param is not null) then
            -- TODO: Chequear que no exista regla para este cod_union y esta prestacion
            v_pk_presaux:=sis.sis_pck_prestacion.EXISTE('prestacion',c.param);

            if(v_pk_presaux is not null) then
                if(Existe('unexcpre',v_pk_union, v_pk_presaux) is not null) then
                    v_pk_unexcpre:=Existe('unexcpre',v_pk_union, v_pk_presaux);
                    if(v_pk_unexcpre is not null) then
                        delete NCAT.NCAT_TAB_UNEXCPRE unex where unex.UNEXCPRE_COD_UNEXCPRE=v_pk_unexcpre;
                    else
                        raise unexcpre_inexistente;
                    end if;
                end if;
            end if;
        end if;
    end loop;

    -- Luego insertar unincpre (prestaciones)
    -- TODO: Chequear que no exista regla para este cod_union
    v_pk_unincpre:=Existe('unincpre',v_pk_union);
    if(v_pk_unincpre is not null) then
        delete from NCAT.NCAT_TAB_UNINCPRE unin where unin.UNINCPRE_COD_UNINCPRE=v_pk_unincpre;
    else
        raise unincpre_inexistente;
    end if;

    -- Luego insertar unspra (probsalud, rama)
    -- TODO: Chequear que no exista regla para este cod_union
    v_pk_unpsra:=Existe('unpsra',v_pk_union);
    if(v_pk_unpsra is not null) then
        delete from NCAT.NCAT_TAB_UNPSRA unp where unp.UNPSRA_COD_UNPSRA=v_pk_unpsra;
    else
        raise unpsra_inexistente;
    end if;

    -- Luego insertar relaunre
    -- TODO: Chequear que no exista regla para este cod_union
    if(Existe('relaunre',v_pk_union) is not null) then
        delete from NCAT.NCAT_TAB_RELAUNRE rel where rel.UNION_COD_UNION=v_pk_union;
    end if;
    
    -- finalmente eliminar la union con: tiptrapa, cod_docu, fec_ini, fec_fin
    delete from ncat.ncat_tab_union u where u.UNION_COD_UNION=v_pk_union;
    -- en otro caso levantar excepción

    exception
        when probsalud_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'probsalud inexistente para glosa '||dsc_probsalud;
            raise;
        when probsalud_inconsistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1010;
            v_dsc_log := 'Existe el probsalud de pk='||v_pk_probsalud||', sin embargo la glosa '||dsc_probsalud||' no coincide, revisar archivo .csv';
            raise;  
        when psgener_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1011;
            v_dsc_log := 'psgener inexistente para cod_ps_gen '||cod_ps_gen;
            raise;
        when psgener_inconsistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1012;
            v_dsc_log := 'Existe el psgener de pk='||cod_ps_gen||', sin embargo la glosa '||dsc_probsalud||' no coincide, revisar archivo .csv';
            raise;               
        when familia_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'familia inexistente para famrama de glosa '||dsc_famrama;
            raise;
        when prestacion_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'prestación inexistente para código '||cod_pres;
            raise;
        when valoriza_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'valoriza inexistente para famrama de glosa '||dsc_famrama||' y código de prestación '||cod_pres;
            raise;
        when union_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'union inexistente para famrama de glosa '||dsc_famrama||', prestación de código '||cod_pres;
            raise;
        when genero_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'género inexistente para glosa '||sexo||' asociado a la famrama de glosa '||dsc_famrama||'. Revisar archivo .csv';
            raise;
        when unedad_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unedad inexistente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unsexo_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unsexo inexistente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unfrec_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unfrec inexistente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unincpre_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unincpre inexistente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when unexcpre_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unexcpre inexistente para union de pk='||v_pk_union||' y prestación de pk='||v_pk_pres||' familia de glosa '||dsc_famrama;
            raise;
        when unpsra_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'unpsra inexistente para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
        when relaunre_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'hay relaunre existentes para famrama de glosa '||dsc_famrama||' y union de pk='||v_pk_union;
            raise;
    end;

END NCAT_PCK_UNION; 
/

