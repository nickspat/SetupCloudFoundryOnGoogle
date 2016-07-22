#!/usr/bin/env bash
set -e

source_url="https://github.com/cgrant/setupcfongcp/raw/master"
google_region="us-central1"
google_zone=$google_region"-a"

if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget ${source_url}/constants.sh && chmod 744 ./constants.sh && source ./constants.sh

wget ${source_url}/infra-setup.sh && chmod 744 ./infra-setup.sh && ./infra-setup.sh

echo "-----------Setting up BOSH director ----------------"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget ${source_url}/director-setup.sh && chmod 744 ./director-setup.sh && ./director-setup.sh"


echo "----------Starting to setup Cloud Foundry components ------------------"
bosh_ip=`gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :`
command="wget ${source_url}/cf-setup.sh && chmod 744 ./cf-setup.sh && ./cf-setup.sh"
ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine ${bosh_ip} ${command}

set -e
