INSERT INTO sis.SIS_TAB_CONTROL_SCRIPT (RESPONSABLE,

                                        NOMBRE_SCRIPT,
                                        DESCRIPCION,
                                        FECHA_EJECUCION,
                                        NUMERO_OT)
     VALUES ('Diego Soto ',
             '(004)[AT.ENDECA] DS RECREA TABLA OA Y OAPO ENDECA F3.sql',
             'Recrea tablas ENDECA Fase 3',
             SYSDATE,
             'ENDECA FASE 3');
COMMIT;             
--------------------------------------------------------------------------------

----se recrea campo Especialidad de la tabla ENDECA_TAB_OA Y ENDECA_TAB_OAPO

DROP TABLE ENDECA.ENDECA_TAB_OA CASCADE CONSTRAINTS;



CREATE TABLE ENDECA.ENDECA_TAB_OA
(
  CPROCESO_ID_PROCESO  NUMBER(15)               NOT NULL,
  ID_OA                NUMBER(12),
  ID_CASO              NUMBER(12),
  FECHA_OA             DATE,
  HORA_OA              VARCHAR2(6 BYTE),
  COD_ESTABLECIM       NUMBER(12),
  COD_ESPECIALIDAD     VARCHAR2(50 BYTE),
  RUN_PROFESIONAL      NUMBER(8),
  DV_PROFESIONAL       VARCHAR2(1 BYTE),
  FEC_DIGITACION       DATE,
  USUARIO_DIGITA       NUMBER(12),
  UNIDAD_DIGITA        NUMBER(12),
  FOLIO_OA             NUMBER(12)
)
TABLESPACE ENDECA_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;


DROP TABLE ENDECA.ENDECA_TAB_OAPO CASCADE CONSTRAINTS;

CREATE TABLE ENDECA.ENDECA_TAB_OAPO
(
  CPROCESO_ID_PROCESO      NUMBER(15)           NOT NULL,
  ID_OA                    NUMBER(12),
  COD_PRESTACION           NUMBER(12),
  DERIVACION_PO            NUMBER(2),
  ESPECIALIDAD_DESTINO     NUMBER(12),
  EXTRASISTEMA             NUMBER(1),
  PRESTADOR_EXTRASISTEMA   VARCHAR2(256 BYTE),
  ESTABLECIMIENTO_DESTINO  NUMBER(12)
)
TABLESPACE ENDECA_DATA
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;
