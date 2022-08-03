#!/bin/bash

##Microphone presence (c=capture)
microphone(){
(/bin/grep "RUNNING" /proc/asound/card*/pcm*c/sub*/status; if [ $? -eq 0 ]; \
then /bin/grep -e owner_pid /proc/asound/card*/pcm*c/sub*/status | cut -d ":" -f3 | awk '{print "module=Microphone, status=ON Parent_PID=" $0}' | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log; \
else echo "module=Microphone, status=OFF " | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log; fi)
}

microphone
