#!/bin/bash
# https://www.medo64.com/2019/01/systemd-watchdog-for-any-service/
 
trap 'kill $(jobs -p)' EXIT

/usr/local/bin/detector/detector-main.sh & PID=$!

/bin/systemd-notify --ready

while(true); do
    FAIL=0
    kill -0 $PID
    if [[ $? -ne 0 ]]; then FAIL=1; fi
    if [[ $FAIL -eq 0 ]]; then /bin/systemd-notify WATCHDOG=1; fi
    sleep 15
done 
