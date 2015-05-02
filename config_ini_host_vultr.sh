#!/bin/bash

echo "Actualizando Debian 8"
apt-get update && apt-get upgrade

cd $HOME

echo "Instalando paquetes necesarios"
apt-get install git git-core gawk auto-complete bash-completion rxvt-unicode-256color vim-nox pkg-config

echo "Clonando Mi espacio de trabajo...."
git clone https://github.com/emoronayuso/My-workspace.git && cd My-workspace/ && cp .bash_aliases .. && cp .bashrc .. && cp .vimrc .. && cp .bash_profile ..

echo "Es necesario reiniciar sesion para que los cambios tengan efecto"

