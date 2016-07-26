#!/usr/bin/env bash
chmod 744 ./*.sh
source ./constants.sh


echo "-----------Setting up Infrastructure for BOSH director ----------------"
./director-infra-setup.sh

echo "-----------Setting up Infrastructure for Cloud Foundry ----------------"
./cf-infra-setup.sh


./sendfiles.sh

echo "-----------Setting up BOSH director ----------------"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "cd ./setupfiles && ./director-setup.sh"


echo "-----------Setting up Cloud Foundry ----------------"
bosh_ip=`gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :`
command="cd ./setupfiles && ./cf-setup.sh"
ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine ${bosh_ip} ${command}

# drop you in the bastion server for convienence 
gcloud compute ssh bosh-bastion --zone ${google_zone}
