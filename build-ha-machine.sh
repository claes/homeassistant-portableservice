#!/bin/bash
# This script prepares a systemd machine that will be used to run home assistant
# as a systemd portable service

machine=homeassistant
mkdir machines
machine_dir=$(readlink -f machines)

mkdir -p $machine_dir/$machine

if ! test -d $machinedir/$machine ; then
	echo "Building base machine"
	#sudo zypper --gpg-auto-import-keys --root=$machine_dir/$machine ar -c \
	#      https://download.opensuse.org/tumbleweed/repo/oss tumbleweed
	sudo zypper --gpg-auto-import-keys --root=$machine_dir/$machine ar -c \
	      https://download.opensuse.org/distribution/leap/15.2/repo/oss/ leap
	echo "Refreshing"
	sudo zypper --gpg-auto-import-keys --root=$machine_dir/$machine refresh
	echo "Installing main packages"
	sudo zypper --gpg-auto-import-keys --root=$machine_dir/$machine install --no-recommends --no-confirm \
		systemd shadow zypper openSUSE-release vim sudo \
		python3 python3-pip python3-devel python3-virtualenv libffi-devel libopenssl-devel \
		strace git make autoconf python3-setuptools_scm python3-setuptools-git gcc \
		pulseaudio-utils iputils telnet

	sudo cp /usr/share/terminfo/x/xterm-kitty $machine_dir/$machine/usr/share/terminfo/x/xterm-kitty
	sudo touch $machine_dir/$machine/etc/pulse/cookie
	#Prepare users and groups. NOTE: Commented, better overmount /etc/passwd and /etc/group into port service
	#echo "root:homeassistant" | sudo chpasswd -R $machine_dir/$machine
	#echo "homeassistant:homeassistant::homeassistant::/home/homeassistant:/bin/bash" | sudo newusers --root $machine_dir/$machine
fi

