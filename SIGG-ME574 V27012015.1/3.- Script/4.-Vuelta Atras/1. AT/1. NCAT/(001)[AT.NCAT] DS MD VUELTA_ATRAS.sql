INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(001)[AT.NCAT] DS MD VUELTA_ATRAS.sql', 
 'VUELTA ATRAS',  
  SYSDATE, 
  'SIGG-ME574'); 
 -----------------------------------------------
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='PROLAPSO UTERINO  (MAYORES Y MENORES DE 65 AÑOS)' WHERE  familia_cod_familia=469;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='CIERRE PERCUTANEO DE DEFECTOS CEPTALES INTRACARDIACOS CON DISPOSITIVO MAYOR DE 15 AÑOS' WHERE  familia_cod_familia=537;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='TRASTORNOS SEVEROS DEL NEUROPSICODESARROLLO' WHERE  familia_cod_familia=601;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='DEPRESION UNIPOLAR Y DISTIMIA, TRAT. AMBULATORIO NIVEL ESPECIALIZADO, MENORES DE 15 AÑOS' WHERE  familia_cod_familia=805;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='TRASTORNOS DE ANSIEDAD Y DEL COMPORTAMIENTO, TRAT. AMBULATORIO NIVEL ESPECIALIZADO ' WHERE  familia_cod_familia=807;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='TRASTORNOS DEL COMPORTAMIENTO Y EMOCIONALES DE LA INFANCIA Y ADOLESCENCIA, TRAT. AMBULATORIO NIVEL ESPECIALIZADO' WHERE  familia_cod_familia=811;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='PROGRAMA  PRAIS, TRATAMIENTO INTEGRAL ESPECIALIZADO EN SM' WHERE  familia_cod_familia=815;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='DIA RESIDENCIA PROTEGIDA FORENSE ADULTOS' WHERE  familia_cod_familia=829;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='DIA  RESIDENCIA PROTEGIDA FORENSE MENORES' WHERE  familia_cod_familia=830;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='DIA RESIDENCIA PROTEGIDA' WHERE  familia_cod_familia=846;
UPDATE ncat.ncat_tab_familia set familia_dsc_familia='MANTENCION DONANTE CADAVER (PULMON, CORAZON E HIGADO) (MUERTE CEREBRAL)' WHERE  familia_cod_familia=907;
commit;