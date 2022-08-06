#!/bin/bash

systemctl stop detector.service 2>/dev/null
systemctl disable detector.service 2>/dev/null
systemctl stop usbguard.service 2>/dev/null
systemctl daemon-reload 

rm -rf /opt/detector 2>/dev/null
rm -rf /usr/local/bin/detector 2>/dev/null

rm /etc/systemd/system/detector.service 2>/dev/null
#Stop & Remove Tracee
/usr/bin/docker stop tracee 2>/dev/null
/usr/bin/docker rm tracee 2>/dev/null
