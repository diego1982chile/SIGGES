INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(008) [AT.SIS] DS MD SIS_PCK_PRESTACION.pkb', 
 'Creación de definición de package SIS_PCK_PRESTACION',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------

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
  v_pk number(12):=null;
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
            /* Seleccionar el probsalud usando como clave de búsqueda la glosa dada */
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
        when 'familia' then
            /* Seleccionar la familia, usando como clave de búsqueda la glosa dada */
              for c1 in ( select f.FAMILIA_COD_FAMILIA pk
                          from ncat.ncat_tab_familia f
                          where convert(upper(trim(f.FAMILIA_DSC_FAMILIA)),'US7ASCII')=convert(upper(trim(clave)),'US7ASCII')
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
        when 'genero' then
            /* Seleccionar la prestación más reciente según vigencia, usando como clave de búsqueda, el código de prestación dado */
                for c1 in ( select g.GENERO_COD_GENERO pk
                                from sis_tab_genero g
                                where upper(trim(g.GENERO_DSC_NOMBRE))=upper(trim(clave)) )
                 loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
        when 'period' then
            /* Seleccionar la prestación más reciente según vigencia, usando como clave de búsqueda, el código de prestación dado */
                for c1 in ( select p.PERIOD_COD_PERIOD pk
                                from sis_tab_period p
                                where convert(upper(trim(p.PERIOD_DSC_UNIDAD)),'US7ASCII')=convert(upper(trim(clave)),'US7ASCII') )
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
  v_pk number(12):=null;
  BEGIN
    case tabla
        when 'familia' then
            /* Seleccionar la familia, usando como clave de búsqueda la pk de la famrama */
              for c1 in ( select familia.FAMILIA_COD_FAMILIA pk
                          from NCAT.NCAT_TAB_FAMILIA familia
                          where FAMILIA.FAMILIA_COD_FAMILIA= clave )
                loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
        when 'probsalud' then
            /* Seleccionar la familia, usando como clave de búsqueda la pk de la famrama */
              for c1 in ( select ps.PROBLSALUD_COD_PROBLSALUD pk
                          from SIS.SIS_TAB_PROBLSALUD ps
                          where ps.PROBLSALUD_COD_PROBLSALUD= clave )
                loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
        when 'rama' then
            /* Seleccionar la familia, usando como clave de búsqueda la pk de la famrama */
              for c1 in ( select r.RAMA_COD_RAMA pk
                          from SIS.SIS_TAB_RAMA r
                          where r.RAMA_COD_RAMA= clave )
                loop
                    v_pk := c1.pk;
                    exit; -- only care about one record, so exit.
                end loop;
    end case;

    return v_pk;
  END;

  FUNCTION Existe(
  tabla in varchar2,
  clave1 in varchar2,
  clave2 in number
  ) RETURN number IS
  v_pk number(12):=null;
  BEGIN
    case tabla
        when 'rama' then
            /* Seleccionar la rama, usando como clave de búsqueda la pk del probsalud */
          for c1 in ( select R.RAMA_COD_RAMA pk
                         from sis.sis_tab_rama r
                         where convert(upper(trim(R.RAMA_DSC_RAMA)),'US7ASCII')=convert(upper(trim(clave1)),'US7ASCII')
                         and R.PROBLSALUD_COD_PROBLSALUD=clave2 )
            loop
                v_pk := c1.pk;
                exit; -- only care about one record, so exit.
            end loop;
        when 'famrama' then
            /* Seleccionar la famrama, usando como clave de búsqueda la pk de la rama */
          for c1 in ( select FR.FAMRAMA_COD_FAMRAMA pk
                         from sis.sis_tab_famrama fr
                         where convert(upper(trim(famrama_dsc_famrama)),'US7ASCII')=convert(upper(trim(clave1)),'US7ASCII')
                         and FR.RAMA_COD_RAMA=clave2 )
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
        when 'famramapres' then
            /* Seleccionar la rama usando como clave de búsqueda la glosa dada */
             for c1 in ( select FAMRAMAPRES.FAMRAMAPRES_COD_FAMRAMAPRES pk from sis_tab_famramapres famramapres
             where FAMRAMAPRES.FAMRAMA_COD_FAMRAMA= clave1
             and FAMRAMAPRES.PRESTACION_COD_PRESTACION= clave2 )
             loop
                v_pk:= c1.pk;
                exit; -- only care about one record, so exit.
              end loop;
    end case;

    return v_pk;
  END;

  FUNCTION GetGlosa(
  tabla in varchar2,
  clave in number
  ) RETURN varchar2 IS
  v_glosa varchar2(150):='';
  BEGIN
    case tabla
        when 'familia' then
            /* Seleccionar la familia, usando como clave de búsqueda la pk de la famrama */
              for c1 in ( select trim(familia.FAMILIA_DSC_FAMILIA) glosa
                          from NCAT.NCAT_TAB_FAMILIA familia
                          where FAMILIA.FAMILIA_COD_FAMILIA= clave )
                loop
                    v_glosa := c1.glosa;
                    exit; -- only care about one record, so exit.
                end loop;
        when 'probsalud' then
            /* Seleccionar la familia, usando como clave de búsqueda la pk de la famrama */
              for c1 in ( select trim(ps.PROBLSALUD_DSC_NOMBRE) glosa
                          from SIS.SIS_TAB_PROBLSALUD ps
                          where ps.PROBLSALUD_COD_PROBLSALUD = clave )
                loop
                    v_glosa := c1.glosa;
                    exit; -- only care about one record, so exit.
                end loop;
    end case;

    return v_glosa;
  END;

PROCEDURE AgregarPrograma
(p_auge IN varchar2)
IS
dia number(2):=1;
mes number(2):=1;
anyo number(5):=EXTRACT(YEAR FROM sysdate);

probsalud_nulo exception;
famrama_nulo exception;
prestacion_nulo exception;
codfamilia_nulo exception;

v_data number(12);
--fecha date;
BEGIN
    v_dsc_log:='Info: Iniciando proceso';

    -- Setear la fecha de vigencia según caso (auge/no auge)
    if(upper(p_auge)='AUGE') then
        auge:=true;
        cod_docu:=10;
        --anyo:=1000;
        fecha:=TO_DATE(dia||'/'||mes||'/'||anyo,'DD/MM/RRRR');
        v_nomproc:='AgregarProgramaAuge';
        /* Resetear secuencias involucradas en la transacción */
        SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_FAMILIA','NCAT.NCAT_SEQ_FAMILIA_AUGE');
    else
        auge:=false;
        cod_docu:=15;
        fecha:=TO_DATE(dia||'/'||mes||'/'||anyo,'DD/MM/RRRR');
        v_nomproc:='AgregarProgramaNoAuge';
    end if;

    Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log, out_error);

        --Chequear que la tabla inputbuffer tenga data
    SELECT 1 into v_data  FROM sis.inputbuffer WHERE ROWNUM=1;

    /* Resetear secuencias involucradas en la transacción */
    SIS_PCK_HELPER.RESETSEQ('SIS_TAB_PROBLSALUD','SIS_SEQ_PROBLSALUD');
    SIS_PCK_HELPER.RESETSEQ('SIS_TAB_RAMA','SIS_SEQ_RAMA');
    SIS_PCK_HELPER.RESETSEQ('SIS_TAB_FAMRAMA','SIS_SEQ_FAMRAMA');
    SIS_PCK_HELPER.RESETSEQ('SIS_TAB_PRESTACION','SIS_SEQ_PRESTACION');
    SIS_PCK_HELPER.RESETSEQ('SIS_TAB_FAMRAMAPRES','SIS_SEQ_FAMRAMAPRES');

     for c in ( select IB.PROBLSALUD probsalud, IB.RAMA rama, IB.FAMRAMA famrama, IB.COD_FAMILIA cod_familia, IB.PRESTACION prestacion from SIS.INPUTBUFFER ib order by IB.ID )
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

            if(auge) then
                AgregarPrestacionAuge(c.probsalud, c.rama, c.famrama, c.cod_familia, c.prestacion);
            else
                AgregarPrestacionNoAuge(c.probsalud, c.rama, c.famrama, c.prestacion);
            end if;
        end loop;

        -- Vaciar la tabla inputbuffer
        delete from sis.inputbuffer;

        SIS_PCK_PRESTACION.v_dsc_log:='Info: Proceso terminado con éxito.';

        Sis.Sis_Pro_Log (v_nomproc, 1, 0, 'OK', SIS_PCK_PRESTACION.v_dsc_log, SIS_PCK_PRESTACION.out_error);

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
            v_dsc_log := 'Error';
            v_codlog  := 1;
            Sis.Sis_Pro_Log (v_nomproc, SIS_PCK_PRESTACION.V_CODLOG, SQLCODE, SQLERRM,  SIS_PCK_PRESTACION.v_dsc_log, SIS_PCK_PRESTACION.out_error);
