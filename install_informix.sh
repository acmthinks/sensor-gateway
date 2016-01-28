#!/bin/bash

#Props to https://github.com/IBM-IoT/iot-gateway-kit

########################################################
# Setup environment 
########################################################
WC=`ls -al $IOTKITDIR/../../ | grep iot-gateway-kit-depend | wc -l`
if [ "$WC" == "0" ]; then
	sudo mkdir $IOTKITDEPEND
else
	ISDIR=`ls -al $IOTKITDIR/../../ | grep iot-gateway-kit-depend | cut -c 1`
	if [ "$ISDIR" == "-" ]; then
		sudo rm -f $IOTKITDEPEND
		sudo mkdir $IOTKITDEPEND
	fi
fi
		

########################################################
# Read in the supporting functions 
########################################################
. $IOTKITDIR/scripts/funcs

########################################################
# Create install.log file
########################################################
sudo bash -c "echo 'Begin Install' > install.log" 

########################################################
# Run apt-get update 
########################################################
LOGSTART "Run apt-get update"
. $IOTKITDIR/scripts/install.apt-get.update > $IOTKITDIR/LOG/update.log 2>&1
LOGSTOP


########################################################
# Create Informix user
########################################################
LOGSTART "Create Informix User"
. $IOTKITDIR/scripts/install.informix.user > $IOTKITDIR/LOG/user.log 2>&1
LOGSTOP


########################################################
# Install Informix Product 
########################################################
LOGSTART "Install Informix Product"
. $IOTKITDIR/scripts/install.informix.prod
LOGSTOP


########################################################
# Install Informix General
########################################################
LOGSTART "Install Informix General"
. $IOTKITDIR/scripts/install.informix.general > $IOTKITDIR/LOG/informix.log 2>&1 
LOGSTOP

########################################################
# Starting Informix service 
########################################################
LOGSTART "Starting iot Service"
sudo service informix stop  
LOGSTOP
