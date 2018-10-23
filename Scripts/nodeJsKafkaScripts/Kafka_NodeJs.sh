#!/bin/bash
### Usage : Pass configuration file name. If no file name provided then it uses cdp-gcp-createdataproccluster.cfg in local directory
## Incase of any error, setting option to exit from shell script
	 set -e 
##
default_config_file='Kafka_NodeJs.cfg'
config_file_path=$1
if [ "$config_file_path" = "" ]
then
	
	echo "Using its own parameter config file : $default_config_file"
	script_relativepath=$0
	echo "Script Relative Path: $script_relativepath"
	script_path=`realpath $script_relativepath`
	echo "Script Path: $script_path"
	script_dir=`dirname $script_path`
	echo "Script Directory: $script_dir"
	config_file_path="$script_dir/$default_config_file"
fi

echo "Reading config file : $config_file_path"
. $config_file_path

############################ INSTALLING OF JAVA ######################################
sudo apt-get install -y openjdk-8-jdk
echo "export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_171" >>~/.bashrc
echo "export PATH=$JAVA_HOME/bin:$PATH" >>~/.bashrc

############################ INSTALLING OF KAFKA #####################################
sudo wget http://www-us.apache.org/dist/kafka/0.10.2.1/kafka_2.10-0.10.2.1.tgz
tar xzvf kafka_2.10-0.10.2.1.tgz

echo 'server.1='$InternalIP':2888:3888
initLimit=6
syncLimit=3' > kafka_2.10-0.10.2.1/config/temp_zookeeper.properties
cat kafka_2.10-0.10.2.1/config/zookeeper.properties >> kafka_2.10-0.10.2.1/config/temp_zookeeper.properties
mv kafka_2.10-0.10.2.1/config/temp_zookeeper.properties kafka_2.10-0.10.2.1/config/zookeeper.properties

echo 'port=9092
host.name='$InternalIP > kafka_2.10-0.10.2.1/config/temp_server.properties
cat kafka_2.10-0.10.2.1/config/server.properties >> kafka_2.10-0.10.2.1/config/temp_server.properties
mv kafka_2.10-0.10.2.1/config/temp_server.properties kafka_2.10-0.10.2.1/config/server.properties

sudo sed -i 's/broker.id=0/broker.id=0/g' kafka_2.10-0.10.2.1/config/server.properties
sudo sed -i 's/num.partitions=1/num.partitions=4/g' kafka_2.10-0.10.2.1/config/server.properties
sudo sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect='$InternalIP':2181/g' kafka_2.10-0.10.2.1/config/server.properties
sudo sed -i 's/23.251.153.93/'$InternalIP'/g' kafka_2.10-0.10.2.1/config/server.properties

######################## INSTALLING NODEJs ############################################
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y build-essential
mkdir nodeServer
cd nodeServer
sudo apt-get install npm
sudo npm init -y
cd ~
mv node_modules.zip ~/nodeServer
mv server.js ~/nodeServer
sudo apt-get install unzip
cd nodeServer
unzip node_modules

################################## Starting NODEJs #######################################
sudo node server.js &

################################## Starting KAFKA ########################################
cd ~/kafka_2.10-0.10.2.1
echo "Starting Zookeeper ...."
sudo bin/zookeeper-server-start.sh config/zookeeper.properties &
echo "Starting kafka ...."
sudo bin/kafka-server-start.sh config/server.properties	&
sudo bin/kafka-console-consumer.sh --zookeeper $InternalIP:2181 --topic omniture &

