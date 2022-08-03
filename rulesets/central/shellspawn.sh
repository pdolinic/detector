#!/bin/bash

#todo add shasum over shells
/usr/bin/ps -eaf --forest | grep -e "$(cut -d'/' -f3  /etc/shells)" | ts '[%Y-%m-%d %H:%M:%S] module=shellspawn output=' > /var/log/detector.log

