#!/bin/bash
## Incase of any error, setting option to exit from shell script
	 set -e 
##

######################### Reading variables #########################
source creatingVM.cfg

######################### Creating VM instance #########################
staticIP=$(gcloud compute addresses list | grep 'kafka-static-ip')

if [ "$staticIP" = "" ]
then 
	echo "staticIP not found... creating external static IP"
	#gcloud compute addresses create stat-ddress --global --ip-version IPV4
	gcloud compute addresses create $kafkaExternalIP --region us-central1
fi
echo "Creating VM instance"
gcloud compute instances create $VMName --zone $VMZone --tags http-server,https-server --address $kafkaExternalIP --scopes cloud-platform

######################### Reading files from bucket #########################
echo "Copying file from bucket to kafka VM"
gsutil cp -r "gs://"$bucket"/nodeJsKafkaScripts" .
cd "nodeJsKafkaScripts"
gcloud compute scp --zone $VMZone Kafka_NodeJs.sh $VMName:~/
gcloud compute scp --zone $VMZone node_modules.zip $VMName:~/
sudo sed -i 's/35.188.11.2/'$InternalIP'/g' server.js
gcloud compute scp --zone $VMZone server.js $VMName:~/
networkIP=$(gcloud compute instances describe $VMName --zone $VMZone | grep 'networkIP')
echo $networkIP > Kafka_NodeJs.cfg
sudo sed -i 's/networkIP: /InternalIP=/g' Kafka_NodeJs.cfg
gcloud compute scp --zone $VMZone Kafka_NodeJs.cfg $VMName:~/

######################### Running Kafka_NodeJs.sh script #########################
echo "Kafka_NodeJs.sh script"
gcloud compute ssh --zone $VMZone $VMName --command 'chmod +x Kafka_NodeJs.sh && sudo apt-get install dos2unix && dos2unix * && ./Kafka_NodeJs.sh'