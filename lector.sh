#!/bin/bash

path="/Users/ITESMCCV/Dropbox/ImpresionesBN"					# - - - - - - - > Dirección de la carpeta compartida
TXTExt="txt"

#				- - - - function printFile - - - - 
	# Función diseñada para imprimir y escribir archivos.
	# Recibe dos argumentos:
	# 1) Path y nombre de archivo
	# 2) Matrícula del alumno en cuestión.
	#			-Si existe error en tipografía, igual lo mandará a imprimir pero jamás será liberado.
	# Utiliza el comando lpr, recibiendo la impresora en cuestión configurada y el path + nombre del archivo.
function printFile {
	echo $(lpr -P Blanco_y_Negro $1)
	echo $(cliclick w:1000 t:$2 kp:tab t:$2 kp:return)			# - - - - - - - > Uso de cliclick para enviar comandos. Utiliza el argumento 2 (matrícula)
}

#				- - - - Función central - - - -
	# Ciclo infinito para el daemon.
	# Busca iterativamente en la carpeta especificada si existen archivos.
	# En caso de existir archivos, comprueba la extensión. Si es diferente a .txt, procede a imprimirlo.
	# Para imprimirlo, obtiene el nombre del archivo (el cual debe ser la matrícula) y junta el path con el nombre del archivo.
	# La función printFile recibe el archivo en cuestión con path y la matrícula del alumno, en ese orden. Posteriormente, se elimina el archivo.
	# Se realiza un delay de 15 segundos para dar tiempo a la impresión del archivo. De lo contrario, se vuelve impredecible la cola de impresión.
while [ 1 ]; do 																					# - - - - - - - > Ciclo infinito (daemon mode)
	for filename in $(cd $path && basename -s . *); do # - - - - - - - > Búsqueda iterativa de archivos en la carpeta. Separa el nombre del archivo con basename
		EXT=$(echo $filename | rev | cut -d'.' -f1 | rev)			# - - - - - - - > Separa la extensión del archivo
		if [ $EXT != $TXTExt ]; then 													# - - - - - - - > Si la extensión es txt, la omite. En caso contrario, procede a imprimirlo
			fileToPrint=$path"/"$filename 									# - - - - - - - > Juntamos el nombre del archivo con el path
			matricula=$(basename -s .$EXT $filename) 						# - - - - - - - > Obtenemos la matrícula separando el nombre del archivo.
			echo Archivo a imprimir: $filename 									# - - - - - - - > Señal de impresión
			(printFile $fileToPrint $matricula && rm $fileToPrint) & #- - - - - > Proceso hijo de impresión. Llamada a printfile con los argumentos y después, remoción del archivo.
			sleep 15
		fi
	done
	sleep 1
done