#!/usr/bin/env bash
set -e

source_url="https://github.com/nickspat/setupcfongcp/raw/master"

if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget ${source_url}/constants.sh && chmod 744 ./constants.sh && source ./constants.sh

echo "-------------- Starting to delete cloud foundry setup -----------------"
ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine `gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :` 'wget ${source_url}/cf-teardown.sh && chmod 744 ./cf-teardown.sh && ./cf-teardown.sh'

echo "-------------- Starting to teardown Cloud Foundry infrastructure components ---------------------"
wget ${source_url}/cf-infra-teardown.sh && chmod 744 ./cf-infra-teardown.sh && ./cf-infra-teardown.sh

echo "-------------- Starting to teardown Bosh Director -----------------"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget ${source_url}/director-teardown.sh && chmod 744 ./director-teardown.sh && ./director-teardown.sh"

echo "-------------- Starting to teardown Bosh Director infrastructure components ---------------------"
wget ${source_url}/director-infra-teardown.sh && chmod 744 ./director-infra-teardown.sh && ./director-infra-teardown.sh

echo "Successfully deleted bosh director, cloud foundry and GCP components"

set -e