INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(001)[AT.NCAT] DS MD NCAT_TAB_FAMILIA.sql', 
 'Se modifican glosa de las familias',  
  SYSDATE, 
  'SIGG-ME574'); 
 -----------------------------------------------
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='PROLAPSO UTERINO' WHERE  familia_cod_familia=469;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='CIERRE PERCUTANEO DE DEFECTOS INTRACARDIACOS CON DISPOSITIVO MAYOR DE 15 AÑOS' WHERE  familia_cod_familia=537;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='TRASTORNOS GRAVES DEL NEUROPSICODESARROLLO' WHERE  familia_cod_familia=601;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='DEPRESION UNIPOLAR Y DISTIMIA, MENORES DE 15 AÑOS, TRATAMIENTO AMBULATORIO NIVEL ESPECIALIZADO (TRATAMIENTO MENSUAL)' WHERE  familia_cod_familia=805;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='TRASTORNOS DE ANSIEDAD Y DEL COMPORTAMIENTO, TRATAMIENTO AMBULATORIO NIVEL ESPECIALIZADO(TRATAMIENTO MENSUAL)' WHERE  familia_cod_familia=807;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='TRASTORNOS DEL COMPORTAMIENTO EMOCIONALES DE LA INFANCIA Y ADOLESCENCIA, TRATAMIENTO NIVEL ESPECIALIZADO (TRATAMIENTO MENSUAL)' WHERE  familia_cod_familia=811;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='PROGRAMA PRAIS, TRATAMIENTO INTEGRAL ESPECIALIZADO EN SALUD MENTAL (TRATAMIENTO MENSUAL)' WHERE  familia_cod_familia=815;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='DIA CAMA RESIDENCIA PROTEGIDA FORENSE ADULTOS*' WHERE  familia_cod_familia=829;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='DIA CAMA RESIDENCIA PROTEGIDA FORENSE MENORES*' WHERE  familia_cod_familia=830;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='DIA CAMA RESIDENCIA PROTEGIDA' WHERE  familia_cod_familia=846;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='MANTENCION DONANTE CADAVER (PULMON, CORAZON O HIGADO)' WHERE  familia_cod_familia=907;
commit;