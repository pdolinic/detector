#!/bin/bash

if [ "$EUID" -ne 0 ]; then echo "Installation aborted, please run the ./install.sh as root!";sleep 2; exit;fi

distro_check()
{(/usr/bin/grep "^ID" /etc/os-release | cut -d "=" -f2)}

# Export Variables for Shellcheck
export fedora && export rhel && export debian && export ubuntu && export distro_check

# Manual: Ask-User-Install
read -p "Welcome to detector, this is a collection of Shellscripts to Build an OSS IDS! This program requires
	- inotify-tools
	- dialog
	- ts
        - usbguard 
       (- nethogs)
       (- docker for tracee)
        - Do you wish to install them?
	(The installer should work for RHEL / Fedora / Debian / Ubuntu)?  y/n " yn
    case $yn in
	[Yy]* )
if [ "$distro_check" == "$fedora" ] || [ "$distro_check" == "$rhel" ] 
then 
command -v /bin/ts >/dev/null 2>&1 && command -v /bin/usbguard >/dev/null 2>&1 && command -v /bin/inotifywait >/dev/null 2>&1 && command -v /bin/dialog 
if [ $? -eq 1 ]; then
    	sudo dnf install inotify-tools dialog moreutils usbguard -y;
 fi
fi
#Ubuntu
if [ "$distro_check" == "$ubuntu" ] || [ "$distro_check" == "$debian" ]; then
	command -v /usr/bin/ts >/dev/null 2>&1 && command -v /usr/bin/usbguard >/dev/null 2>&1 && command -v /usr/bin/inotifywait >/dev/null 2>&1 && command -v /usr/bin/dialog

if [ $? -eq 1 ]
then
	sudo apt install inotify-tools dialog moreutils usbguard -y;			
   fi
fi;;
	[Nn]* ) exit;;
	* ) echo "Please answer yes or no.";;
	esac


#Create directories & start copying files appropriately
mkdir -p /opt/detector /opt/detector/rulesets /usr/local/bin/detector

cmd=(dialog --separate-output --checklist "Select the modules you want:" 22 76 16)
options=(1 "Maximum: Central and Privacy!" on    # any option can be set to default to "on"
         2 "Medium: Central: Netstat, Fileless etc." off
	 3 "Privacy Camera, Audio, Microphone" off
	 4 "USBGuard: Enable&Start USBGuard? Warning: Lockout possible!" on
	 5 "Module: docker & tracee: Install docker for tracee!  " on
	 6 "Module: Inotifywait Honey-Pot-Auto-Dropper" off
	 7 "Module: Inotifywait: Honey-Pot-Self-Selected " off)
	
	
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

