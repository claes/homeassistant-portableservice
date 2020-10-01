#!/bin/bash
#
# Before this script is run, there needs to be a systemd machine built
# using the build-ha-machine.sh script
#
# This script then uses that machine and performs the 
# neccessary preparations to install home assistant into it
#
# After that it nspawn's into it and installs home assistant
# by running the bootstrap-homeassistant script inside it
#
# That script will perform yet other preparations before executing the 
# install-homeassistant.sh script as the home assistant user
#
# Once that is done, it uses the machine to install it as a systemd portable 
# service


machine=homeassistant
machine_dir=$(readlink -f machines)
configdir=$(readlink -f configuration-.homeassistant)
currentuser=$(whoami)

if [ "$currentuser" == "root" ]; then
	echo "Please don't run this program as root. It will sudo as neccessary"
	exit
fi

# Create the group homeassistant which will be shared between the homeassistant user
# and the current user
# Make sure all files created within the configuration / data dir are belonging to that group
# That will make it easier to maintain

sudo groupadd -r homeassistant
sudo useradd -r homeassistant -G dialout,homeassistant
sudo usermod -a -G homeassistant $currentuser

# Set proper group permissions on $configdir
sudo chgrp -R homeassistant $configdir
sudo chmod g+w $configdir
sudo chmod g+s $configdir 

# Create and set proper group permissions on /srv/homeassistant installation dir
sudo mkdir -p $machine_dir/$machine/srv/homeassistant
sudo chgrp -R homeassistant $machine_dir/$machine/srv/homeassistant 
sudo chmod g+w $machine_dir/$machine/srv/homeassistant 
sudo chmod g+s $machine_dir/$machine/srv/homeassistant

# Prepare mountable directories to be used when installing home assistant
sudo mkdir -p $machine_dir/$machine/host-mnt 
sudo mkdir -p $machine_dir/$machine/home/homeassistant/.homeassistant

# Now install home assistant within the machine 
sudo systemd-nspawn -D $machine_dir/$machine \
	--bind $(readlink -f .):/host-mnt/ \
	--bind $configdir:/home/homeassistant/.homeassistant \
	--bind /etc/passwd \
	--bind /etc/shadow \
	--bind /etc/group \
	/host-mnt/bootstrap-homeassistant.sh
echo "Home assistant has been installed in $machine_dir/$machine"

#Now, just to be sure, make homeassistant user owner of all home assistant files
sudo chown -R homeassistant:homeassistant  $machine_dir/$machine/srv/homeassistant
sudo chown -R homeassistant:homeassistant  $machine_dir/$machine/home/homeassistant

# Install the service file that is going to be used when home assistant is run as a portable
# service. This will be extracted and applied when running portablectl attach later.
cat portablehomeassistant.service.template | sed  $(echo "s#TO_REPLACE#$configdir#g") > portablehomeassistant.service
sudo cp portablehomeassistant.service $machine_dir/$machine/usr/lib/systemd/system/portablehomeassistant.service
echo "Prepared for attaching as a portable service"

sudo portablectl -p trusted attach $machine_dir/$machine portablehomeassistant
echo "Home assistant has been attached as a TRUSTED portable service"

sudo firewall-cmd --permanent  --add-port=8123/tcp
sudo firewall-cmd --reload
echo "Opened firewall for home assistant"

sudo systemctl daemon-reload
sudo systemctl start portablehomeassistant
sudo systemctl enable portablehomeassistant
echo "Home assistant has been started as portable service"
sudo systemctl status portablehomeassistant
