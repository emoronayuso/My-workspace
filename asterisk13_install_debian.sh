#!/bin/bash

apt-get update && apt-get upgrade

apt-get install ntp && service ntp restart

apt-get install build-essential wget libssl-dev libncurses5-dev libnewt-dev  libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev libjansson-dev subversion module-init-tools pkg-config bison git git-core vim-nox
#apt-get install build-essential git git-core libncurses5-dev libssl-dev libxml2-dev libsqlite3-dev uuid-dev libjansson-dev libpjsip2 vim-nox wget

cd /usr/src/

##DESCARGAS

#git clone https://github.com/asterisk/asterisk.git
#git clone https://github.com/asterisk/pjproject.git

wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4-current.tar.gz
wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13-current.tar.gz
 
tar zxvf dahdi-linux-complete*
tar zxvf libpri*
tar zxvf asterisk*

#INSTALANDO ASTERISK + DADHI + LIBPRI
cd /usr/src/dahdi-linux-complete*
make && make install && make config
 
cd /usr/src/libpri*
make && make install
 
cd /usr/src/asterisk*
./configure && make menuselect && make && make install && make config && make samples

#Run service asterisk
service asterisk start

