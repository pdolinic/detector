#!/bin/bash

#Sound presence (p=presence)
sound() {
(/bin/grep "RUNNING" /proc/asound/card*/pcm*p/sub*/status; if [ $? -eq 0 ]; \
then /bin/grep -e owner_pid /proc/asound/card*/pcm*p/sub*/status | cut -d ":" -f3 | awk '{print "module=Sound, status=ON, Parent_PID=" $0}' | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log; \
else echo "module=Sound, status=OFF " | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log; fi)
}

sound