END;

PROCEDURE QuitarPrograma
(p_auge IN varchar2)
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

    -- Setear la fecha de vigencia según caso (auge/no auge)
    if(upper(p_auge)='AUGE') then
        auge:=true;
        cod_docu:=10;
        --anyo:=1000;
        fecha:=TO_DATE(dia||'/'||mes||'/'||anyo,'DD/MM/RRRR');
        v_nomproc:='QuitarProgramaAuge';
    else
        auge:=false;
        cod_docu:=15;
        fecha:=TO_DATE(dia||'/'||mes||'/'||anyo,'DD/MM/RRRR');
        v_nomproc:='QuitarProgramaNoAuge';
    end if;

    Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log, out_error);

    --Chequear que la tabla inputbuffer tenga data
    SELECT 1 into v_data  FROM sis.inputbuffer WHERE ROWNUM=1;

     for c in ( select IB.PROBLSALUD probsalud, IB.RAMA rama, IB.FAMRAMA famrama, IB.COD_FAMILIA cod_familia, IB.PRESTACION prestacion from SIS.INPUTBUFFER ib order by IB.ID )
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
            --Si es auge, se debe quitar la prestación tantas veces como problsalud con la misma glosa existan
            if(auge) then
                QuitarPrestacionAuge(c.probsalud, c.rama, c.famrama, c.cod_familia, c.prestacion);
            else
                QuitarPrestacionNoAuge(c.probsalud, c.rama, c.famrama, c.prestacion);
            end if;
        end loop;

        /* Resetear secuencias involucradas en la transacción */
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_PROBLSALUD','SIS_SEQ_PROBLSALUD');
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_RAMA','SIS_SEQ_RAMA');
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_FAMRAMA','SIS_SEQ_FAMRAMA');
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_PRESTACION','SIS_SEQ_PRESTACION');
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_FAMRAMAPRES','SIS_SEQ_FAMRAMAPRES');

        if(upper(p_auge)='AUGE') then
            /* Resetear secuencias involucradas en la transacción */
            SIS_PCK_HELPER.RESETSEQ('NCAT.NCAT_TAB_FAMILIA','NCAT.NCAT_SEQ_FAMILIA_AUGE');
        end if;

        -- Vaciar la tabla inputbuffer
        delete from sis.inputbuffer;

        SIS_PCK_PRESTACION.v_dsc_log:='Info: Proceso terminado con éxito.';
        Sis.Sis_Pro_Log (v_nomproc, 1, 0, 'OK', SIS_PCK_PRESTACION.v_dsc_log, SIS_PCK_PRESTACION.out_error);

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
            v_dsc_log := 'Error';
            v_codlog  := 1;
            Sis.Sis_Pro_Log (SIS_PCK_PRESTACION.v_nomproc, SIS_PCK_PRESTACION.V_CODLOG, SQLCODE, SQLERRM,  SIS_PCK_PRESTACION.v_dsc_log, SIS_PCK_PRESTACION.out_error);
