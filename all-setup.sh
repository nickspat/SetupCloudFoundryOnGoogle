#!/usr/bin/env bash
set -e


tar -cvzf setupfiles.tar.gz ./

gcloud compute copy-files setupfiles.tar.gz bosh-bastion:~/ --zone us-west1-b
tar -xvzf deployfiles.tar.gz


google_region="us-west1"
google_zone=$google_region"-b"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "echo"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "tmux -c './setupfiles/all-setup.sh'"




./infra-setup.sh

echo "-----------Setting up BOSH director ----------------"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget ${source_url}/director-setup.sh && chmod 744 ./director-setup.sh && ./director-setup.sh"


echo "----------Starting to setup Cloud Foundry components ------------------"
bosh_ip=`gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :`
command="wget ${source_url}/cf-setup.sh && chmod 744 ./cf-setup.sh && ./cf-setup.sh"
ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine ${bosh_ip} ${command}

set -e
