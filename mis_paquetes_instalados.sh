#!/bin/bash

#Este script genera una sola linea con el listado
# de todos los paquetes debs instalados en el sistema,
# y lo guarda en un ficheros llamado "paquetes.txt" en
# la misma ruta donde se ejecuto el script

dpkg-query -W -f='${Package} ${Status}\n' | gawk -v ORS=' ' 'BEGIN {print "apt-get install"} /\<instal/ {print $1}' > paquetes.txt


