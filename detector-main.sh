#!/bin/bash

#Execute all Scripts in path
#run-parts /opt/detector/rulesets
#https://queirozf.com/entries/sed-examples-search-and-replace-on-linux

detect_linux(){

central="/opt/detector/rulesets/central/*.sh"
privacy="/opt/detector/rulesets/privacy/*.sh"

ARRAY1=()
ARRAY1+=("$central")
ARRAY2=()
ARRAY2+=("$privacy")

#Don't keep adding to the log, by uncommenting the following echo, make sure to use other tools to extract logs in time
#echo "---" > /var/log/detector.log
for file in $ARRAY1 $ARRAY2
do
bash "$file"
done
}

detector_main(){
OS="`uname`"
case $OS in
  'Linux')
detect_linux;;
esac
}

detector_main

#Check OS-TYPE
# https://megamorf.gitlab.io/2021/05/08/detect-operating-system-in-shell-script/
# Detect the platform (similar to $OSTYPE)
#    alias ls='ls --color=auto'
#    ;;
#  'FreeBSD')
#    OS='FreeBSD'
#    alias ls='ls -G'
#    ;;
#  'WindowsNT')
#    OS='Windows'
#    ;;
#  'Darwin')
#    OS='Mac'
#    ;;
#  'SunOS')
#    OS='Solaris'
#    ;;
#  'AIX') ;;
#  *) ;;
#esac
#
