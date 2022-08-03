#!/bin/bash

##Fileless (malware) presence
fileless (){
(/bin/ls -alR /proc/*/exe 2> /dev/null | grep "memfd:.*\(deleted\)"; if [ $? -eq 1 ]; then echo "module=Fileless, status=OFF " | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log; \
else echo "module=Fileless, status=ON" | /bin/ts >> /var/log/detector.log; fi)
}

fileless
