#!/bin/bash

# Install MQTT broker (courtesy of Mosquitto at  http://mosquitto.org/2013/01/mosquitto-debian-repository/)
wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
sudo apt-key add mosquitto-repo.gpg.key

cd /etc/apt/sources.list.d/
sudo wget http://repo.mosquitto.org/debian/mosquitto-jessie.list

sudo apt-get update
sudo apt-get install mosquitto -y

# Run on reboot
sudo update-rc.d mosquitto defaults
sudo /etc/init.d/mosquitto start

# Setting up Node-RED as a service
cd ~
sudo wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/nodered.service -O /lib/systemd/system/nodered.service
sudo wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/node-red-start -O /usr/bin/node-red-start
sudo wget https://raw.githubusercontent.com/node-red/raspbian-deb-package/master/resources/node-red-stop -O /usr/bin/node-red-stop
sudo chmod +x /usr/bin/node-red-st*
sudo systemctl daemon-reload

#now let's enable as a system service
sudo systemctl enable nodered.service

# Let's add some other Nodes, by installing npm
sudo apt-get install npm -y
sudo npm install -g npm@2.x
node-red-start &

#Informix Timeseries
cd ~/.node-red
npm install node-red-contrib-timeseries
#IBM IoT Foundation
npm install node-red-contrib-scx-ibmiotapp
#Weather Underground
npm install node-red-node-weather-underground

cd ~
node-red-stop
node-red-start &

#restart RPi
#sudo shutdown -r now
# Install Informix
# Configure Informix Wire Listener (REST)
# Add Node-RED flow
