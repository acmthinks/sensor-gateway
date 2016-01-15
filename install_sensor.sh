#!/usr/bin/bash
sudo apt-get update
sudo apt-get install build-essential python-dev python-openssl -y
cd ~
git clone https://github.com/adafruit/Adafruit_Python_DHT.git
cd Adafruit_Python_DHT/
sudo python setup.py install
cd examples
sudo ./AdafruitDHT.py 11 4
