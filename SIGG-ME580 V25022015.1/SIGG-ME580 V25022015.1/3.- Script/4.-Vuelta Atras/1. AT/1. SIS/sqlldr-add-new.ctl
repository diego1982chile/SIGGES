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
 PROBLSALUD, 
 COD_RAMA,
 FAMRAMA, 
 COD_FAMILIA,
 PRESTACION, 
 ARANCEL
 )