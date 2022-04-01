#!/bin/bash
if [ euid -eq 0 ] # se esta corriendo con sudo o directamente en root
then
	
	if [ $# -gt 2 ]
	then
		echo "Número incorrecto de parametros"
	else
		if [ $1 -eq "s" ]    #borrar
		then
			mkdir /extra/backup
			grep -a "," $2
			if [ $? -eq 0 ] # Formato de fichero 3 campos
			then
				for j in [ read -d "\n" "$2" ] # separamos la linea 
				do
					campo = $(cut -d "," j)
					for i in [ read -d ":"|"\n" /etc/passwd ]
					do
						if [  campo -eq i ]  # compruebo si el usuario existe
						then
							#REALIZAR BACKUP
							userdel -r i 		
					done
				done
			else
				for j in  $(read -d "n" "$2") 
				do
					for i in $( read -d ":"|"\n" /etc/passwd)
					do
						if [ j -eq i ]
						then
							#REALIZAR BACKUP
							userdel -r i
					done
				done	
			fi
		else if [ $1 -eq "a" ]
		then
			# BUCLE MIRAR SI HAY 2 COMAS Y SI NO HAY CADENAS VACIAS
			for i in  $(read -d "\n" "$2)
			do
				numComas = $(wc -m "," i )	
				if [ numComas -eq 2 ]
				then
					var1= $(cat "$2" |cut -d "," -f 1)
					var2 = $(cat "$2" | cut -d "," -f 2)
					var3 = $(cat "$2" | cut -d "," -f 3)
					if [ "$var1" | "$var2" | "$var3"]#formato invalido	
					then
						echo "Campo invalido"
						exit 1 
					else
						existe=0
						grep &var1 /etc/passwd #Comprobamos si exsite usaurio
							if [$? -eq 0]
							then
								existe=1
							fi
						done
						if [ existe -eq 0 ]
						then
							let aleatorio = $RANDOM%1815+1815
							useradd -d /etc/skel -U -u aleatorio $var1 	
							usermod -e `date -d "30 days" + "%Y-%m-%d"` $var1
							if [ $? -eq 0 ]
							then
								chpasswd var1:var2
								echo "$var3 ha sido creado"

					else # Si el formato no es el debido abortamos 
						echo "Campo invalido"
						exit 1
					fi	
else
	echo "Este script necesita privilegios de administracion"
	exit 1
fi