clear
echo "Choices are:" $choices
for choice in $choices
do
    case $choice in
        1)
           # echo "Everything: Central & Privacy"
	    sed -i -e 's/#central/central/' ./detector-main.sh; #sed -i -e 's/#central/central/' /usr/local/bin/detector-main.sh
	    sed -i -e 's/#privacy/privacy/' ./detector-main.sh; #sed -i -e 's/#privacy/privacy/' /usr/local/bin/detector-main.sh
            ;;
        2)
           # echo "Central: Netstat, Fileless etc."
	    sed -i -e 's/#central/central/' ./detector-main.sh; #sed -i -e 's/#central/central/' usr/local/bin/detector-main.sh;
	    sed -i -e 's/^privacy/#&/' ./detector-main.sh; #sed -i -e 's/^privacy/#&/' /usr/local/bin/detector-main.sh;
            ;;
        3)
           # echo "Privacy: Camera, Audio, Microphone"
	    sed -i -e 's/#privacy/privacy/' ./detector-main.sh; #sed -i -e 's/#privacy/privacy/' /usr/local/bin/detector-main.sh;
            sed -i -e 's/^central/#&/' ./detector-main.sh; #sed -i -e 's/^central/#&/' /usr/local/bin/detector-main.sh;
            ;;
        4)
           # echo "Enable & Start USBGUARD? Lockout for unconnected USB"
      	systemctl is-active --quiet usbguard
      	if [ $? -ne 0 ]; then
      	usbguard generate-policy > /etc/usbguard/rules.conf;
      	systemctl enable usbguard && systemctl start usbguard;
      	fi;;
              5)
      	# Install Docker for tracee
          if [ "$distro_check" == "$fedora" ] || [ "$distro_check" == "$rhel" ] 
          then 
          command -v /bin/docker >/dev/null 2>1 && command -v /bin/podman >/dev/null 2>1 
          if [ $? -eq 1 ]; then
              	dnf install podman podman-docker -y;
          	/usr/bin/docker pull aquasec/tracee;
           fi
          fi
          #Ubuntu
          if [ "$distro_check" == "$ubuntu" ] || [ "$distro_check" == "$debian" ]; then
          	command -v /usr/bin/docker >/dev/null 2>&1
          
          if [ $? -eq 1 ]
          then
          	apt install docker -y;
          	/usr/bin/docker pull aquasec/tracee;
             fi
          fi
	      ;;
        6)
	# Honeypot Autodropper POC
        auto_sec_inf1="./rulesets/central/auto_inotifybuster.sh"
        auto_sec_inf2="/opt/detector/rulesets/central/auto_inotifybuster.sh"
        if [ -f "$auto_sec_inf1" ]; then rm "$auto_sec_inf1"; fi
        if [ -f "$auto_sec_inf2" ]; then rm "$auto_sec_inf2"; fi
if [ -d "/home/$(id -u -n)" ]; then
        RandomID1=$(/usr/bin/cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 10;echo)
        RandomID2=$(/usr/bin/cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 10;echo)
#RandomID= od -A n -t d -N 1 /dev/urandom |tr -d ' ' 
       random_file1="/home/$(id -u -n)/.ssh/id_rsa"
       random_file2="/home/$(id -u -n)/Documents/secure-passwords-"$RandomID1".txt"
       random_file3="/home/$(id -u -n)/secure-keys-$RandomID2.docx"
       touch $random_file1 $random_file2
cat <<EOF > "$auto_sec_inf1"
#!/bin/bash
/usr/bin/inotifywait -m -e OPEN -e CLOSE "$random_file1" "$random_file2" "$random_file3" | ts '[%Y-%m-%d %H:%M:%S] module=inotifywait output=' >> /var/log/detector.log 
EOF
echo "Successfully added new trackers!"
#else exit
fi
	    ;;
        7)
	# Honeypot selfselected POC
        self_sec_inf1="./rulesets/central/sec_inotifybuster.sh"
        self_sec_inf2="/opt/detector/rulesets/central/sec_inotifybuster.sh"
        if [ -f "$self_sec_inf1" ]; then rm "$self_sec_inf1"; fi
        if [ -f "$self_sec_inf2" ]; then rm "$self_sec_inf2"; fi
        echo "Enter multiple quoted paths after another e.g.'/home/$(id -u -n)/.ssh/id_ed25519' '/home/$(id -u -n)/Documents/high-sequiry-pw.docx'"
        read honey_input
if [ -z "$honey_input" ]; then echo "No arguments supplied"
else
cat <<EOF > "$self_sec_inf1"
#!/bin/bash
/usr/bin/inotifywait -m -e OPEN -e CLOSE $honey_input | ts '[%Y-%m-%d %H:%M:%S] module=inotifywait output=' >> /var/log/detector.log 
EOF
echo "Successfully added new trackers!"
        fi
	      ;;
    esac
done

cp ./detector-main.sh /usr/local/bin/detector/
cp ./runner.sh /usr/local/bin/detector/
cp -r ./rulesets /opt/detector/
cp ./detector.service /etc/systemd/system/detector.service

chown -R root:root /opt/detector/*
chmod -R 750 /opt/detector
chmod -R 750 /usr/local/bin/detector
chmod 750 /var/log/detector.log
#recursively chmod +x
chmod -R 750 /opt/detector/rulesets 

systemctl daemon-reload
systemctl enable detector.service
systemctl start detector.service
