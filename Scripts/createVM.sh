#!/bin/bash
## Incase of any error, setting option to exit from shell script
	 set -e 
##

VMName='kafka-101'
VMZone='us-central1-b'
echo "Creating VM instance "
gcloud compute instances create $VMName --zone $VMZone --tags http-server,https-server --scopes cloud-platform

gsutil cp -r "gs://cdp-gcp-testing/kafka+nodeJs script" .
cd "kafka+nodeJs script"
gcloud compute scp --zone $VMZone server.js $VMName:~/
gcloud compute scp --zone $VMZone Kafka_NodeJs.cfg $VMName:~/
gcloud compute scp --zone $VMZone Kafka_NodeJs.sh $VMName:~/
gcloud compute scp --zone $VMZone node_modules.zip $VMName:~/

gcloud compute ssh --zone $VMZone $VMName --command 'chmod +x Kafka_NodeJs.sh && sudo apt-get install dos2unix && dos2unix * && ./Kafka_NodeJs.sh'