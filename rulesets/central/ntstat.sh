#!/bin/bash

## Netstat listener counter
ntstat() {
(/bin/netstat -tunlp | grep -c "LISTEN" | awk '{print "module=Netstat_Listeners, counter=" $0}' | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log)
}

ntstat

