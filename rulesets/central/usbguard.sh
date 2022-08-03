#!/bin/bash

#Check counter of allowed and block. Like this you will notice differences quickly

usbguard(){
(/bin/grep -c allow /var/log/usbguard/usbguard-audit.log | awk '{ print "module=usbguard, allow=" $0}' | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log; /bin/grep -c block /var/log/usbguard/usbguard-audit.log | awk '{ print "module=usbguard, block=" $1}' | ts '[%Y-%m-%d %H:%M:%S]' >> /var/log/detector.log);
}

usbguard
