#!/bin/bash

## Netstat listener counter
kallsyms() {
(/usr/bin/wc -l /proc/kallsyms | cut -d '/' -f 1 | awk '{print "module=kallsyms, counter=" $0}'  | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log
)
}

kallsyms

