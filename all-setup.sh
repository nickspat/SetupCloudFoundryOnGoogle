#!/usr/bin/env bash
set -e

source_url="https://github.com/nickspat/setupcfongcp/raw/master"

if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget ${source_url}/constants.sh && chmod 744 ./constants.sh && source ./constants.sh

echo "-----------Setting up Infrastructure for BOSH director ----------------"
wget ${source_url}/director-infra-setup.sh && chmod 744 ./director-infra-setup.sh && ./director-infra-setup.sh

echo "-----------Setting up Infrastructure for Cloud Foundry ----------------"
wget ${source_url}/cf-infra-setup.sh && chmod 744 ./cf-infra-setup.sh && ./cf-infra-setup.sh

echo "-----------Setting up BOSH director ----------------"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget ${source_url}/director-setup.sh && chmod 744 ./director-setup.sh && ./director-setup.sh"

echo "----------Starting to setup Cloud Foundry components ------------------"
ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine `gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :` 'wget ${source_url}/cf-setup.sh && chmod 744 ./cf-setup.sh && ./cf-setup.sh'

set -e