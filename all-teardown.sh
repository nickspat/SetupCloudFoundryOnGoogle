#!/usr/bin/env bash
source ./constants.sh

echo "-------------- Starting to delete cloud foundry setup -----------------"
bosh_ip=`gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :`
command="cd ./setupfiles && ./cf-teardown.sh"
ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine ${bosh_ip} ${command}

echo "-------------- Starting to teardown Bosh Director -----------------"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "cd ./setupfiles && ./director-teardown.sh"



echo "-------------- Starting to teardown Cloud Foundry infrastructure components ---------------------"
 ./cf-infra-teardown.sh

echo "-------------- Starting to teardown Bosh Director infrastructure components ---------------------"
./director-infra-teardown.sh



echo "Successfully deleted bosh director, cloud foundry and GCP components"
