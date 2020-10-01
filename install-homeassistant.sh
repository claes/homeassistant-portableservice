#!/bin/sh
# This script is not intended for manual execution
# This script is run as the homeassistant user inside the container in order to install homeassistant
cd /srv/homeassistant
python3 -m venv .
source bin/activate
python3 -m pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org  wheel
python3 -m pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org  Cython 
python3 -m pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org  aiocoap==0.4b1
python3 -m pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org  DTLSSocket==0.1.7
python3 -m pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org  pytradfri[async]==6.3.1
python3 -m pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org  pyserial-asyncio==0.4
python3 -m pip install --trusted-host files.pythonhosted.org --trusted-host pypi.org --trusted-host pypi.python.org  homeassistant==0.103.5 
