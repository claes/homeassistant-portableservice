# Home Assistant as a systemd portable service

These scripts performs a series of tasks in order to install Home Assistant
as a [systemd portable service](https://systemd.io/PORTABLE_SERVICES) on a Linux system.
It is developed on OpenSUSE and uses OpenSUSE within the systemd machine.
This can probably be quite easily adjusted but it works well for this purpose

There are two scripts that are intended for manual execution:

*build-ha-machine.sh*: This script should be run first and it will download the neccessary
packages into a machines directory, where later Home Assistant will be installed.
This script assumes it is run on an OpenSUSE host but can probably be adjusted for other
distributions. If zypper is installed on the host, it is probably fine to run it also on
a host of another distribution. 

Once this has completed, you should run:

*initialize-ha-machine.sh*: This script continues from the previous step by setting the
permissions etc to nspawn into the machine and within that context install Home Assistant.
This script will execute the bootstrap-homeassistant.sh as root within the nspawn environment,
which in turn will execute the install-homeassistant.sh script as the homeassistance user
within the same nspawn environment. This will actually install Home Assistant.
Once the these scripts have finished, there is a Home Assistant installation within the 
systemd machine. The initialyze-ha-machine.sh script the finished by installing a portable
service .service-file on the host machine, and starts it.

It can take some time for the portable service to start and be available, but once it is, 
you should then be able to access Home Assistant on port 8123 on the host machine:
http://<hostmachine>:8123

