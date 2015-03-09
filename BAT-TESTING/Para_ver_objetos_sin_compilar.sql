select *
from dba_objects b
where b.status = 'INVALID'
and b.object_type in ('PROCEDURE','PACKAGE BODY','FUNCTION','SEQUENCE','TRIGGER','VIEW')
