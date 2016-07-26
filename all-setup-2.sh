#!/usr/bin/env bash
chmod 744 ./*.sh 
source ./constants.sh


echo "-----------Setting up Infrastructure for BOSH director ----------------"
./director-infra-setup.sh

echo "-----------Setting up Infrastructure for Cloud Foundry ----------------"
./cf-infra-setup.sh


./sendfiles.sh

echo "-----------Setting up BOSH director ----------------"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "cd ./setupfiles && source ./constants.sh && ./director-setup.sh"


echo "-----------Setting up Cloud Foundry ----------------"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "cd ./setupfiles && source ./constants.sh && ./cf-setup.sh"
