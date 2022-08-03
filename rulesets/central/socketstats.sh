#!/bin/bash

SocketStats () {
(ss -tunlpa | sort | column -t | ts '[%Y-%m-%d %H:%M:%S] module=SocketStats output=' >> /var/log/detector.log)
}

SocketStats

