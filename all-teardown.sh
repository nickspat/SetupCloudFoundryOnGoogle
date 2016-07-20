#!/usr/bin/env bash
set -e

if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget https://gist.githubusercontent.com/raw/77430d2958e6b5a012674edb64dd8ed6/constants.sh
chmod 744 ./constants.sh
source ./constants.sh

ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine `gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :` 'wget https://gist.github.com/raw/77430d2958e6b5a012674edb64dd8ed6/teardown-cf.sh && chmod 744 ./teardown-cf.sh && ./teardown-cf.sh'

gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget https://gist.github.com/raw/77430d2958e6b5a012674edb64dd8ed6/teardown-director.sh && chmod 744 ./teardown-director.sh && ./teardown-director.sh"

wget https://gist.github.com/raw/77430d2958e6b5a012674edb64dd8ed6/teardown-infrastructure.sh && chmod 744 ./teardown-infrastructure.sh && ./teardown-infrastructure.sh

echo "Successfully deleted bosh director, cloud foundry and GCP components"

set -e