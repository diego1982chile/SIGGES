INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(010) [AT.SIS] DS MD SIS_PCK_EVEGAROPAT.pkb', 
 'Creación de definición de package SIS_PCK_EVEGAROPAT',  
  SYSDATE, 
  'SIGG-ME587'); 
  
---------------------------------------------------------------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY SIS.SIS_PCK_EVEGAROPAT AS
/******************************************************************************
   NAME:       SIS_PCK_EVEGAROPAT
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        16-03-2015             1. Created this package.
******************************************************************************/   

 FUNCTION ExistePara(  
  clave1 in varchar2,
  clave2 in date  
  ) RETURN number IS
  v_pk number(12):=null;
  BEGIN

    /* Seleccionar la rama más reciente según vigencia, usando como clave de búsqueda la glosa dada */
     for c1 in ( select p.PARA_COD_PARA pk from sis.sis_tab_para p
                 where p.PARA_DSC_NOMBRE=clave1
                 and p.PARA_FEC_VIGE=clave2 )
     loop
            v_pk := c1.pk;
            exit; -- only care about one record, so exit.
      end loop; 

    return v_pk;
  END;

 FUNCTION ExisteEvegaropat(  
  clave1 in number,
  clave2 in number,
  clave3 in number,
  clave4 in number,
  clave5 in date
  ) RETURN number IS
  v_pk number(12):=null;
  BEGIN

    /* Seleccionar la rama más reciente según vigencia, usando como clave de búsqueda la glosa dada */
     for c1 in ( select egp.EVEGAROPAT_COD_EVEGAROPAT pk from sis.sis_tab_evegaropat egp
                 where egp.GAROPORPAT_COD_GAROPORPAT=clave1
                 and egp.TIPEVEGAROPAT_COD_TIPEVEGAROPA=clave2
                 and egp.EVETRA_COD_EVETRA=clave3
                 and egp.DOCU_COD_DOCU=clave4
                 and egp.EVEGAROPAT_FEC_VIGE=clave5 )
     loop
            v_pk := c1.pk;
            exit; -- only care about one record, so exit.
      end loop; 

    return v_pk;
  END;

  PROCEDURE ParametrizarEventos IS
    dia number(2):=1;
    mes number(2):=1;
    anyo number(5):=EXTRACT(YEAR FROM sysdate);        

    probsalud_nulo exception;
    go_nulo exception;
    prestacion_nulo exception;
    especialidad_nulo exception;
    cruce_vacio exception;

    v_data number(12);
    vacio boolean;
    
    dsc_probsalud varchar2(100);
    dsc_go varchar2(100);
    --fecha date;
    BEGIN
        v_dsc_log:='Info: Iniciando proceso';
        v_nomproc:='ParametrizarEventos';
                                    
        Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log, out_error);        
        
        fecha:=TO_DATE(dia||'/'||mes||'/'||anyo,'DD/MM/RRRR');

        --Chequear que la tabla inputbuffer tenga data
        SELECT 1 into v_data  FROM sis.inputbuffer WHERE ROWNUM=1;

       -- Resetear secuencias involucradas en la transacción
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_PARA','SIS_SEQ_PARA');
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_EVEGAROPAT','SIS_SEQ_EVEGAROPAT');      
        --SIS_PCK_HELPER.RESETSEQ('SIS_TAB_EVEGAROPAR','SIS_SEQ_EVEGAROPAR');                  
        SIS_PCK_HELPER.RESETSEQ('SIS_TAB_ALERTACITFUEPO','SIS_SEQ_ALERTACITFUEPO');  

         for c in ( select IB.PROBLSALUD probsalud, IB.DSC_GO go, IB.EXCLUYENTES cods_pres, ib.ESPECIALIDADES cods_espe 
                    from SIS.INPUTBUFFER ib order by IB.ID )
         
            loop
            
                vacio:=true;    
                dsc_probsalud:=c.probsalud;
                dsc_go:=c.go;
            
                if(c.probsalud is null) then
                    raise probsalud_nulo;
                end if;               
                
                if(c.go is null) then
                    raise go_nulo;
                end if;                
                
                if(c.cods_pres is null) then
                    raise prestacion_nulo;
                end if;
                
                if(c.cods_espe is null) then
                    raise especialidad_nulo;
                end if;                
 
               for c2 in ( select r.RAMA_COD_RAMA pk_rama, gpp.GAROPORPAT_COD_GAROPORPAT pk_garoporpat from sis.sis_tab_garoporpat gpp 
                          inner join sis.sis_tab_rama r
                          on gpp.RAMA_COD_RAMA=r.RAMA_COD_RAMA
                          inner join sis.sis_tab_problsalud ps
                          on r.PROBLSALUD_COD_PROBLSALUD=ps.PROBLSALUD_COD_PROBLSALUD
                          where convert(upper(trim(ps.PROBLSALUD_DSC_NOMBRE)),'US7ASCII') like '%'||convert(upper(trim(c.probsalud)),'US7ASCII')||'%'
                          and convert(upper(trim(gpp.GAROPORPAT_DSC_GAROPORPAT)),'US7ASCII')=convert(upper(trim(c.go)),'US7ASCII')  )  
                loop         
                    vacio:=false;                    
                    AgregarEventoCaso(c2.pk_rama, c2.pk_garoporpat, c.cods_pres, c.cods_espe);
                end loop;
                         
                if(vacio) then
                   raise cruce_vacio; 
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
                Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            when probsalud_nulo then
                rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'El parámetro "probsalud" es null. Revisar archivo .csv';
                Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            when go_nulo then
                rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'El parámetro "go" es null. Revisar archivo .csv';
                Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);                
            when prestacion_nulo then
                rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'El parámetro "prestacion" es null. Revisar archivo .csv';
                Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            when especialidad_nulo then
                rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'El parámetro "especialidades" es null. Revisar archivo .csv';
                Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);   
            when cruce_vacio then
                rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'Cruce vacio para glosa de probsalud '||dsc_probsalud||' y glosa de go '||dsc_go||'. Revisar archivo .csv';
                Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);                
            when others then
                rollback;
                if(v_dsc_log is null or v_codlog is null) then
                    v_dsc_log := 'Error';
                    v_codlog  := -1;
                end if;
                Sis.Sis_Pro_Log (v_nomproc, V_CODLOG, SQLCODE, SQLERRM, v_dsc_log, out_error);                
    END;
    
    
  PROCEDURE VueltaAtras IS
    dia number(2):=1;
    mes number(2):=1;
    anyo number(5):=EXTRACT(YEAR FROM sysdate);        

    probsalud_nulo exception;
    go_nulo exception;
    prestacion_nulo exception;
    especialidad_nulo exception;
    cruce_vacio exception;

    v_data number(12);
    vacio boolean;
    
    dsc_probsalud varchar2(100);
    dsc_go varchar2(100);
    --fecha date;
    BEGIN
        v_dsc_log:='Info: Iniciando proceso';
        v_nomproc:='VueltaAtrasParametrizarEventos';
                                    
        Sis.Sis_Pro_Log (v_nomproc, 1, 0, '.',  v_dsc_log, out_error);        
        
        fecha:=TO_DATE(dia||'/'||mes||'/'||anyo,'DD/MM/RRRR');

        --Chequear que la tabla inputbuffer tenga data
        SELECT 1 into v_data  FROM sis.inputbuffer WHERE ROWNUM=1;

         for c in ( select IB.PROBLSALUD probsalud, IB.DSC_GO go, IB.EXCLUYENTES cods_pres, ib.ESPECIALIDADES cods_espe 
                    from SIS.INPUTBUFFER ib order by IB.ID )
            loop
            
                vacio:=true;    
                dsc_probsalud:=c.probsalud;
                dsc_go:=c.go;
            
                if(c.probsalud is null) then
                    raise probsalud_nulo;
                end if;
                
                if(c.go is null) then
                    raise go_nulo;
                end if;                
                
                if(c.cods_pres is null) then
                    raise prestacion_nulo;
                end if;
                
                if(c.cods_espe is null) then
                    raise especialidad_nulo;
                end if;                
 
               for c2 in ( select r.RAMA_COD_RAMA pk_rama, gpp.GAROPORPAT_COD_GAROPORPAT pk_garoporpat from sis.sis_tab_garoporpat gpp 
                          inner join sis.sis_tab_rama r
                          on gpp.RAMA_COD_RAMA=r.RAMA_COD_RAMA
                          inner join sis.sis_tab_problsalud ps
                          on r.PROBLSALUD_COD_PROBLSALUD=ps.PROBLSALUD_COD_PROBLSALUD
                          where convert(upper(trim(ps.PROBLSALUD_DSC_NOMBRE)),'US7ASCII') like '%'||convert(upper(trim(c.probsalud)),'US7ASCII')||'%'
                          and convert(upper(trim(gpp.GAROPORPAT_DSC_GAROPORPAT)),'US7ASCII')=convert(upper(trim(c.go)),'US7ASCII')  )  
                loop         
                    vacio:=false;                    
                    QuitarEventoCaso(c2.pk_rama, c2.pk_garoporpat, c.cods_pres, c.cods_pres);
                end loop;
                         
                if(vacio) then
                   raise cruce_vacio; 
                end if;       
                                   
            end loop;

            -- Vaciar la tabla inputbuffer
            delete from sis.inputbuffer;
            
           -- Resetear secuencias involucradas en la transacción
            SIS_PCK_HELPER.RESETSEQ('SIS_TAB_PARA','SIS_SEQ_PARA');
            SIS_PCK_HELPER.RESETSEQ('SIS_TAB_EVEGAROPAT','SIS_SEQ_EVEGAROPAT');      
            --SIS_PCK_HELPER.RESETSEQ('SIS_TAB_EVEGAROPAR','SIS_SEQ_EVEGAROPAR');                  
            SIS_PCK_HELPER.RESETSEQ('SIS_TAB_ALERTACITFUEPO','SIS_SEQ_ALERTACITFUEPO');  

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
            when go_nulo then
                rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'El parámetro "go" es null. Revisar archivo .csv';
                Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);                
            when prestacion_nulo then
                rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'El parámetro "prestacion" es null. Revisar archivo .csv';
                Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);
            when especialidad_nulo then
                rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'El parámetro "especialidades" es null. Revisar archivo .csv';
                Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);                
            when cruce_vacio then
                rollback;
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1;
                v_dsc_log := 'Cruce vacio para glosa de probsalud '||dsc_probsalud||' y glosa de go '||dsc_go||'. Revisar archivo .csv';
                Sis.Sis_Pro_Log (v_nomproc, v_codlog, v_Codora, v_msgora, v_dsc_log,out_error);                
            when others then
                rollback;
                if(v_dsc_log is null or v_codlog is null) then
                    v_dsc_log := 'Error';
                    v_codlog  := -1;
                end if;
                Sis.Sis_Pro_Log (v_nomproc, V_CODLOG, SQLCODE, SQLERRM, v_dsc_log, out_error);                
    END;    
  
  PROCEDURE AgregarEventoCaso(    
  v_pk_rama in number,
  v_pk_garoporpat in number,
  cods_pres in varchar2,
  cods_espe in varchar2      
  )IS
    v_pk_para number(12);
    v_pk_evegaropat number(12);
    v_pk_evegaropar number(12);
    v_pk_alertacitfuepo number(12);
    v_pk_pres number(12);
    v_pk_espe number(12);
    
    p_cod_docu number(12):=10;
    p_tip_eve number(12):=2;         

    v_nom_para varchar(50):='Fecha Vigencia GO';
    v_cod_camp number(5):=5101;

    v_evegaropat_clo_sql clob;
    v_evegaropat_clo_fecha clob;
    
    p_duenogo number(1):=2;
    especialidades varchar2(250):='';
    
    prestacion_inexistente exception;
    especialidad_inexistente exception;    

    BEGIN
                           
        select sis.sis_seq_evegaropat.nextval into v_pk_evegaropat from dual;
        --select sis.sis_seq_evegaropar.nextval into v_pk_evegaropar from dual;
        
        v_pk_para:=ExistePara(v_nom_para, fecha);
        
        if(v_pk_para is null) then
            select sis.sis_seq_para.nextval into v_pk_para from dual;
            insert into sis.sis_tab_para(para_cod_para, para_dsc_nombre, para_dsc_valor, para_dsc_para, para_fec_vige, para_fec_vcto, tippar_cod_tippar)
            values (v_pk_para, v_nom_para, to_char(fecha,'DD/MM/YYYY'), v_nom_para, fecha, null, 1);
        end if;                           
                          
        -- Parametrizas especialidades  
        for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT2(cods_espe,',')) )            
            loop        
                v_pk_espe:=sis.sis_pck_helper.Existe('especialidad', c.param);
                if(v_pk_espe is not null) then
                    especialidades:=especialidades||v_pk_espe||',';
                else
                    raise especialidad_inexistente;                                                                
                end if;
            end loop; 
            
        especialidades:=substr(especialidades,1,length(especialidades)-1);                                                                                

        v_evegaropat_clo_sql:=to_clob(
       'select   --GO_'||v_pk_evegaropat||'
        NVL(SUM(1),0)
        FROM  sis_tab_docu_10,
        sis_tab_docu_4,
        SIS_TAB_REGESTINSDOC R
        WHERE (sis_tab_docu_10.docu_10_col_5101 = [:5101]) and
        (sis_tab_docu_4.docu_4_col_2076 = sis_tab_docu_10.docu_4_col_2076) AND
        (R.REGESTINSDOC_NUM_VALORPK=SIS_TAB_DOCU_4.DOCU_4_COL_2076 ) AND
        (R.CAMP_COD_CAMP=2076) AND
        (R.TIPESTVIGINSDOC_COD_TIPESTVIGI=1) AND
        (R.TIPESTVALINSDOC_COD_TIPESTVALI IN (1,2)) AND
        (R.REGESTINSDOC_FEC_VCTO IS NULL) AND
        (sis_tab_docu_10.DOCU_10_COL_6024 IN ('||especialidades||'))
        AND EXISTS ( SELECT  1
        FROM sis_tab_alertacitfuepo
        WHERE sis_tab_alertacitfuepo.EVEGAROPAT_COD_EVEGAROPAT = '||v_pk_evegaropat||'
        AND sis_tab_alertacitfuepo.PRESTACION_COD_PRESTACION = sis_tab_docu_10.docu_10_col_5103
        AND SYSDATE BETWEEN sis_tab_alertacitfuepo.ALERTACITFUEPO_FEC_VIGE
        AND NVL(sis_tab_alertacitfuepo.ALERTACITFUEPO_FEC_VCTO,SYSDATE+1))
        AND (SIS_TAB_DOCU_10.docu_10_col_5105 >= to_date(replace(sis_fun_get_parametro('||v_pk_para||'),'''||'/'||''','''||'-'||'''),'''||'dd-mm-rrrr'||''''||'))'                                
        );                                                                

        v_evegaropat_clo_fecha:=to_clob(
       'SELECT --GO_'||v_pk_evegaropat||'
        TO_DATE(TO_CHAR(SIS_TAB_DOCU_10.docu_10_col_5105,'''||'dd/mm/yyyy'||''')||'||''''||' '||''''||'||NVL(SIS_TAB_DOCU_10.docu_10_col_6020,'''||'00:00'||''')||'''||':00'||''''||','''||'dd/mm/yyyy hh24:mi:ss'||''''||'),
        NULL
        FROM  SIS_TAB_DOCU_4,
              SIS_TAB_DOCU_10
        WHERE (SIS_TAB_DOCU_10.DOCU_10_COL_5101 = [:5101]) AND -- PK.
              (SIS_TAB_DOCU_4.DOCU_4_COL_2076 = SIS_TAB_DOCU_10.DOCU_4_COL_2076)'
        );  
                                                
        insert into sis.sis_tab_evegaropat(evegaropat_cod_evegaropat, garoporpat_cod_garoporpat, evegaropat_clo_sql, evetra_cod_evetra, docu_cod_docu, 
                                           evegaropat_fec_vige, evegaropat_fec_vcto, tipevegaropat_cod_tipevegaropa, evegaropat_clo_fecha, evegaropat_cod_inicio,
                                           evegaropat_clo_duenogo, boo_cod_duenogodin, boo_cod_nugosql, boo_cod_nugofecha, boo_cod_nugoduenogo)
        select v_pk_evegaropat, v_pk_garoporpat, v_evegaropat_clo_sql, p_tip_eve, p_cod_docu, fecha, null, p_tip_eve, v_evegaropat_clo_fecha, null, null, 
               p_duenogo, p_duenogo, p_duenogo, p_duenogo from dual
        where not exists ( select egp.TIPEVEGAROPAT_COD_TIPEVEGAROPA, egp.EVETRA_COD_EVETRA, egp.DOCU_COD_DOCU, egp.EVEGAROPAT_FEC_VIGE 
                           from sis.sis_tab_evegaropat egp                     
                           where egp.GAROPORPAT_COD_GAROPORPAT=v_pk_garoporpat
                           and egp.TIPEVEGAROPAT_COD_TIPEVEGAROPA=p_tip_eve
                           and egp.EVETRA_COD_EVETRA=p_tip_eve
                           and egp.DOCU_COD_DOCU=p_cod_docu
                           and egp.EVEGAROPAT_FEC_VIGE=fecha );                                                                                                                                                    
        
        if(sql%rowcount>0) then       
            insert into sis.sis_tab_evegaropar(evegaropar_cod_evegaropar, evegaropat_cod_evegaropat, camp_cod_camp)
            values (v_pk_evegaropat, v_pk_evegaropat, v_cod_camp ); 
                                     
            for c in (select rownum num_param, column_value param from table(SIS.SIS_PCK_HELPER.SPLIT2(cods_pres,',')) )            
                loop        
                    v_pk_pres:=sis.sis_pck_prestacion.Existe('prestacion', c.param);
                    if(v_pk_pres is not null) then
                        select sis.sis_seq_alertacitfuepo.nextval into v_pk_alertacitfuepo from dual;
                        insert into sis.sis_tab_alertacitfuepo(alertacitfuepo_cod_alertacitfu, evegaropat_cod_evegaropat, prestacion_cod_prestacion, 
                                                               alertacitfuepo_fec_vige, alertacitfuepo_fec_vcto)
                        values ( v_pk_alertacitfuepo, v_pk_evegaropat, v_pk_pres, fecha, null );     
                    else
                        raise prestacion_inexistente;                                                                
                    end if;
                end loop;       
        end if;            

        exception                                 
            when prestacion_inexistente then
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1002;
                v_dsc_log := 'prestación inexistente para código contenido en '||cods_pres;
                raise;   
            when especialidad_inexistente then
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1018;
                v_dsc_log := 'especialidad inexistente para código contenido en '||cods_espe;
                raise;                       
            when others then
                v_codora  := SQLCODE;
                v_msgora  := SQLERRM;
                v_codlog  := -1;
                v_dsc_log := 'Excepción inesperada';
                raise;                            
    end;
    
  PROCEDURE QuitarEventoCaso(    
  v_pk_rama in number,
  v_pk_garoporpat in number,
  cods_pres in varchar2,
  cods_espe in varchar2  
  ) IS
    v_pk_para number(12);
    v_pk_evegaropat number(12);
    p_cod_docu number(12):=10;
    p_tip_eve number(12):=2;         
    
    evegaropat_inexistente exception;

    BEGIN                           
                                      
        v_pk_evegaropat:=ExisteEvegaropat(v_pk_garoporpat, p_tip_eve, p_tip_eve, p_cod_docu, fecha);
        
        if(v_pk_evegaropat is null) then
            raise evegaropat_inexistente;
        end if;
            
        delete from sis.sis_tab_alertacitfuepo acf where acf.EVEGAROPAT_COD_EVEGAROPAT=v_pk_evegaropat;
        
        delete from sis.sis_tab_evegaropar egp where egp.EVEGAROPAR_COD_EVEGAROPAR=v_pk_evegaropat;
        
        delete from sis.sis_tab_evegaropat egp where egp.EVEGAROPAT_COD_EVEGAROPAT=v_pk_evegaropat;             
                                                                                             
        exception             
            when evegaropat_inexistente then
                v_codora  := 0;
                v_msgora  := 'Excepción';
                v_codlog  := 1002;
                v_dsc_log := 'evegaropat inexistente para garoporpat de codigo '||v_pk_garoporpat||', tipo de evento '||p_tip_eve||', cod_docu '||p_cod_docu||' y fecha '||fecha;
                raise;     
            when others then
                v_codora  := SQLCODE;
                v_msgora  := SQLERRM;
                v_codlog  := -1;
                v_dsc_log := 'Excepción inesperada';
                raise;                                                                 
    end;
                    
END SIS_PCK_evegaropat; 
/

