load data
 infile 'params.csv'
 replace
 into table sis.inputbuffer
 fields terminated by ";" 
 TRAILING NULLCOLS
(ID,
 COD_PS_GEN,
 COD_PS,
 COD_PS_AUX,
 PROBLSALUD "substr(regexp_replace(:PROBLSALUD,'\\;',','), 1, 60)", 
 COD_RAMA,
 FAMRAMA "substr(regexp_replace(:FAMRAMA,'\\;',','), 1, 150)", 
 COD_FAMILIA,
 PRESTACION, 
 ARANCEL
 )