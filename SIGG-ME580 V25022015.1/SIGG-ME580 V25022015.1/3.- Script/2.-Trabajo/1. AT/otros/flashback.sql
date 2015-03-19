ALTER TABLE sis.sis_tab_famramapres ENABLE ROW MOVEMENT;
flashback table sis.sis_tab_famramapres to TIMESTAMP (SYSTIMESTAMP - INTERVAL '40' minute);

ALTER TABLE sis.sis_tab_prestacion ENABLE ROW MOVEMENT;
flashback table sis.sis_tab_prestacion to TIMESTAMP (SYSTIMESTAMP - INTERVAL '40' minute);

ALTER TABLE sis.sis_tab_famrama ENABLE ROW MOVEMENT;
flashback table sis.sis_tab_famrama to TIMESTAMP (SYSTIMESTAMP - INTERVAL '40' minute);

ALTER TABLE ncat.ncat_tab_familia ENABLE ROW MOVEMENT;
flashback table ncat.ncat_tab_familia to TIMESTAMP (SYSTIMESTAMP - INTERVAL '40' minute);

ALTER TABLE sis.sis_tab_rama ENABLE ROW MOVEMENT;
flashback table sis.sis_tab_rama to TIMESTAMP (SYSTIMESTAMP - INTERVAL '40' minute);

ALTER TABLE sis.sis_tab_problsalud ENABLE ROW MOVEMENT;
flashback table sis.sis_tab_problsalud to TIMESTAMP (SYSTIMESTAMP - INTERVAL '40' minute);