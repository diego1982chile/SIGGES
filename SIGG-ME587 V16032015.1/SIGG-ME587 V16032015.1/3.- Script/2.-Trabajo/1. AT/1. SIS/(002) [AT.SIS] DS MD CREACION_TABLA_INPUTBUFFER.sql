INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT 
(RESPONSABLE, NOMBRE_SCRIPT, DESCRIPCION, FECHA_EJECUCION, NUMERO_OT ) 
VALUES ( 
 'Diego Soto', 
 '(002) [AT.SIS] DS MD CREACION_TABLA_INPUTBUFFER', 
 'Creacion tabla inputbuffer',  
  SYSDATE, 
  'SIGG-ME587'); 
  
---------------------------------------------------------------------------------------------------------------------------
 
 /*
Nombre objeto      :  INPUTBUFFER
Objetivo      :  Tabla de almacenamiento tempral registros procesamiento
Tipo objeto          : tabla
Tipo retorno      :

Creado por          :  Diego Soto
Modificado el      : 25-02-2016 
Observacion      : 
*/

CREATE TABLE INPUTBUFFER                                              
   ( "ID" NUMBER(12,0) NOT NULL PRIMARY KEY,                                         
    "PROBLSALUD" VARCHAR2(60),   
	"COD_PS_GEN" NUMBER(12,0),	
	"COD_PS" NUMBER(12,0),
	"COD_PS_AUX" NUMBER(12,0),
    "RAMA" VARCHAR2(200),   
	"COD_RAMA" NUMBER(12,0),
    "FAMRAMA" VARCHAR2(150),
    "COD_FAMILIA" NUMBER(12,0),                                                               
    "ARANCEL" NUMBER(18,0),                                                        
    "PRESTACION" VARCHAR2(50),                                                     
    "EDAD" VARCHAR2(100),                                                          
    "SEXO" VARCHAR2(10),                                                           
    "FRECUENCIA" VARCHAR2(10),                                                     
    "EXCLUYENTES" VARCHAR2(100),
	"DSC_GO" VARCHAR2(100),
	"ESPECIALIDADES" VARCHAR(100)
	); 
	