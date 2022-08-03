#!/bin/bash

docker run --name tracee --rm -it --pid=host --cgroupns=host --privileged -v /etc/os-release:/etc/os-release-host:ro -e LIBBPFGO_OSRELEASE_FILE=/etc/os-release-host aquasec/tracee:latest --rules TRC-2 --rules TRC-6 --rules TRC-7 --rules TRC-15 | ts '[%Y-%m-%d %H:%M:%S] module=Tracee output=' >> /var/log/detector.log


# tracee-updater
#    tracee_present=$( /usr/bin/docker images -q tracee )
#    if [[ -n "$tracee_present" ]]; then
#    /usr/bin/docker pull aquasec/tracee;
#    /usr/bin/docker restart tracee;
#    fi
