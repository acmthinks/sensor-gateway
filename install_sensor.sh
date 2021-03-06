#!/bin/bash
# Installing DHT11 libraries, courtesy of AdaFruit https://learn.adafruit.com/dht-humidity-sensing-on-raspberry-pi-with-gdocs-logging
sudo apt-get update
sudo apt-get install build-essential python-dev python-openssl -y
cd ~
git clone https://github.com/adafruit/Adafruit_Python_DHT.git
cd Adafruit_Python_DHT/
sudo python setup.py install
#cd examples
#sudo ./AdafruitDHT.py 11 4

# Installing Paho Python client for MQTT
cd ~
sudo pip install paho-mqtt
git clone http://git.eclipse.org/gitroot/paho/org.eclipse.paho.mqtt.python.git
cd org.eclipse.paho.mqtt.python
sudo python setup.py install

# Installing Python libraries
cd /tmp
wget https://pypi.python.org/packages/source/n/netifaces/netifaces-0.10.4.tar.gz#md5=36da76e2cfadd24cc7510c2c0012eb1e
tar xvzf netifaces-0.10.4.tar.gz
cd netifaces-0.10.4
sudo python setup.py install

# Setting sensor data generation script as executable
cd ~
cp ~/sensor-gateway/dht11.py ~
chmod 755 dht11.py

# Install Python library for controlling GPIO ports
sudo pip install RPi.GPIO

# Setting RPi LED script as executable
cd ~
cp ~/sensor-gateway/lightitup.py ~
chmod 755 lightitup.py

# Let's validate that we can get a temp reading and light up the LED
cd ~/Adafruit_Python_DHT/examples
echo ""
echo "============== Temperature (C) and Humidity (courtesy of DHT11) =============="
echo ""
sudo ./AdafruitDHT.py 11 4
sudo python ~/lightitup.py
echo ""
echo "=============================================================================="


cd ~
