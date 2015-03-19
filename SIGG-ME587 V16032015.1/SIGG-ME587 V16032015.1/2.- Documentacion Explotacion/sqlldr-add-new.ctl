load data
 infile 'params.csv'
 into table sis.inputbuffer
 fields terminated by ";" 
 TRAILING NULLCOLS
(ID,
 PROBLSALUD, 
 DSC_GO,
 EXCLUYENTES,
 ESPECIALIDADES
 )