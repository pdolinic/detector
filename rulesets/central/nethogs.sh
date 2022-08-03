#!/bin/bash

## Netstat listener counter
## Currently Disabled to to overspamming the Log-File

nethogs() {
(nethogs -t | ts '[%Y-%m-%d %H:%M:%S] module=Nethogs output=' | uniq | grep -v -e 'output=[[:space:]]*$' >> /var/log/detector.log)
}

#nethogs