END;

  PROCEDURE AgregarPrestacionNoAuge(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_pres in varchar2)
  IS
    rama_inexistente exception;
    begin

    -- Si es caso auge, se debe obtener la pk del probsalud desde el ambito global

    v_pk_probsalud:=Existe('probsalud',dsc_probsalud);

    if(v_pk_probsalud is null) then
        /*  TODO: Si no existe el probsalud, crear el nuevo probsalud */
        select SIS_SEQ_PROBLSALUD.nextval into v_pk_probsalud from dual;

        insert into sis_tab_problsalud (problsalud_cod_problsalud, entregistro_fec_fecha, entregistro_fec_hora, entregistro_cod_usuario, entregistro_fec_ingreso, problsalud_dsc_datos, boo_cod_garantizado,
                                                    problsalud_dsc_nombre, problsalud_cod_ordennom, boo_cod_casosinrama, boo_cod_casomanual, boo_cod_especial, problsalud_fec_vige, relaps_cod_relaps, decreto_cod_decreto,
                                                    problsalud_fec_adesplegar)
        values (v_pk_probsalud, fecha, fecha, 1, fecha, dsc_probsalud, 2, dsc_probsalud, 99.4, 2, 2, 2, fecha, 1, 2, fecha);
    end if;

    v_pk_rama:=Existe('rama',dsc_rama);

    if(v_pk_rama is null) then
        select SIS_SEQ_RAMA.nextval into v_pk_rama from dual;
        insert into sis_tab_rama (rama_cod_rama, rama_dsc_rama, problsalud_cod_problsalud, rama_fec_vige, boo_cod_raiz)
        values (v_pk_rama, dsc_rama, v_pk_probsalud, fecha, 1);
    end if;

    -- Si no es auge se busca la famrama por glosa
    v_pk_famrama:=Existe('famrama',dsc_famrama);

    if(v_pk_famrama is null) then
        /* Si no existe la famrama o no está vigente, crear la nueva famrama */
        select SIS_SEQ_FAMRAMA.nextval into v_pk_famrama from dual;
        insert into sis_tab_famrama (famrama_cod_famrama, rama_cod_rama, famrama_fec_vige, famrama_fec_vcto, famrama_dsc_famrama)
        values (v_pk_famrama, v_pk_rama, fecha, null, dsc_famrama);
    end if;

   /* Replicar la famrama en la tabla familia del usuario NCAT */
     v_pk_familia:=Existe('familia',v_pk_famrama);

    if(v_pk_familia is null) then
        /* Si no existe la familia o no está vigente, crear la nueva familia */
        insert into NCAT.NCAT_TAB_FAMILIA(familia_cod_familia, docu_cod_docu, familia_dsc_familia)
        values (v_pk_famrama, cod_docu, dsc_famrama);
    end if;

    v_pk_pres:=Existe('prestacion',cod_pres);

    if(v_pk_pres is null) then
        /* Si no existe la prestacion, crear la nueva prestacion */
        select SIS_SEQ_PRESTACION.nextval into v_pk_pres from dual;
        insert into sis_tab_prestacion(prestacion_cod_prestacion, referencia_cod_referencia, prestacion_dsc_codusua, prestacion_dsc_prestacion, prestacion_fec_vige, prestacion_num_arancel)
        values (v_pk_pres, null, cod_pres, dsc_famrama, fecha, null);
    end if;

    v_pk_famramapres:=Existe('famramapres',v_pk_famrama,v_pk_pres);

    /*Para esta famrama y esta prestación, chequear si existe una famramapres */

    if(v_pk_famramapres is null) then
        /* Si no existe la famramapres, crear una nueva famramapres con las pk de famrama y prestacion obtenidas */
        insert into sis_tab_famramapres (famramapres_cod_famramapres,famrama_cod_famrama, prestacion_cod_prestacion, famramapres_fec_vige, famramapres_fec_vcto, famramapres_cod_migracion, famramapres_fecha_migracion)
        values (SIS_SEQ_FAMRAMAPRES.nextval, v_pk_famrama, v_pk_pres, fecha, null, null, null);
    else
        v_dsc_log:='Warning: Ya existe una famramapres para la famrama de glosa: '||dsc_famrama||' con v_pk_famrama='||v_pk_famrama||' y prestación de código: '||cod_pres||' con v_pk_pres='||v_pk_pres||' no se inserta';
        Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log,out_error);
    end if;

    exception
        when others then
            v_codora  := SQLCODE;
            v_msgora  := SQLERRM;
            v_codlog  := 1;
            v_dsc_log := 'Excepción inesperada';
            raise;
