#!/bin/bash

sec_inotifywatch () {
/usr/bin/inotifywait -m -e OPEN -e CLOSE /usr/bin/whoami /usr/bin/sudo | ts '[%Y-%m-%d %H:%M:%S] module=inotifywait output=' >> /var/log/detector.log &

sec_inotifywatch
