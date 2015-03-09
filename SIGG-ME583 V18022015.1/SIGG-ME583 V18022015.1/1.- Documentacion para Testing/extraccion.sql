SELECT
uni.UNION_FEC_vige,
uni.UNION_FEC_VCTO ,
 uni.union_cod_union Unio,
sis_tab_rama.RAMA_COD_rama COD,
               (select ps.PROBLSALUD_DSC_DATOS||' '||rm.RAMA_DSC_RAMA 
                  from sis.sis_tab_problsalud ps, sis.sis_tab_rama rm 
                         where ps.PROBLSALUD_COD_PROBLSALUD = rm.PROBLSALUD_COD_PROBLSALUD 
                           and rm.RAMA_COD_RAMA = sis_tab_rama.RAMA_COD_RAMA) NOMBRE_PROGRAMA, 
                           (select ts.IS_DSC_IS from ncat.ncat_tab_is ts 
                         where ts.IS_COD_IS = unpsra.IS_COD_IS) Tipo_Int_San,
                          (select fm.FAMILIA_COD_FAMILIA from ncat.ncat_tab_familia fm 
                         where fm.FAMILIA_COD_FAMILIA = unpsra.FAMILIA_COD_FAMILIA) Cod_familia,    
                          (select fm.FAMILIA_DSC_FAMILIA from ncat.ncat_tab_familia fm 
                         where fm.FAMILIA_COD_FAMILIA = unpsra.FAMILIA_COD_FAMILIA) familia,      
               prestacion_dsc_codusua Trazadora, 
               PRESTACION_DSC_PRESTACION  Glosa_Trazadora,  
               (Select t.TIPTRAPA_DSC_TIPTRAPA from ncat.ncat_tab_tiptrapa t where t.tiptrapa_cod_tiptrapa=uni.tiptrapa_cod_tiptrapa) Tipo_trazadora,
               (SELECT TIPINTER_DSC_TIPINTER 
                  FROM ncat.ncat_tab_TIPINTER 
                         WHERE TIPINTER_COD_TIPINTER = UNEDAD.TIPINTER_COD_TIPINTER)||' '||UNEDAD_NUM_EDADANO||' '|| 
               decode(unedad.BOO_COD_AND,1,'y',2,'o',' ')||' '||
               (SELECT TIPINTER_DSC_TIPINTER FROM ncat.ncat_tab_TIPINTER 
                         WHERE TIPINTER_COD_TIPINTER = unedad.TIPINTER_COD_TIPINTER_AUX)||' '||unedad.UNEDAD_NUM_EDADANO_AUX edad,
               DECODE(GENERO_COD_GENERO,1,'Femenino',2,'Masculino',' ') sexo, 
               UNFREC_NUM_CANTMAX||' '||DECODE(PERIOD_COD_PERIOD,1,'Dia',2,'Mes',3,'Año',8,'Vida',TO_CHAR(PERIOD_COD_PERIOD)) frec, 
       (ncat.Ncat_Fun_Retorna_Pres_Exclu(uni.union_cod_union)) Excluyentes,
               (select REGDEFISFAM_DSC_REGDEFISFAM from ncat.ncat_tab_REGDEFISFAM where  REGDEFISFAM_COD_REGDEFISFAM = UNPSRA.REGDEFISFAM_COD_REGDEFISFAM) REGDEFISFAM
  FROM ncat.ncat_tab_UNION uni,
               ncat.ncat_tab_unpsra UNPSRA,
               ncat.ncat_tab_unincpre UNINCPRE,
               sis.SIS_TAB_PRESTACION,
               ncat.ncat_tab_unedad UNEDAD,
               ncat.ncat_tab_unsexo UNSEXO,
               ncat.ncat_tab_unfrec UNFREC,
               sis.sis_tab_rama 
 WHERE uni.docu_cod_docu = 15 
   AND uni.UNION_COD_UNION = UNPSRA.UNION_COD_UNION 
   AND uni.UNION_COD_UNION = UNINCPRE.UNION_COD_UNION 
   AND UNINCPRE.prestacion_cod_prestacion = SIS_TAB_PRESTACION.prestacion_cod_prestacion 
   AND UNPSRA.rama_COD_rama = sis_tab_rama.rama_COD_rama 
   AND uni.UNION_COD_UNION = UNEDAD.UNION_COD_UNION(+) 
   AND uni.UNION_COD_UNION = UNSEXO.UNION_COD_UNION(+) 
   AND uni.UNION_COD_UNION = UNFREC.UNION_COD_UNION(+) 
   and uni.UNION_FEC_vige > to_date('01/01/2015','dd/mm/yyyy')
 -- UNI.UNION_FEC_VCTO > to_date('31/12/2012','dd/mm/yyyy')
 ORDER BY 1 ASC, uni.union_cod_union ASC