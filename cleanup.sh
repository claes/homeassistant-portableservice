#!/bin/bash
# This script cleans up the installed portable service from the host system

sudo systemctl stop portablehomeassistant
sudo systemctl disable portablehomeassistant
sudo portablectl detach machines/homeassistant/ portablehomeassistant.service
