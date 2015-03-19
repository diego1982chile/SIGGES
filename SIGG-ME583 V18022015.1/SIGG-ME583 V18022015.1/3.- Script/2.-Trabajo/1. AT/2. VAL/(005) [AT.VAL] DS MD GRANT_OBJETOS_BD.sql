INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(005) [AT.VAL] DS MD GRANT_OBJETOS_BD', 
 'Grants de objetos de BD de User VAL a Users SIS y NCAT',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------
GRANT ALL ON VAL.VAL_PCK_VALORIZA TO SIS, NCAT;
GRANT ALL ON VAL.VAL_SEQ_VALORIZA TO SIS, NCAT;

GRANT SELECT ON NCAT.NCAT_TAB_UNION TO SIS, VAL;
GRANT SELECT ON NCAT.NCAT_TAB_UNEDAD TO SIS, VAL;
GRANT SELECT ON NCAT.NCAT_TAB_UNSEXO TO SIS, VAL;
GRANT SELECT ON NCAT.NCAT_TAB_UNFREC TO SIS, VAL;
GRANT SELECT ON NCAT.NCAT_TAB_UNEXCPRE TO SIS, VAL;
GRANT SELECT ON NCAT.NCAT_TAB_UNINCPRE TO SIS, VAL;
GRANT SELECT ON NCAT.NCAT_TAB_UNPSRA TO SIS, VAL;
GRANT SELECT ON NCAT.NCAT_TAB_RELAUNRE TO SIS, VAL;

GRANT ALL ON NCAT.NCAT_SEQ_UNION TO SIS, VAL;
GRANT ALL ON NCAT.NCAT_SEQ_UNEDAD TO SIS, VAL;
GRANT ALL ON NCAT.NCAT_SEQ_UNSEXO TO SIS, VAL;
GRANT ALL ON NCAT.NCAT_SEQ_UNFREC TO SIS, VAL;
GRANT ALL ON NCAT.NCAT_SEQ_UNEXCPRE TO SIS, VAL;
GRANT ALL ON NCAT.NCAT_SEQ_UNINCPRE TO SIS, VAL;
GRANT ALL ON NCAT.NCAT_SEQ_UNPSRA TO SIS, VAL;
GRANT ALL ON NCAT.NCAT_SEQ_RELAUNRE TO SIS, VAL;

/