#!/bin/bash

dnsip(){
/usr/bin/systemd-resolve --status | /usr/bin/grep "Current DNS Server" | /usr/bin/cut -d ':' -f 2-3 | ts '[%Y-%m-%d %H:%M:%S] module=DNSIP output='  >> /var/log/detector.log
}
dnsip
