#!/bin/bash

#Install Informix (https://www.raspberrypi.org/forums/viewtopic.php?t=97199&p=674959)
cd ~

#let's check to make sure the Informix binary is present
if [ -e ~/ids.12.10.UC6DE.Linux-ARM6.tar]
then 
  mkdir /tmp/ifxinstall
  cd /tmp/ifxinstall
  mv ~/ids.12.10.UC6DE.Linux-ARM6.tar .
  tar xvf /tmp/ifxinstall/ids.12.10.UC6DE.Linux-ARM6.tar

  sudo groupadd informix
  sudo useradd -g informix -m informix
  sudo bash -c "echo informix:informix | chpasswd informix"

  # Make sure to add the user informix to the /etc/sudoers file by adding the following line by using the 'sudo visudo' command:
  sudo bash -c "echo 'informix ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers"

  # Run the Informix install script. During the installation you will be asked for an install dir. You might want to use /opt/IBM/informix1210UC6DE
  sudo ./ids_install -DINSTALL_DIR=/opt/IBM/informix1210UC6DE -DLICENSE_ACCEPTED=TRUE -i silent
  cd ~
  rm -rf /tmp/ifxinstall

  sudo ln -s /opt/IBM/informix1210UC6DE /opt/IBM/informix
  sudo mkdir /opt/IBM/ifxdata
  sudo chown informix:informix /opt/IBM/ifxdata
  sudo chmod 770 /opt/IBM/ifxdata

  # Append the following lines to /home/informix/.bashrc
  sudo bash -c "echo 'export INFORMIXDIR=/opt/IBM/informix' >> /home/informix/.bashrc"
  sudo bash -c "echo 'export PATH=$PATH:$INFORMIXDIR/bin' >> /home/informix/.bashrc"
  sudo bash -c "echo 'export INFORMIXSERVER=ol_informix1210' >> /home/informix/.bashrc"

  # Setup Informix variables
  export INFORMIXDIR=/opt/IBM/informix
  export PATH=$PATH:$INFORMIXDIR/bin
  export INFORMIXSERVER=ol_informix1210
  sudo cp ~/sensor-gateway/inf.env $INFORMIXDIR/etc/inf.env 
  sudo chmod 644 $INFORMIXDIR/etc/inf.env
  sudo chown informix:informix $INFORMIXDIR/etc/inf.env
  
  #sudo -u informix cp $INFORMIXDIR/etc/onconfig.std $INFORMIXDIR/etc/onconfig
  sudo cp $INFORMIXDIR/etc/sqlhosts.demo $INFORMIXDIR/etc/sqlhosts

  sudo cp ~/sensor-gateway/onconfig $INFORMIXDIR/etc/onconfig 
  sudo chmod 644 $INFORMIXDIR/etc/onconfig
  sudo chown informix:informix $INFORMIXDIR/etc/onconfig
  sudo bash -c "echo 'ol_informix1210   onsoctcp   localhost   9088' >> $INFORMIXDIR/etc/sqlhosts"

  sudo touch /opt/IBM/ifxdata/rootdbs
  sudo chown informix:informix /opt/IBM/ifxdata/rootdbs
  sudo chmod 660 /opt/IBM/ifxdata/rootdbs
  
  #Start Informix 
  sudo bash -c ". $INFORMIXDIR/etc/inf.env;oninit -iwy"
fi 

#Enable the wire listener for REST calls
#cp $INFORMIXDIR/etc/jsonListener-example.properties  rest.properties
#vi $INFORMIXDIR/etc/rest.properties

#Uncomment and update the listener type (the default is "mongo" but change it to "rest")
#listener.type=rest




#Start the wire listener
#java -cp $INFORMIXDIR/bin/jsonListener.jar com.ibm.nosql.server.ListenerCLI -config $INFORMIXDIR/etc/rest.properties -logfile $INFORMIXDIR/tmp/restListener.log -start &

#fyi, to stop the wire listener
#java -cp $INFORMIXDIR/bin/jsonListener.jar com.ibm.nosql.server.ListenerCLI -config $INFORMIXDIR/etc/rest.properties -hostname localhost -stop 
