INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(004) [AT.VAL] DS MD VAL_PCK_VALORIZA.pkb', 
 'Creaci�n de definici�n package VAL.VAL_PCK_VALORIZA',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY VAL.VAL_PCK_VALORIZA AS
/******************************************************************************
   NAME:       SIS_PCK_VAL_PRESTACION
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05-02-2015      Diego       1. Created this package.
******************************************************************************/

FUNCTION Existe(
  tabla in varchar2,
  clave in number
  ) RETURN number IS
  v_pk number(12):=null;
  BEGIN
    case tabla
        when 'valoriza_revalpres_revalps' then
            /* Seleccionar la valoriza m�s reciente seg�n vigencia, usando como clave de b�squeda, el arancel dado y el pk de prestaci�n */
             for c1 in ( select VALORIZA.VALORIZA_COD_VALORIZA pk from VAL.VAL_TAB_VALORIZA valoriza left outer join VAL.VAL_TAB_REVALPREST revalprest
                            on VALORIZA.VALORIZA_COD_VALORIZA=REVALPREST.VALORIZA_COD_VALORIZA
                            left outer join VAL.VAL_TAB_REVALPS revalps
                            on VALORIZA.VALORIZA_COD_VALORIZA=REVALPS.VALORIZA_COD_VALORIZA
                            where VALORIZA.VALORIZA_COD_VALORIZA =clave )
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
        when 'valoriza' then
            /* Seleccionar la valoriza m�s reciente seg�n vigencia, usando como clave de b�squeda, el arancel dado y el pk de prestaci�n */
             for c1 in ( select VALORIZA.VALORIZA_COD_VALORIZA pk from VAL.VAL_TAB_VALORIZA valoriza inner join VAL.VAL_TAB_REVALPREST revalprest
                            on VALORIZA.VALORIZA_COD_VALORIZA=REVALPREST.VALORIZA_COD_VALORIZA
                            where REVALPREST.PRESTACION_COD_PRESTACION=clave1
                            and VALORIZA.VALORIZA_PRECIO=clave2
                            and VALORIZA.VALORIZA_FEC_VIGE>=fecha_ini )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
    end case;

    return v_pk;
  END;

  FUNCTION Existe2(
  tabla in varchar2,
  clave1 in number,
  clave2 in number
  ) RETURN number IS
  v_pk number(12):=null;
  BEGIN
    case tabla
        when 'valoriza' then
            /* Seleccionar la valoriza m�s reciente seg�n vigencia, usando como clave de b�squeda, el arancel dado y el pk de prestaci�n */
             for c1 in ( select VALORIZA.VALORIZA_COD_VALORIZA pk from VAL.VAL_TAB_VALORIZA valoriza left outer join VAL.VAL_TAB_REVALPREST revalprest
                         on VALORIZA.VALORIZA_COD_VALORIZA=REVALPREST.VALORIZA_COD_VALORIZA left outer join VAL.VAL_TAB_REVALPS revalps
                         on VALORIZA.VALORIZA_COD_VALORIZA=REVALPS.VALORIZA_COD_VALORIZA
                         where REVALPREST.PRESTACION_COD_PRESTACION=clave2
                         and REVALPS.FAMILIA_COD_FAMILIA=clave1 )
                            --and VALORIZA.VALORIZA_FEC_VIGE>=fecha_ini )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
             end loop;
       when 'revalpres' then
            /* Seleccionar la revalpres asociada al pk de valoriza y pk de prestacion dado */
             for c1 in ( select REVALPRES.REVALPREST_COD_REVALPREST pk from VAL.VAL_TAB_REVALPREST revalpres
                            where REVALPRES.VALORIZA_COD_VALORIZA=clave1
                            and REVALPRES.PRESTACION_COD_PRESTACION =clave2 )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
         when 'revalps' then
            /* Seleccionar la revalps asociada al pk de valoriza y pk de familia dado */
             for c1 in ( select REVALPS.REVALPS_COD_REVALPS pk from VAL.VAL_TAB_REVALPS revalps
                            where revalps.VALORIZA_COD_VALORIZA=clave1
                            and REVALPS.FAMILIA_COD_FAMILIA =clave2 )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
         when 'revalps_auge' then
            /* Seleccionar la revalps asociada al pk de valoriza y pk de familia dado */
             for c1 in ( select REVALPS.REVALPS_COD_REVALPS pk from VAL.VAL_TAB_REVALPS revalps
                            where revalps.VALORIZA_COD_VALORIZA=clave1
                            and revalps.PROBLSALUD_COD_PROBLSALUD=clave2 )
             loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
              end loop;
    end case;

    return v_pk;
  END;

PROCEDURE AgregarValPrograma
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
arancel_nulo exception;

