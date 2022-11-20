#!/bin/bash

#colors!!!!

BLUE='\033[0;36m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

#check for root permisions
if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

echo "host: $(uname -r)"

printf "${BLUE}[*]${NC} handling dependancies\n"

#qemu userland emulator
PACKAGE="qemu-user"
printf "${BLUE}[*] checking for: ${PURPLE}$PACKAGE${NC}\n"

if [ $(dpkg-query -W -f='${Status}' $PACKAGE 2>/dev/null | grep -c "ok installed") -eq 0 ];
    then apt install $PACKAGE;
    else echo "found..."
fi

#arm headers
PACKAGE="binutils-arm-linux-gnueabi"
printf "${BLUE}[*] checking for: ${PURPLE}$PACKAGE${NC}\n"

if [ $(dpkg-query -W -f='${Status}' $PACKAGE 2>/dev/null | grep -c "ok installed") -eq 0 ];
    then apt install $PACKAGE;
    else echo "found..."
fi

#get arm cstdlib  shared objects
PACKAGE="libc6-armel-cross"
printf "${BLUE}[*] checking for: ${PURPLE}$PACKAGE${NC}\n"

if [ $(dpkg-query -W -f='${Status}' $PACKAGE 2>/dev/null | grep -c "ok installed") -eq 0 ];
    then apt install $PACKAGE;
    else echo "found..."
fi

printf "${BLUE}[*]${NC} setting up QEMU runtime enviroment\n"

set -x

ln -s /usr/arm-linux-gnueabihf/lib/ld-linux-armhf.so.3 /lib/
set +x

export LD_LIBRARY_PATH=/usr/arm-linux-gnueabihf/lib 


printf "${BLUE}[*]${NC} running test binary\n"

set -x

cd bin

file hello_world

./hello_world

set +x
printf "setup complete, run ${PURPLE}export LD_LIBRARY_PATH=/usr/arm-linux-gnueabihf/lib${NC} to complete initialization process\n"


