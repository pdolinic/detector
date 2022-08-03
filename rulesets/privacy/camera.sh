#!/bin/bash

camera() {
(/bin/grep uvcvideo /proc/modules | awk ' { print $1,$3 } ' | grep "uvcvideo 0"; if [ $? -eq 0  ]; \
then echo "module=Camera, status=OFF " | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log;fi; \
        /bin/grep uvcvideo /proc/modules | awk ' { print $1,$3 } ' | grep "uvcvideo 1"; if [ $? -eq 0  ]; \
then echo "module=Camera, status=ON" | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log;fi; \
        /bin/grep uvcvideo /proc/modules ; if [ $? -eq 1 ]; then echo "module=Camera status=NOT_INSTALLED" | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log; fi;)
}

camera