v_data number(12);
--fecha date;
BEGIN
    v_dsc_log:='Info: Iniciando proceso';

    fecha_ini:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');
    fecha_fin:=TO_DATE(dia_fin||'/'||mes_fin||'/'||anyo,'DD/MM/RRRR');

    -- Setear la fecha de vigencia seg�n caso (auge/no auge)
    if(upper(p_auge)='AUGE') then
        auge:=true;
        --anyo:=1000;
        sis.sis_pck_prestacion.fecha:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');
        v_nomproc:='AgregarValProgramaAuge';
    else
        auge:=false;
        sis.sis_pck_prestacion.fecha:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');
        v_nomproc:='AgregarValProgramaNoAuge';
    end if;

    Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log, out_error);

    --Chequear que la tabla inputbuffer tenga data
    SELECT 1 into v_data  FROM sis.inputbuffer WHERE ROWNUM=1;

    /* Resetear secuencias involucradas en la transacci�n */
    SIS.SIS_PCK_HELPER.RESETSEQ('VAL.VAL_TAB_VALORIZA','VAL.VAL_SEQ_VALORIZA');
    SIS.SIS_PCK_HELPER.RESETSEQ('VAL.VAL_TAB_REVALPREST','VAL.VAL_SEQ_REVALPREST');
    SIS.SIS_PCK_HELPER.RESETSEQ('VAL.VAL_TAB_REVALPS','VAL.VAL_SEQ_REVALPS');

     for c in ( select IB.PROBLSALUD probsalud, IB.RAMA rama, ib.COD_RAMA cod_rama, IB.FAMRAMA famrama, ib.COD_FAMILIA cod_familia, IB.PRESTACION prestacion, IB.arancel arancel
                from SIS.INPUTBUFFER ib order by IB.ID )
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
                if(c.arancel is null) then
                    raise arancel_nulo;
                end if;
                --Si es auge, se debe ingresar la prestaci�n tantas veces como problsalud con la misma glosa existan
                if(auge) then
                    AgregarValorizaAuge(c.probsalud, c.rama, c.cod_rama, c.famrama, c.cod_familia, c.prestacion, c.arancel);
                else
                    AgregarValorizaNoAuge(c.probsalud, c.rama, c.famrama, c.prestacion, c.arancel);
                end if;
            end loop;

    -- Vaciar la tabla inputbuffer
    delete from sis.inputbuffer;

    VAL_PCK_VALORIZA.V_DSC_LOG:='Info: Proceso terminado con �xito.';

    Sis.Sis_Pro_Log (v_nomproc, 1, 0, 'OK', val_PCK_valoriza.v_dsc_log, val_pck_valoriza.out_error);

    commit;

    exception
    when no_data_found then
        rollback;
        v_codora  := 0;
        v_msgora  := 'Excepci�n';
        v_codlog  := 1;
        v_dsc_log := 'Tabla "inputbuffer" vac�a. No hay registros a procesar';
        Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
    when probsalud_nulo then
        rollback;
        v_codora  := 0;
        v_msgora  := 'Excepci�n';
        v_codlog  := 1;
        v_dsc_log := 'El par�metro "probsalud" es null. Revisar archivo .csv';
        Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
    when famrama_nulo then
        rollback;
        v_codora  := 0;
        v_msgora  := 'Excepci�n';
        v_codlog  := 1;
        v_dsc_log := 'El par�metro "famrama" es null. Revisar archivo .csv';
        Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
    when prestacion_nulo then
        rollback;
        v_codora  := 0;
        v_msgora  := 'Excepci�n';
        v_codlog  := 1;
        v_dsc_log := 'El par�metro "prestacion" es null. Revisar archivo .csv';
        Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
    when arancel_nulo then
        rollback;
        v_codora  := 0;
        v_msgora  := 'Excepci�n';
        v_codlog  := 1;
        v_dsc_log := 'El par�metro "arancel" es null. Revisar archivo .csv';
        Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
    when others then
        rollback;
        v_dsc_log := 'Error';
        v_codlog  := 1;
        Sis.Sis_Pro_Log (v_nomproc, VAL_PCK_VALORIZA.V_CODLOG, SQLCODE, SQLERRM,  VAL_PCK_VALORIZA.v_dsc_log, VAL_PCK_VALORIZA.out_error);

END;

PROCEDURE QuitarValPrograma
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
arancel_nulo exception;

