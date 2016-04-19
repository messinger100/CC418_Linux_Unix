#!/bin/bash
#Declaración de variables globales
Directorio=""
Respaldo=""
Nombre="RESPALDO"
Fecha=$(date +%d-%m-%Y)
Formatos=".*\.\(c\|cpp\|c++\|doc\|docx\|xls\|xlsx\|ppt\|pptx\|sh\)"
#Formatos=".*\.\(jamt\|jam\)"
NomComprimido=$Fecha".tar.bz"
NomPractica="d01-p1-martinez-jorge.sh"
Backup="BAK"
#Validación de idiomas
case "${LANG%'_'*}" in
	'es') #Español
		if [ -d '~/Escritorio' ]; then
			mkdir ~/Escritorio/$Nombre
		else
			mkdir ~/Escritorio
			mkdir ~/Escritorio/$Nombre
		fi
		Respaldo=~/Escritorio/$Nombre
		Directorio=~/Escritorio
	;;
	'en') #Inglés
		if [ -d '~/Desktop' ]; then
			mkdir ~/Desktop/$Nombre
		else
			mkdir ~/Desktop
			mkdir ~/Desktop/$Nombre
		fi
		Respaldo=~/Desktop/$Nombre
		Directorio=~/Desktop/
	;;
	*) #Otros idiomas
		if [ -d '~/Desktop' ]; then
			mkdir ~/Desktop/$Nombre
		else
			mkdir ~/Desktop
			mkdir ~/Desktop/$Nombre
		fi
		Respaldo=~/Desktop/$Nombre
		Directorio=~/Desktop/
	;;
esac
find ~/ -type f -iregex $Formatos -not -name $NomPractica -exec cp --backup=t {} $Respaldo \;
cd $Directorio
variable=$IFS
IFS=$(echo -en "\n\b")
listado=(`find $Respaldo`)
#Cambiar nombres, en caso de archivos con el mismo nombre
for i in ${listado[@]}
do
	nomArch=$(echo $i | rev | cut -d"." -f3- | rev)
	fin=$(echo $i | rev | cut -d'.' -f2 | rev)
	contador=$(echo $i | rev | cut -d'.' -f1 | rev | tr '~' '-')
	contador=$(echo ${contador:(-2)} | rev)
	mv $i $nomArch$Backup$contador"."$fin
done
tar -c $Nombre | bzip2 > $NomComprimido
rm -Rf $Respaldo
IFS=$variable
find ~/ -type f -iregex $Formatos -not -name $NomPractica -exec rm -v {} $Respaldo \;
echo "Archivos de: "$NomComprimido && tar -tvf $NomComprimido