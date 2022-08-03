#!/bin/bash

systemctl stop detector.service
systemctl disable detector.service
 systemctl stop usbguard.service
systemctl daemon-reload

rm -rf /opt/detector
rm -rf /usr/local/bin/detector

rm /etc/systemd/system/detector.service
#Stop & Remove Tracee
/usr/bin/docker stop tracee
/usr/bin/docker rm tracee
