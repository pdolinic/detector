#!/bin/bash

# Check if Tracee exists
tracee_present=$( /usr/bin/docker images -q tracee )

#Only run if Tracee isn't running
if [[ -n "$tracee_present" ]]; then
docker run --name tracee --rm --pid=host --cgroupns=host --privileged -v /etc/os-release:/etc/os-release-host:ro -e LIBBPFGO_OSRELEASE_FILE=/etc/os-release-host aquasec/tracee:latest --rules TRC-2 --rules TRC-6 --rules TRC-7 --rules TRC-15 | ts '[%Y-%m-%d %H:%M:%S] module=Tracee output=' >> /var/log/detector.log & 
fi

# tracee-updater
 #   if [[ -n "$tracee_present" ]]; then
 #   /usr/bin/docker pull aquasec/tracee;
 #   /usr/bin/docker restart tracee;
 #   fi
