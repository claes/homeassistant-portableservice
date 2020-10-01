#!/bin/bash
sudo systemctl stop portablehomeassistant
sudo systemctl disable portablehomeassistant
sudo portablectl detach machines/homeassistant/ portablehomeassistant.service
