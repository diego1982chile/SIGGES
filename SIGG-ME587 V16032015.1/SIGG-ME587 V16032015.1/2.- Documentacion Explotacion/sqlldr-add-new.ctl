load data
 infile 'params.csv'
 replace
 into table sis.inputbuffer
 fields terminated by ";" 
 TRAILING NULLCOLS
(ID,
 PROBLSALUD, 
 DSC_GO,
 EXCLUYENTES,
 ESPECIALIDADES
 )