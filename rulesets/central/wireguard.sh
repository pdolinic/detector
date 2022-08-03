#!/bin/bash

#WG-show check for Endpoints

wireguard_check() {
/usr/bin/wg show | /usr/bin/grep -E endpoint | cut -d ':' -f 2-3 | awk '{print "module=Wireguard, connection=" $1}' | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log
}

wireguard_check
