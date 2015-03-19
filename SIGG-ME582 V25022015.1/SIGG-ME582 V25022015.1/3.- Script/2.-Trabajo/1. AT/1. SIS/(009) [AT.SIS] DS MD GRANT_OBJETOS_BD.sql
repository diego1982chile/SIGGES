INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(009) [AT.SIS] DS MD GRANT_OBJETOS_BD', 
 'Grants de objetos de BD de User SIS a Users VAL y NCAT',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------

GRANT SELECT ON sis.sis_tab_problsalud TO val, ncat;
GRANT SELECT ON sis.sis_tab_rama TO val, ncat;
GRANT SELECT ON sis.sis_tab_famrama TO val, ncat;
GRANT SELECT ON sis.sis_tab_prestacion TO val, ncat;  
GRANT SELECT ON sis.sis_tab_famramapres TO val, ncat; 

GRANT all ON sis.sis_pck_prestacion to val, ncat;
GRANT all ON sis.sis_pck_helper to val, ncat;
GRANT all ON SIS.SIS_PRO_LOG to val, ncat;

GRANT INSERT,SELECT,DELETE ON sis.inputbuffer TO val, ncat; 
/