end;

PROCEDURE AgregarPrestacionAuge(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_familia in number,
  cod_pres in varchar2)
  IS
    rama_inexistente exception;
    famrama_inexistente exception;
    familia_inexistente exception;
    familia_inconsistente exception;

    begin

    -- Si es caso auge, se debe obtener la pk del probsalud desde el ambito global

    v_pk_probsalud:=Existe('probsalud',dsc_probsalud);

    if(v_pk_probsalud is null) then
        /*  TODO: Si no existe el probsalud, crear el nuevo probsalud */
        select SIS_SEQ_PROBLSALUD.nextval into v_pk_probsalud from dual;

        insert into sis_tab_problsalud (problsalud_cod_problsalud, entregistro_fec_fecha, entregistro_fec_hora, entregistro_cod_usuario, entregistro_fec_ingreso, problsalud_dsc_datos, boo_cod_garantizado,
                                                    problsalud_dsc_nombre, problsalud_cod_ordennom, boo_cod_casosinrama, boo_cod_casomanual, boo_cod_especial, problsalud_fec_vige, relaps_cod_relaps, decreto_cod_decreto,
                                                    problsalud_fec_adesplegar)
        values (v_pk_probsalud, fecha, fecha, 1, fecha, dsc_probsalud, 2, dsc_probsalud, 99.4, 2, 2, 2, fecha, 1, 2, fecha);
    end if;

   /* buscar la familia en la tabla familia del usuario NCAT, usando como clave el cod_familia */
     v_pk_familia:=Existe('familia', cod_familia);

     --dbms_output.PUT_LINE('v_pk_familia='||v_pk_familia);

    /* Si no existe la familia, levantamos la excepción */
    if(v_pk_familia is null) then
        --dbms_output.PUT_LINE('voy a agregar familia');
        select ncat.ncat_seq_familia_auge.nextval into v_pk_familia from dual;
        /* Si no existe la familia, crear la nueva familia */
        insert into NCAT.NCAT_TAB_FAMILIA(familia_cod_familia, docu_cod_docu, familia_dsc_familia)
        values (v_pk_familia, cod_docu, dsc_famrama);
    else
        -- Si existe una familia para el cod_familia dado, chequear que las glosas coincidan. Si no coinciden, levantar la excepciòn
        if not(GetGlosa('familia',v_pk_familia)=trim(dsc_famrama)) then
            raise familia_inconsistente;
        end if;
    end if;

    v_pk_pres:=Existe('prestacion',cod_pres);

    if(v_pk_pres is null) then
        dbms_output.PUT_LINE('voy a agregar prestacion con cod_pres='||cod_pres);
        /* Si no existe la prestacion, crear la nueva prestacion */
        select SIS_SEQ_PRESTACION.nextval into v_pk_pres from dual;
        insert into sis_tab_prestacion(prestacion_cod_prestacion, referencia_cod_referencia, prestacion_dsc_codusua, prestacion_dsc_prestacion, prestacion_fec_vige, prestacion_num_arancel)
        values (v_pk_pres, null, cod_pres, dsc_famrama, fecha, null);
    end if;

    exception
        when rama_inexistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'rama inexistente para familia de pk '||cod_familia;
            raise;
        when famrama_inexistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'famrama inexistente para familia de pk '||cod_familia;
            raise;
        when familia_inexistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'familia inexistente para familia de pk '||cod_familia;
            raise;
        when familia_inconsistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'Existe la familia de pk '||cod_familia||', sin embargo la glosa no coincide, revisar archivo .csv';
            raise;
        when others then
            v_codora  := SQLCODE;
            v_msgora  := SQLERRM;
            v_codlog  := 1;
            v_dsc_log := 'Excepción inesperada';
            raise;
