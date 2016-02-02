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

#update node-red
cd ~
sudo apt-get update
sudo apt-get install nodered -y

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
cd ~/.node-red
sudo apt-get install npm -y
sudo npm install -g npm@2.x
node-red-start &

#Informix Timeseries nodes
cd ~/.node-red
npm install node-red-contrib-timeseries
#Weather Underground nodes
npm install node-red-node-weather-underground

#Bounce Node-RED
cd ~
node-red-stop
cp ~/sensor-gateway/.node-red/flows_raspberrypi.json ~/.node-red/
cp -r ~/node_modules/ ~/.node-red/
node-red-start &

if [ ! -d ~/iot-gateway-kit ]
then
  #Install Informix
  #PRE-REQ: Informix binary install must be placed in /home/pi; The Informix binary must be downloaded at the following URL (please, accept IBM terms)
  # https://www-01.ibm.com/marketing/iwm/iwm/web/reg/pick.do?source=ifxids
  #Be sure to choose "Informix Developer Edition for Linux ARM v6 32 (Raspberry PI) Version  12.10UC6DE " and place in /home/pi
  mkdir ~/iot-gateway-kit-depend
  mv ~/ids.12.10.UC6DE.Linux-ARM6.tar ~/iot-gateway-kit-depend/ids.12.10.UC6DE.Linux-ARM6.tar
  #Let's use the IBM-IoT Kit to install Informix
  cd ~
  git clone https://github.com/IBM-IoT/iot-gateway-kit
  cd ~/iot-gateway-kit
  cp ~/sensor-gateway/install_informix.sh ~/iot-gateway-kit/pi/install
  . ~/iot-gateway-kit/iot_install
fi

#Create TimeSeries db to store sensor data
cd ~/sensor-gateway
./createSensorDB.sh

#Start REST listener
cd ~/iot-gateway-kit/scripts
sudo bash -c ". ~informix/inf.env;. ~informix/REST/start.rest /var/run/start.rest.pid
cd ~
