#!/bin/bash -x
# This script is not intended for manual execution.
# This script is run as root inside the systemd portable service
# container in order to prepare for installation of home assistant
# It starts of the installation as homeassistant user
# It requires that user to be already created

this_dir=$(dirname "$0")
cd /home/homeassistant
sudo chown -R homeassistant:homeassistant .homeassistant .

cd /srv
sudo mkdir -p /srv/homeassistant
sudo chown -R homeassistant:homeassistant /srv/homeassistant

cd /srv/homeassistant
sudo -u homeassistant -H -s $this_dir/install-homeassistant.sh