end;

PROCEDURE QuitarPrestacionNoAuge(
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

    union_existente exception;
    valoriza_existente exception;

begin

    /* Chequear que exista un probsalud vigente con la glosa dada  */
    v_pk_probsalud:=Existe('probsalud',dsc_probsalud);

    if(v_pk_probsalud is null) then
        /* Si no existe la rama o no está vigente, levantamos la excepcion */
        raise probsalud_inexistente;
    end if;

    /* Chequear que exista una rama vigente con la glosa dada  */
    v_pk_rama:=Existe('rama',dsc_rama);

    if(v_pk_rama is null) then
        /* Si no existe la rama o no está vigente, levantamos la excepcion */
        raise rama_inexistente;
    end if;

    /* Chequear que exista una famrama vigente con la glosa dada  */
    v_pk_famrama:=Existe('famrama',dsc_famrama);

    if(v_pk_famrama is null) then
        /* Si no existe la famrama o no está vigente, levantamos la excepcion */
        raise famrama_inexistente;
    end if;

    /* Chequear que exista una familia para esta famrama  */
    v_pk_familia:=Existe('familia',v_pk_famrama);

    if(v_pk_familia is null) then
        /* Si no existe la familia o no está vigente, levantamos la excepcion */
        raise familia_inexistente;
    end if;

    /* Chequear que exista una prestacion con el código dado  */
    v_pk_pres:=Existe('prestacion',cod_pres);

    if(v_pk_pres is null) then
        /* Si no existe la prestacion, levantar la excepción */
        raise prestacion_inexistente;
    end if;

    /* Chequear que no exista una union para esta familia y esta prestacion  */
    v_pk_union:=NCAT.NCAT_PCK_UNION.Existe('union_unincpre', v_pk_famrama, v_pk_pres);

    if(v_pk_union is not null) then
        /* Si no existe la prestacion, levantar la excepción */
        raise union_existente;
    end if;

    /* Chequear que no exista una valoriza para esta familia y esta prestacion  */
    v_pk_valoriza:=VAL.VAL_PCK_VALORIZA.Existe2('valoriza',v_pk_famrama, v_pk_pres);

    if(v_pk_valoriza is not null) then
        /* Si no existe la prestacion, levantar la excepción */
        raise valoriza_existente;
    end if;

    /*Si se cumplen las precondiciones, procedemos a eliminar la prestación */

    v_pk_famramapres:= Existe('famramapres',v_pk_famrama,v_pk_pres);

    if(v_pk_famramapres is null) then
        v_dsc_log:='Warning: No existe la famramapres asociada a la famrma de glosa '||dsc_famrama||' y a la prestación de código '||cod_pres||', no hay registro a eliminar';
        Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log,out_error);
    else
    /* 1o eliminamos la famramapres que fue solicitada en la planilla */
        delete from sis_tab_famramapres famramapres
        where FAMRAMAPRES.FAMRAMAPRES_COD_FAMRAMAPRES=v_pk_famramapres;
    end if;

    /* Luego hacemos un cruce entre famrama y famramapres con la famrama especificada en la planilla,
    si este cruce da vacío, entonces eliminamos la famrama */

    v_pk_famramapres:=Existe('famrama_famramapres',dsc_famrama);

    if(v_pk_famramapres is null) then
        /* Si el cruce es vacío, procedemos a eliminar la ultima famrama ingresada */
        delete from sis_tab_famrama famrama
        where FAMRAMA.FAMRAMA_COD_FAMRAMA=v_pk_famrama;

        /* Además, por consistencia debemos eliminar la familia correspondiente a la famrama */
        delete from NCAT.NCAT_TAB_FAMILIA familia
        where FAMILIA.FAMILIA_COD_FAMILIA=v_pk_famrama;
    end if;

    v_pk_famramapres:=Existe('prestacion_famramapres',cod_pres);

    /* Luego hacemos un cruce entre prestacion y famramapres con la prestación especificada en la planilla,
    si este cruce da vacío, entonces eliminamos la prestación */

    if(v_pk_famramapres is null) then
        /* Si el cruce es vacío, procedemos a eliminar la famrama */
        delete from sis_tab_prestacion prestacion
        where PRESTACION.PRESTACION_COD_PRESTACION=v_pk_pres;
    end if;

    v_pk_famrama:=Existe('rama_famrama',dsc_rama);

    /* Luego hacemos un cruce entre famrama y rama con la pk de la rama obtenida,
    si este cruce da vacío, entonces eliminamos la rama */

    if(v_pk_famrama is null) then
        /* Si el cruce es vacío, procedemos a eliminar la rama */
        delete from sis_tab_rama rama
        where RAMA.RAMA_COD_RAMA=v_pk_rama;
    end if;

    v_pk_rama:=Existe('probsalud_rama',dsc_probsalud);

    /* Por ultimo, hacemos un cruce entre rama y probsalud con la pk del probsalud obtenida,
    si este cruce da vacío, entonces eliminamos el probsalud */

    if(v_pk_rama is null) then
        /* Si el cruce es vacío, procedemos a eliminar el probsalud */
        delete from sis_tab_problsalud probsalud
        where PROBSALUD.PROBLSALUD_COD_PROBLSALUD=v_pk_probsalud;
    end if;

    exception
        when probsalud_inexistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'probsalud inexistente para glosa '||dsc_probsalud;
            raise;
        when rama_inexistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'rama inexistente para glosa '||dsc_rama;
            raise;
        when famrama_inexistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'famrama inexistente para glosa '||dsc_famrama;
            raise;
        when familia_inexistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'familia inexistente para glosa '||dsc_famrama;
            raise;
        when prestacion_inexistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'prestación inexistente para código '||cod_pres;
            raise;
        when union_existente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'union existente para famrama de glosa '||dsc_famrama||' y prestación de código '||cod_pres||'. union de pk='||v_pk_union;
            raise;
        when valoriza_existente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'valoriza existente para famrama de glosa '||dsc_famrama||' y prestación de código '||cod_pres||'. valoriza de pk='||v_pk_valoriza;
            raise;
        when others then
            v_codora  := SQLCODE;
            v_msgora  := SQLERRM;
            v_codlog  := 1;
            v_dsc_log := 'Excepción inesperada';
            raise;
