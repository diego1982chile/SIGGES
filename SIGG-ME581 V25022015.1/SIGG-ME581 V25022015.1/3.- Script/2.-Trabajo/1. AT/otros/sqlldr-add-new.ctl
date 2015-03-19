load data
 infile 'params.csv'
 into table inputbuffer
 fields terminated by ";" 
 TRAILING NULLCOLS
(ID,
 PROBLSALUD, 
 RAMA, 
 FAMRAMA, 
 COD_FAMILIA,
 PRESTACION, 
 ARANCEL)