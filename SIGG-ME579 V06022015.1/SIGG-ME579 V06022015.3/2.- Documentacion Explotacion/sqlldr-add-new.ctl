load data
 infile 'params.csv'
 into table sis.inputbuffer
 fields terminated by ";" 
 TRAILING NULLCOLS
(ID,
 PROBLSALUD, 
 RAMA, 
 FAMRAMA, 
 PRESTACION, 
 ARANCEL,  
 EDAD, 
 SEXO, 
 FRECUENCIA, 
 EXCLUYENTES)