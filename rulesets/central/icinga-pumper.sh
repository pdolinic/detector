##!/bin/bash

##Description: Small Check for Educational Purposes 
##Author: pdolinic@netways.de, Junior Consultant at NETWAYS Professional Services GmbH. Deutschherrnstr. 15-19 90429 Nuremberg. 

#License = GNU GPLv2

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.

##This Script is not intended with security in mind, and currently does not implement any length or size checks: It depends on the security of the Icinga/Nagios-Account.


### prep
#Generate Key & CS like
#icinga2 pki new-cert --cn ubsc-generic --key /var/lib/icinga2/certs/ubsc-generic.key --csr /var/lib/icinga2/certs/ubsc-generic.csr
#Sign CSR like
#icinga2 pki sign-csr --csr /var/lib/icinga2/certs/ubsc-generic.csr --cert /var/lib/icinga2/certs/ubsc-generic.crt

#Exit Codes
#Exit_Codes=" >> 0:OK, 1:Warn, 2:Critical, 3:Unkown << "

username_path= /home/$(/usr/bin/id -u -n)/LN/icinga-ubsc/ubsc-generic.crt

cat $username_path
icinga_passive_mic= /usr/bin/curl -k -S -s -i --cert $username_path --key $username_path -H 'Accept: application/json' -X POST 'https://10.0.0.1:5665/v1/actions/process-check-result' -d '{ "type": "Service", "filter": "host.name==\"vx\" && service.name==\"icinga-security\"", "exit_status": 2, "plugin_output": "Critical Security-Warning triggered", "pretty":true }'
icinga_mic= /usr/bin/grep -e "module=Microphone, status=ON" /var/log/detector.log


#Mic-Check
$icinga_mic
if [ $? -eq 0 ]; then 
	$icinga_passive_mic
fi;
