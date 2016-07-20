#!/usr/bin/env bash
set -e

if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi

wget https://gist.githubusercontent.com/raw/77430d2958e6b5a012674edb64dd8ed6/constants.sh
chmod 744 ./constants.sh
source ./constants.sh

echo "-----------Setting up Infrastructure for BOSH director and Cloud Foundry----------------"
wget https://gist.github.com/raw/77430d2958e6b5a012674edb64dd8ed6/setup-infrastructure.sh && chmod 744 ./setup-infrastructure.sh && ./setup-infrastructure.sh

gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget https://gist.github.com/raw/77430d2958e6b5a012674edb64dd8ed6/setup-director.sh && chmod 744 ./setup-director.sh && ./setup-director.sh"

ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine `gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :` 'wget https://gist.github.com/raw/77430d2958e6b5a012674edb64dd8ed6/setup-cf.sh && chmod 744 ./setup-cf.sh && ./setup-cf.sh'



set -e