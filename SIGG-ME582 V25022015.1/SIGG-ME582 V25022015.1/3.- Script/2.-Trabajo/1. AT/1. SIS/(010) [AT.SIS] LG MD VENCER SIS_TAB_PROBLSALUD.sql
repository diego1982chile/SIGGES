INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Luis Gorigoitia', 
 '(010)[AT.SIS] LG MD vencer sis_tab_problsalud.sql', 
 '1. Vencer para registro, con fecha termino 31/12/2014, todos los programas especiales actuales (menos el GES-46 Urgencia Odontológica y Tamizaje Test de Elisa)',  
  SYSDATE, 
  'SIGG-ME578'); 
 -----------------------------------------------

UPDATE sis.sis_tab_problsalud
SET PROBLSALUD_FEC_VCTO='31/12/2014'
where PROBLSALUD_FEC_VCTO IS NULL
 AND PROBLSALUD_COD_PROBLSALUD NOT IN (126,221)
 and BOO_COD_GARANTIZADO=2;

commit;