v_data number(12);
--fecha date;
BEGIN
    v_dsc_log:='Info: Iniciando proceso';


    fecha_ini:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');
    fecha_fin:=TO_DATE(dia_fin||'/'||mes_fin||'/'||anyo,'DD/MM/RRRR');

    -- Setear la fecha de vigencia seg�n caso (auge/no auge)
    if(upper(p_auge)='AUGE') then
        auge:=true;
        --anyo:=1000;
        sis.sis_pck_prestacion.fecha:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');
        v_nomproc:='QuitarValProgramaAuge';
    else
        auge:=false;
        sis.sis_pck_prestacion.fecha:=TO_DATE(dia_ini||'/'||mes_ini||'/'||anyo,'DD/MM/RRRR');
        v_nomproc:='QuitarValProgramaNoAuge';
    end if;

    Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log, out_error);

    --Chequear que la tabla inputbuffer tenga data
    SELECT 1 into v_data  FROM sis.inputbuffer WHERE ROWNUM=1;

    for c in ( select IB.PROBLSALUD probsalud, IB.RAMA rama, ib.COD_RAMA cod_rama, IB.FAMRAMA famrama, ib.COD_FAMILIA cod_familia, IB.PRESTACION prestacion, IB.arancel arancel
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
            if(c.arancel is null) then
                raise arancel_nulo;
            end if;

            --Si es auge, se debe ingresar la prestaci�n tantas veces como problsalud con la misma glosa existan
            if(auge) then
                QuitarValorizaAuge(c.probsalud, c.rama, c.cod_rama, c.famrama, c.cod_familia, c.prestacion, c.arancel);
            else
                QuitarValorizaNoAuge(c.probsalud, c.rama, c.famrama, c.prestacion, c.arancel);
            end if;
        end loop;

         /* Resetear secuencias involucradas en la transacci�n */
        SIS.SIS_PCK_HELPER.RESETSEQ('VAL.VAL_TAB_VALORIZA','VAL.VAL_SEQ_VALORIZA');
        SIS.SIS_PCK_HELPER.RESETSEQ('VAL.VAL_TAB_REVALPREST','VAL.VAL_SEQ_REVALPREST');
        SIS.SIS_PCK_HELPER.RESETSEQ('VAL.VAL_TAB_REVALPS','VAL.VAL_SEQ_REVALPS');

        -- Vaciar la tabla inputbuffer
        delete from sis.inputbuffer;

        VAL_PCK_VALORIZA.V_DSC_LOG:='Info: Proceso terminado con �xito.';

        Sis.Sis_Pro_Log (v_nomproc, 1, 0, 'OK', val_PCK_valoriza.v_dsc_log, val_pck_valoriza.out_error);

        commit;

        exception
        when no_data_found then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepci�n';
            v_codlog  := 1;
            v_dsc_log := 'Tabla "inputbuffer" vac�a. No hay registros a procesar';
            Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when probsalud_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepci�n';
            v_codlog  := 1;
            v_dsc_log := 'El par�metro "probsalud" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when famrama_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepci�n';
            v_codlog  := 1;
            v_dsc_log := 'El par�metro "famrama" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when prestacion_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepci�n';
            v_codlog  := 1;
            v_dsc_log := 'El par�metro "prestacion" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when arancel_nulo then
            rollback;
            v_codora  := 0;
            v_msgora  := 'Excepci�n';
            v_codlog  := 1;
            v_dsc_log := 'El par�metro "arancel" es null. Revisar archivo .csv';
            Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
        when others then
            rollback;
            v_dsc_log := 'Error';
            v_codlog  := 1;
            Sis.Sis_Pro_Log (v_nomproc, V_CODLOG, SQLCODE, SQLERRM, v_dsc_log, out_error);

END;

  PROCEDURE AgregarValorizaNoAuge(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_pres in varchar2,
  arancel in number)
  IS
    v_pk_valoriza number(12);
    v_pk_revalpres number(12);
    v_pk_revalps number(12);

    probsalud_inexistente exception;
    rama_inexistente exception;
    rama_inexistente2 exception;
    famrama_inexistente exception;
    familia_inexistente exception;
    prestacion_inexistente exception;
    famramapres_inexistente exception;

    valoriza_existente exception;
    revalpres_existente exception;
    revalps_existente exception;

    begin

    /* Obtener pk del probsalud usando como clave de b�squeda la glosa dada */
    v_pk_probsalud:=SIS.SIS_PCK_PRESTACION.EXISTE('probsalud',dsc_probsalud);

    if(v_pk_probsalud is null) then
        /*  TODO: Si no existe el probsalud, levantar la excepcion */
        raise probsalud_inexistente;
    end if;

    /* Obtener pk de la rama usando como clave de b�squeda la glosa dada */
    v_pk_rama:=SIS.SIS_PCK_PRESTACION.EXISTE('rama',dsc_rama);

    if(v_pk_rama is null) then
         /*  Si no existe la rama, levantar excepci�n */
        raise rama_inexistente;
    end if;

    /* Seleccionar la famrama m�s reciente seg�n vigencia, usando como clave de b�squeda la glosa dada */
    v_pk_famrama:=SIS.SIS_PCK_PRESTACION.EXISTE('famrama',dsc_famrama);

    if(v_pk_famrama is null) then
        /* Si no existe la famrama o no est� vigente, levantar la excepcion */
        raise famrama_inexistente;
    end if;

    /* Seleccionar la familia correspondiente a la famrama */
    v_pk_familia:=SIS.SIS_PCK_PRESTACION.EXISTE('familia',v_pk_famrama);

    if(v_pk_familia is null) then
        /* Si no existe la familia, levantar la excepcion */
        raise familia_inexistente;
    end if;

   v_pk_pres:= SIS.SIS_PCK_PRESTACION.EXISTE('prestacion',cod_pres);

    /* Seleccionar la prestaci�n m�s reciente seg�n vigencia, usando como clave de b�squeda, el c�digo de prestaci�n dado */
    if(v_pk_pres is null) then
        /* Si no existe la prestacion, levantar excepci�n */
        raise prestacion_inexistente;
    end if;

    v_pk_famramapres:=SIS.SIS_PCK_PRESTACION.EXISTE('famramapres',v_pk_famrama,v_pk_pres);

    /*Ahora verificar que existe una famramapres con las pk obtenidas */
    if(v_pk_famramapres is null) then
         /* Si no existe la famramapres, levantar la excepci�n */
        raise famramapres_inexistente;
    end if;

    /*Si se cumplen las precondiciones, proceder a insertar la valorizaci�n para esta prestacion */

    /* Chequear si existe una valoriza asociada a esta prestaci�n o a esta familia, y que adem�s est� vigente */
    v_pk_valoriza:= Existe2('valoriza',v_pk_famrama,v_pk_pres);

    if(v_pk_valoriza is null) then
        select val.val_seq_valoriza.nextval into v_pk_valoriza from dual;
        insert into VAL.VAL_TAB_VALORIZA(valoriza_cod_valoriza, valoriza_precio, valoriza_fec_vige, valoriza_fec_vcto, docu_cod_docu, valoriza_fec_error, valoriza_cod_vali, valoriza_dsc_obs)
        values (v_pk_valoriza , arancel, fecha_ini , fecha_fin, 15,  null,1,null);
    else
        raise valoriza_existente;
    end if;

    /* Luego Insertar revalPrest*/

    /* Chequear si existe una revalpres asociada al valoriza y a la prestacion */
    v_pk_revalpres:= Existe2('revalpres',v_pk_valoriza,v_pk_pres);

    if(v_pk_revalpres is null) then
        select VAL.VAL_SEQ_REVALPREST.nextval into v_pk_revalpres from dual;
        insert into VAL.VAL_TAB_REVALPREST(revalprest_cod_revalprest, valoriza_cod_valoriza, prestacion_cod_prestacion)
        values (v_pk_revalpres, v_pk_valoriza, v_pk_pres);
    else
        raise revalpres_existente;
    end if;

    /* Luego Insertar revalPS*/

    /* Chequear si existe una revalps asociada al valoriza y a la familia */
    v_pk_revalps:= Existe2('revalps',v_pk_valoriza,v_pk_famrama);

    if(v_pk_revalps is null) then
        select val.VAL_SEQ_REVALPS.nextval into v_pk_revalps from dual;
        insert into VAL.VAL_TAB_REVALPS(revalps_cod_revalps, valoriza_cod_valoriza, problsalud_cod_problsalud, rama_cod_rama, familia_cod_familia, regdefisfam_cod_regdefisfam)
        values (v_pk_revalps, v_pk_valoriza, v_pk_probsalud, v_pk_rama, v_pk_famrama,null);
    else
        raise revalps_existente;
    end if;

    exception
        when probsalud_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'probsalud inexistente para glosa '||dsc_probsalud||'. Se har� rollback';
            raise;
        when rama_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'rama inexistente para glosa '||dsc_rama||'. Se har� rollback';
            raise;
        when rama_inexistente2 then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'rama inexistente para probsalud de pk '||v_pk_probsalud;
            raise;
        when famrama_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'famrama inexistente para glosa '||dsc_famrama||'. Se har� rollback';
            raise;
        when familia_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'familia inexistente para famrama de glosa '||dsc_famrama||'. Se har� rollback';
            raise;
        when prestacion_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'prestaci�n inexistente para c�digo '||cod_pres||'. Se har� rollback';
            raise;
        when famramapres_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'famramapres inexistente para glosa '||dsc_famrama||' y c�digo '||cod_pres||'. Se har� rollback';
            raise;
        when valoriza_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'valoriza existente para famrama de glosa '||dsc_famrama||' y c�digo de prestaci�n '||cod_pres||'. Se har� rollback';
            raise;
        when revalpres_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'revalpres existente para famrama de glosa '||dsc_famrama||' y c�digo de prestaci�n '||cod_pres||'. Se har� rollback';
            raise;
        when revalps_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'revalps existente para famrama de glosa '||dsc_famrama||' y c�digo de prestaci�n '||cod_pres||'. Se har� rollback';
            raise;
        when others then
            v_codora  := SQLCODE;
            v_msgora  := SQLERRM;
            v_codlog  := 1;
            v_dsc_log := 'Error inesperado. Se har� rollback';
            raise;
    end;

    PROCEDURE QuitarValorizaNoAuge(
      dsc_probsalud in varchar2,
      dsc_rama in varchar2,
      dsc_famrama in varchar2,
      cod_pres in varchar2,
      arancel in number)
      IS
        v_pk_valoriza number(12);
        v_pk_revalpres number(12);
        v_pk_revalps number(12);

        probsalud_inexistente exception;
        rama_inexistente exception;
        rama_inexistente2 exception;
        famrama_inexistente exception;
        familia_inexistente exception;
        prestacion_inexistente exception;
        famramapres_inexistente exception;

        valoriza_inexistente exception;
        revalpres_inexistente exception;
        revalps_inexistente exception;

        union_existente exception;
    begin

    v_pk_probsalud:=SIS.SIS_PCK_PRESTACION.Existe('probsalud',dsc_probsalud);

    if(v_pk_probsalud is null) then
        /*  Si no existe el probsalud, levantar la excepci�n */
       raise probsalud_inexistente;
    end if;

    -- Si no es auge o la glosa de la rama no es nula, se busca por glosa
    v_pk_rama:=SIS.SIS_PCK_PRESTACION.Existe('rama',dsc_rama);

    if(v_pk_rama is null) then
         /*  Si no existe la rama, levantar la excepci�n */
       raise rama_inexistente;
    end if;

    /* Chequear que exista una famrama vigente con la glosa dada  */
    v_pk_famrama:=SIS.SIS_PCK_PRESTACION.Existe('famrama',dsc_famrama);

    if(v_pk_famrama is null) then
        /* Si no existe la famrama o no est� vigente, levantamos la excepcion */
        raise famrama_inexistente;
    end if;

    /* Seleccionar la familia correspondiente a la famrama */
    v_pk_familia:=SIS.SIS_PCK_PRESTACION.EXISTE('familia',v_pk_famrama);

    if(v_pk_familia is null) then
        /* Si no existe la familia, levantar la excepcion */
        raise familia_inexistente;
    end if;

    /* Chequear que exista una prestacion con el c�digo dado  */
    v_pk_pres:=SIS.SIS_PCK_PRESTACION.Existe('prestacion',cod_pres);

    if(v_pk_pres is null) then
        /* Si no existe la prestacion, levantar la excepci�n */
        raise prestacion_inexistente;
    end if;

    v_pk_famramapres:=SIS.SIS_PCK_PRESTACION.EXISTE('famramapres',v_pk_famrama,v_pk_pres);

    /*Ahora verificar que existe una famramapres con las pk obtenidas */
    if(v_pk_famramapres is null) then
         /* Si no existe la famramapres, levantar la excepci�n */
        raise famramapres_inexistente;
    end if;

    /* Chequear que no exista una union para esta familia y esta prestacion  */
    v_pk_union:=NCAT.NCAT_PCK_UNION.Existe('union_unincpre', v_pk_famrama, v_pk_pres);

    if(v_pk_union is not null) then
        /* Si no existe la prestacion, levantar la excepci�n */
        raise union_existente;
    end if;

    /*Si se cumplen las precondiciones, procedemos a eliminar la valorizaci�n */

    v_pk_valoriza:= Existe2('valoriza', v_pk_famrama, v_pk_pres);

    if(v_pk_valoriza is null) then
        raise valoriza_inexistente;
    end if;

    v_pk_revalpres:= Existe2('revalpres', v_pk_valoriza, v_pk_pres);

    if(v_pk_revalpres is null) then
        raise revalpres_inexistente;
    end if;

    /* 1o eliminamos la revalpres de la prestaci�n previamente obtenida y con el arancel dado */
    delete from VAL.VAL_TAB_REVALPREST revalprest
    where REVALPREST.REVALPREST_COD_REVALPREST=v_pk_revalpres;

    v_pk_revalps:= Existe2('revalps', v_pk_valoriza, v_pk_famrama);

    if(v_pk_revalps is null) then
        raise revalps_inexistente;
    end if;

    /* Luego eliminamos la revalps, usando como llave la pk_probsalud+pk_rama+pk_famrama+pk_valoriza */
    delete from VAL.VAL_TAB_REVALPS revalps
    where REVALPS.REVALPS_COD_REVALPS=v_pk_revalps;

    /* Luego hacemos un cruce outer join entre la valoriza, revalprest y revalps. Si este cruce da vac�o, entonces eliminamos la valoriza */

    delete from VAL.VAL_TAB_VALORIZA valoriza
    where VALORIZA.VALORIZA_COD_VALORIZA=v_pk_valoriza;

    exception
    when probsalud_inexistente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'probsalud inexistente para rama de glosa '||dsc_rama;
        raise;
    when rama_inexistente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'rama inexistente para glosa '||dsc_rama;
        raise;
    when rama_inexistente2 then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'rama inexistente para probsalud de pk '||v_pk_probsalud;
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
    when valoriza_inexistente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'valoriza inexistente para famrama de glosa '||dsc_famrama||' y c�digo de prestaci�n '||cod_pres;
        raise;
    when revalpres_inexistente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'revalpres inexistente para famrama de glosa '||dsc_famrama||' y c�digo de prestaci�n '||cod_pres;
        raise;
    when revalps_inexistente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'revalps inexistente para famrama de glosa '||dsc_famrama||' y valoriza de pk de '||v_pk_valoriza;
        raise;
    when union_existente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'union existente para famrama de glosa '||dsc_famrama||' y prestaci�n de c�digo '||cod_pres||'. union de pk='||v_pk_union;
        raise;
    when others then
        rollback;
        v_codora  := SQLCODE;
        v_msgora  := SQLERRM;
        v_codlog  := 1;
        v_dsc_log := 'Error inesperado';
    end;

  PROCEDURE AgregarValorizaAuge(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  cod_rama in number,
  dsc_famrama in varchar2,
  cod_familia in number,
  cod_pres in varchar2,
  arancel in number)
  IS
    v_pk_valoriza number(12);
    v_pk_revalpres number(12);
    v_pk_revalps number(12);

    probsalud_inexistente exception;
    rama_inexistente exception;
    rama_inexistente2 exception;
    famrama_inexistente exception;
    familia_inexistente exception;
    prestacion_inexistente exception;
    famramapres_inexistente exception;

    valoriza_existente exception;
    revalpres_existente exception;
    revalps_existente exception;

    familia_inconsistente exception;

    begin

    /* Chequear que exista un probsalud vigente con la glosa dada  */
    v_pk_probsalud:=Existe('probsalud',dsc_probsalud);

    if(v_pk_probsalud is null) then
        /* Si no existe el probsalud o no est� vigente, levantamos la excepcion */
        raise probsalud_inexistente;
    end if;

    /* Chequear que exista una rama con el cod_rama dado  */
    v_pk_rama:=Existe('rama',cod_rama);

   /* buscar la familia en la tabla familia del usuario NCAT, usando como clave el cod_familia */
    v_pk_familia:=SIS.SIS_PCK_PRESTACION.Existe('familia', cod_familia);

    /* Si no existe la familia, levantamos la excepci�n */
    if(v_pk_familia is null) then
        --dbms_output.PUT_LINE('voy a agregar familia');
        raise familia_inexistente;
    else
        -- Si existe una familia para el cod_familia dado, chequear que las glosas coincidan. Si no coinciden, levantar la excepci�n
        if not(SIS.SIS_PCK_PRESTACION.GetGlosa('familia',v_pk_familia)=trim(dsc_famrama)) then
            raise familia_inconsistente;
        end if;
    end if;

   v_pk_pres:= SIS.SIS_PCK_PRESTACION.EXISTE('prestacion',cod_pres);

    /* Seleccionar la prestaci�n, usando como clave de b�squeda, el c�digo de prestaci�n dado */
    if(v_pk_pres is null) then
        /* Si no existe la prestacion, levantar excepci�n */
        raise prestacion_inexistente;
    end if;

    /*Si se cumplen las precondiciones, proceder a insertar la valorizaci�n para esta prestacion */

    /* Chequear si existe una valoriza asociada a esta prestaci�n o a esta familia, y que adem�s est� vigente */
    v_pk_valoriza:= Existe2('valoriza',v_pk_familia,v_pk_pres);

    if(v_pk_valoriza is null) then
        select val.val_seq_valoriza.nextval into v_pk_valoriza from dual;
        insert into VAL.VAL_TAB_VALORIZA(valoriza_cod_valoriza, valoriza_precio, valoriza_fec_vige, valoriza_fec_vcto, docu_cod_docu, valoriza_fec_error, valoriza_cod_vali, valoriza_dsc_obs)
        values (v_pk_valoriza , arancel, fecha_ini , fecha_fin, 15,  null,1,null);
    else
        raise valoriza_existente;
    end if;

    /* Luego Insertar revalPrest*/

    /* Chequear si existe una revalpres asociada al valoriza y a la prestacion */
    v_pk_revalpres:= Existe2('revalpres',v_pk_valoriza,v_pk_pres);

    if(v_pk_revalpres is null) then
        select VAL.VAL_SEQ_REVALPREST.nextval into v_pk_revalpres from dual;
        insert into VAL.VAL_TAB_REVALPREST(revalprest_cod_revalprest, valoriza_cod_valoriza, prestacion_cod_prestacion)
        values (v_pk_revalpres, v_pk_valoriza, v_pk_pres);
    else
        raise revalpres_existente;
    end if;

    /* Luego Insertar revalPS, para todos los probsalud asociados a la glosa del probsalud dada */

    for c2 in (select Ps.PROBLSALUD_COD_PROBLSALUD pk from sis.sis_tab_problsalud ps
               where convert(upper(trim(ps.PROBLSALUD_DSC_NOMBRE)),'US7ASCII') like '%'||convert(upper(trim(dsc_probsalud)),'US7ASCII')||'%')
    loop
         v_pk_probsalud:=c2.pk;
        /* Chequear si existe una revalps asociada al valoriza y al probsalud */
        v_pk_revalps:= Existe2('revalps_auge',v_pk_valoriza,v_pk_probsalud);

        if(v_pk_revalps is null) then
            select val.VAL_SEQ_REVALPS.nextval into v_pk_revalps from dual;
            insert into VAL.VAL_TAB_REVALPS(revalps_cod_revalps, valoriza_cod_valoriza, problsalud_cod_problsalud, rama_cod_rama, familia_cod_familia, regdefisfam_cod_regdefisfam)
            values (v_pk_revalps, v_pk_valoriza, v_pk_probsalud, v_pk_rama, v_pk_famrama,null);
        else
            raise revalps_existente;
        end if;
    end loop;

    exception
        when probsalud_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'probsalud inexistente para glosa '||dsc_probsalud||'. Se har� rollback';
            raise;
        when rama_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'rama inexistente para glosa '||dsc_rama||'. Se har� rollback';
            raise;
        when rama_inexistente2 then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'rama inexistente para probsalud de pk '||v_pk_probsalud;
            raise;
        when famrama_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'famrama inexistente para glosa '||dsc_famrama||'. Se har� rollback';
            raise;
        when familia_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'familia inexistente para famrama de glosa '||dsc_famrama||'. Se har� rollback';
            raise;
        when prestacion_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'prestaci�n inexistente para c�digo '||cod_pres||'. Se har� rollback';
            raise;
        when famramapres_inexistente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'famramapres inexistente para glosa '||dsc_famrama||' y c�digo '||cod_pres||'. Se har� rollback';
            raise;
        when valoriza_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'valoriza existente para famrama de glosa '||dsc_famrama||' y c�digo de prestaci�n '||cod_pres||'. Se har� rollback';
            raise;
        when revalpres_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'revalpres existente para famrama de glosa '||dsc_famrama||' y c�digo de prestaci�n '||cod_pres||'. Se har� rollback';
            raise;
        when revalps_existente then
            v_codora  := 0;
            v_msgora  := '.';
            v_codlog  := 1;
            v_dsc_log := 'revalps existente para famrama de glosa '||dsc_famrama||' y c�digo de prestaci�n '||cod_pres||'. Se har� rollback';
            raise;
        when familia_inconsistente then
            v_codora  := 0;
            v_msgora  := 'Excepci�n';
            v_codlog  := 1;
            v_dsc_log := 'Existe la familia de pk '||cod_familia||', sin embargo la glosa no coincide, revisar archivo .csv';
            raise;
        when others then
            --rollback;
            v_codora  := SQLCODE;
            v_msgora  := SQLERRM;
            v_codlog  := 1;
            v_dsc_log := 'Error inesperado. Se har� rollback';
            raise;
    end;

PROCEDURE QuitarValorizaAuge(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  cod_rama in number,
  dsc_famrama in varchar2,
  cod_familia in number,
  cod_pres in varchar2,
  arancel in number)
  IS
    v_pk_valoriza number(12);
    v_pk_revalpres number(12);
    v_pk_revalps number(12);

    probsalud_inexistente exception;
    rama_inexistente exception;
    rama_inexistente2 exception;
    famrama_inexistente exception;
    familia_inexistente exception;
    prestacion_inexistente exception;
    famramapres_inexistente exception;

    valoriza_inexistente exception;
    revalpres_inexistente exception;
    revalps_inexistente exception;

    union_existente exception;

    begin

    v_pk_probsalud:=SIS.SIS_PCK_PRESTACION.Existe('probsalud',dsc_probsalud);

    if(v_pk_probsalud is null) then
        /*  Si no existe el probsalud, levantar la excepci�n */
       raise probsalud_inexistente;
    end if;

    /* Seleccionar la familia correspondiente a la famrama */
    v_pk_familia:=SIS.SIS_PCK_PRESTACION.EXISTE('familia',v_pk_famrama);

    if(v_pk_familia is null) then
        /* Si no existe la familia, levantar la excepcion */
        raise familia_inexistente;
    end if;

    /* Chequear que exista una prestacion con el c�digo dado  */
    v_pk_pres:=SIS.SIS_PCK_PRESTACION.Existe('prestacion',cod_pres);

    if(v_pk_pres is null) then
        /* Si no existe la prestacion, levantar la excepci�n */
        raise prestacion_inexistente;
    end if;

    /* Chequear que no exista una union para esta familia y esta prestacion  */
    v_pk_union:=NCAT.NCAT_PCK_UNION.Existe('union_unincpre', v_pk_famrama, v_pk_pres);

    if(v_pk_union is not null) then
        /* Si no existe la prestacion, levantar la excepci�n */
        raise union_existente;
    end if;

  /*Si se cumplen las precondiciones, procedemos a eliminar la valorizaci�n */

    v_pk_valoriza:= Existe2('valoriza', v_pk_famrama, v_pk_pres);

    if(v_pk_valoriza is null) then
        raise valoriza_inexistente;
    end if;

    v_pk_revalpres:= Existe2('revalpres', v_pk_valoriza, v_pk_pres);

    if(v_pk_revalpres is null) then
        raise revalpres_inexistente;
    end if;

    /* 1o eliminamos la revalpres de la prestaci�n previamente obtenida */
    delete from VAL.VAL_TAB_REVALPREST revalprest
    where REVALPREST.REVALPREST_COD_REVALPREST=v_pk_revalpres;

    /* Luego eliminamos la revalPS, para todos los probsalud asociados a la glosa del probsalud dada */

    for c2 in (select Ps.PROBLSALUD_COD_PROBLSALUD pk from sis.sis_tab_problsalud ps
               where convert(upper(trim(ps.PROBLSALUD_DSC_NOMBRE)),'US7ASCII') like '%'||convert(upper(trim(dsc_probsalud)),'US7ASCII')||'%')
    loop
         v_pk_probsalud:=c2.pk;
        /* Chequear si existe una revalps asociada al valoriza y al probsalud */
        v_pk_revalps:= Existe2('revalps_auge',v_pk_valoriza,v_pk_probsalud);

        if(v_pk_revalps is not null) then
            /* Luego eliminamos la revalps, usando como llave la pk_probsalud+pk_rama+pk_famrama+pk_valoriza */
            delete from VAL.VAL_TAB_REVALPS revalps
            where REVALPS.REVALPS_COD_REVALPS=v_pk_revalps;
        else
            raise revalps_inexistente;
        end if;
    end loop;

    delete from VAL.VAL_TAB_VALORIZA valoriza
    where VALORIZA.VALORIZA_COD_VALORIZA=v_pk_valoriza;

    exception
    when probsalud_inexistente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'probsalud inexistente para rama de glosa '||dsc_rama;
        raise;
    when rama_inexistente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'rama inexistente para glosa '||dsc_rama;
        raise;
    when rama_inexistente2 then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'rama inexistente para probsalud de pk '||v_pk_probsalud;
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
    when valoriza_inexistente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'valoriza inexistente para famrama de glosa '||dsc_famrama||' y c�digo de prestaci�n '||cod_pres;
        raise;
    when revalpres_inexistente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'revalpres inexistente para famrama de glosa '||dsc_famrama||' y c�digo de prestaci�n '||cod_pres;
        raise;
    when revalps_inexistente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'revalps inexistente para famrama de glosa '||dsc_famrama||' y valoriza de pk de '||v_pk_valoriza;
        raise;
    when union_existente then
        v_codora  := 0;
        v_msgora  := '.';
        v_codlog  := 1;
        v_dsc_log := 'union existente para famrama de glosa '||dsc_famrama||' y prestaci�n de c�digo '||cod_pres||'. union de pk='||v_pk_union;
        raise;
    when others then
        rollback;
        v_codora  := SQLCODE;
        v_msgora  := SQLERRM;
        v_codlog  := 1;
        v_dsc_log := 'Error inesperado';
    end;

END VAL_PCK_VALORIZA; 
/

