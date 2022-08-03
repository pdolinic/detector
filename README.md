# Detector OSS IDS

General Information: 
- GPLv3 License for detector OSS IDS. 
- All other used Open Source tools & libraries used are subject to the original developers rights & their original licenses - detector uses them to provide a free, fast and convenient Open Source IDS solution (for myself and anyone else who wants to).

Persistently scheduled system checks are ran in time-intervals and output does not want to be not signature, but behavior and class based. Outputs are timestamped, and labeled for futher processing (into Icinga 2 or Elasticstack).

This small personal project follows 3 basic goals: a) minimal b) trustable c) modular & customizable:

- Some of the currently required binaries for checks: AWK, SED & GREP (en masse), Inotify-Tools, Tracee, TS, USBGuard, SocketStats, Dialog, Inotify-Tools, (Nethogs)
- Just run the ./install.sh or ./uninstall.sh
- Comment or uncomment the execution of the central/privacy directories as you like

## How it works

- Runner: Create a 1) Systemd service with a timer, calling a 2) Watchdog with a timer, 3) calling a main (separating Operating Systems and module choices), 4) calling the modules

- Modules: 5) run checks 6) grep for exit codes  6) append a time-stamp 7) append a module tag (with a possible KV - filter for Logstash-Pipelines) ->> write to detecor-logfile | Optional:  9) output to Elastic (via Filebeat -> Logstash-Pipelines) 10) output to Icinga 2 (via passive-checks for more logic & free alerting)

## Outputting to Icinga
See `/central/icinga.pumper.sh` for more
- Generate a certificate, CSR and sign it:

```
icinga2 pki new-cert --cn ubsc-generic --key /var/lib/icinga2/certs/ubsc-generic.key --csr /var/lib/icinga2/certs/ubsc-generic.csr
icinga2 pki sign-csr --csr /var/lib/icinga2/certs/ubsc-generic.csr --cert /var/lib/icinga2/certs/ubsc-generic.crt
```
- Grep over the `detector.log` with keywords and on hits send passive-checks back to Icinga

## Outputting to Logstash

### Input and Output ##

This pipeline does not provide inputs or outputs so you can configure whatever you need. Files named `input.conf` and `output.conf` will not interfere with updates via git, so name your files accordingly.

Here are examples how your files could look if you want to use a local Redis instance.

```
input {
  redis {
    host => localhost
    key => "detector"
    data_type => list
  }
}

output {
  redis {
    key => "forwarder"
    data_type => list
    host => localhost
  }
}
```

This is possible KV filter for pipelines into Logstash. Thanks to @widhalmt, NETWAYS 2022 who greatly helped me with this filter

```
filter {
      grok {
        match => ["message", "%{TIMESTAMP_ISO8601:timestamp}\] %{GREEDYDATA:message}"]
        id => "detector"
        tag_on_failure => ["_grokparsefailure","detector_grok_failed"]
      }
      kv {
        source => "message"
        target => "detector"
      }
   }
```
### Filebeat

Filebeat needs to be configured appropriately: Usbguard can write to syslog, or to the default usbguard-log (which is chosen here as an example):

```
- type: log
  # Change to true to enable this input configuration.
  enabled: true
  # Paths that should be crawled and fetched. Glob based paths.
  paths:
    - /var/log/detector.log

```

## Example Blocking Devices for Privacy
Example: This is could be done via "/etc/modprobe.d/blacklist.conf"

```
blacklist snd_hda_intel #this will block the snd_hda_intel module, available after next restart
#blacklist snd_usb_audio
```

## Writing rules
To write a rule, just drop a file to the "ruleset"-folder. In the best case create a function and call it, and append the output to /var/log/detector.log. You want a format such as module=Yourmodule, status=ON or OFF.
