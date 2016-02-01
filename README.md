# sensor-gateway
Intended for Raspberry Pi 2, Python code and collateral to setup a sensor data generator and and intercepting sensor gateway #mqtt #python #raspberry-pi #iot #raspbian #dht11

Requires: Raspbian "Jessie" (2015-11-21, Kernal 4.1)
Requires: IBM Informix binary (https://www-01.ibm.com/marketing/iwm/tnd/preconfig.jsp?id=2013-03-26+02%3A55%3A11.262441R&S_TACT=&S_CMP=) at /home/pi 



logon as pi

cd /home/pi

git clone https://github.com/acmthinks/sensor-gateway

cd  sensor-gateway

chmod 744 *.sh

./install_gateway.sh

./install_sensor.sh
