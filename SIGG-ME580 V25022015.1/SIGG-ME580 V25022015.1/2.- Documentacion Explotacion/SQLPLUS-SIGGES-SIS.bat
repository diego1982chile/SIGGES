set dia=%date:~0,2%
set mes=%date:~3,2%
set a�o=%date:~-4%
set hora=%time:~0,2%
set min=%time:~3,2%
set fecha=%date:~-4%%date:~3,2%%date:~0,2%
set horario=%time:~0,2%%time:~3,2%
set usuario=SIS
set password=SIS_at
set conn=ATCERTI-133

sqlldr %usuario%/%password%@%conn% control=sqlldr-add-new.ctl > Log_Ejecuta_%conn%_%Usuario%_%fecha%_%horario%.log
REM sqlplus %usuario%/%password%@%conn% @ejecuta.sql > Log_Ejecuta_%conn%_%Usuario%_%fecha%_%horario%.log	

exit;