end;


PROCEDURE QuitarPrestacionAuge(
  dsc_probsalud in varchar2,
  dsc_rama in varchar2,
  dsc_famrama in varchar2,
  cod_familia in number,
  cod_pres in varchar2)
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

    union_existente exception;
    valoriza_existente exception;
begin

    /* Chequear que exista un probsalud vigente con la glosa dada  */
    v_pk_probsalud:=Existe('probsalud',dsc_probsalud);

    if(v_pk_probsalud is null) then
        /* Si no existe el probsalud o no está vigente, levantamos la excepcion */
        raise probsalud_inexistente;
    end if;

    /* Chequear que exista una familia con la glosa dada  */
    v_pk_familia:=Existe('familia',dsc_famrama);

    if(v_pk_familia is null) then
        /* Si no existe la familia o no está vigente, levantamos la excepcion */
        raise familia_inexistente;
    end if;

    /* Chequear que exista una prestacion con el código dado  */
    v_pk_pres:=Existe('prestacion',cod_pres);

    if(v_pk_pres is null) then
        /* Si no existe la prestacion, levantar la excepción */
        raise prestacion_inexistente;
    end if;

    /* Chequear que no exista una union para esta familia y esta prestacion  */
    v_pk_union:=NCAT.NCAT_PCK_UNION.Existe('union_unincpre', v_pk_familia, v_pk_pres);

    if(v_pk_union is not null) then
        /* Si no existe la prestacion, levantar la excepción */
        raise union_existente;
    end if;

    /* Chequear que no exista una valoriza para esta familia y esta prestacion  */
    v_pk_valoriza:=VAL.VAL_PCK_VALORIZA.Existe2('valoriza',v_pk_familia, v_pk_pres);

    if(v_pk_valoriza is not null) then
        /* Si no existe la prestacion, levantar la excepción */
        raise valoriza_existente;
    end if;

    /*Si se cumplen las precondiciones, procedemos a eliminar la familia y la prestación */

    -- Si el cod_familia especificado es nulo, eliminar la familia
    if(cod_familia is null) then
        /* eliminar la familia */
        delete from NCAT.NCAT_TAB_FAMILIA familia
        where FAMILIA.FAMILIA_COD_FAMILIA=v_pk_familia;
    end if;

    v_pk_famramapres:=Existe('prestacion_famramapres',cod_pres);

    /* Luego hacemos un cruce entre prestacion y famramapres con la prestación especificada en la planilla,
    si este cruce da vacío, entonces eliminamos la prestación */

    if(v_pk_famramapres is null) then
        /* Si el cruce es vacío, procedemos a eliminar la famrama */
        delete from sis_tab_prestacion prestacion
        where PRESTACION.PRESTACION_COD_PRESTACION=v_pk_pres;
    end if;

    exception
        when familia_inexistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'familia inexistente para glosa '||dsc_famrama;
            raise;
        when prestacion_inexistente then
            v_codora  := 0;
            v_msgora  := 'Excepción';
            v_codlog  := 1;
            v_dsc_log := 'prestación inexistente para código '||cod_pres;
            raise;
        when others then
            v_codora  := SQLCODE;
            v_msgora  := SQLERRM;
            v_codlog  := 1;
            v_dsc_log := 'Excepción inesperada';
            raise;
end;


END SIS_PCK_PRESTACION; 
/

