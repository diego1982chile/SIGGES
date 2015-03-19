INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(001) [AT.SIS] DS MD DROP_OBJETOS_BD', 
 'Elimina objetos de BD de esta mantención',  
  SYSDATE, 
  'SIGG-ME578'); 
  
---------------------------------------------------------------------------------------------------------------------------

DECLARE
v_nomproc VARCHAR2(255):='EliminaObjetosBD';
v_codora NUMBER;
v_codlog NUMBER;
v_msgora VARCHAR2(1000);
v_dsc_log  VARCHAR2(1000):='';
out_error number(12):=0;

-- Primero hacer drop de los objetos de BD, y capturar excepción 'not found'

-- User SIS: SIS.inputbuffer, SIS.split_tbl_type, SIS.sis_seq_prestacion, SIS.sis_seq_problsalud, SIS.sis_seq_famrama, SIS.sis_pck_helper, SIS.sis_pck_prestacion
BEGIN	
	EXECUTE IMMEDIATE 'DROP TABLE INPUTBUFFER';
	EXECUTE IMMEDIATE 'DROP TYPE SPLIT_TBL';
	EXECUTE IMMEDIATE 'DROP SEQUENCE SIS.SIS_SEQ_PRESTACION'; 
	EXECUTE IMMEDIATE 'DROP SEQUENCE SIS.SIS_SEQ_FAMRAMA';
	EXECUTE IMMEDIATE 'DROP SEQUENCE SIS.SIS_SEQ_PROBLSALUD';
	EXECUTE IMMEDIATE 'DROP PACKAGE SIS.SIS_PCK_HELPER';
	EXECUTE IMMEDIATE 'DROP PACKAGE SIS.SIS_PCK_PRESTACION';
    
	EXCEPTION
	  WHEN OTHERS THEN		
		IF SQLCODE NOT IN (-942, -2289, -4043) THEN		  
		    v_codora  := SQLCODE;
            v_msgora  := SQLERRM;
            v_codlog  := 1;
            v_dsc_log := 'Excepción inesperada';
			Sis.Sis_Pro_Log (v_nomproc, V_CODLOG, SQLCODE, SQLERRM, v_dsc_log, out_error);
			RAISE;
		END IF;
END;
/