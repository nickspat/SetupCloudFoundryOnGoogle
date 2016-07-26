#!/usr/bin/env bash

set -e

source ./constants.sh


echo "-----------Setting up BOSH director ----------------"
gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget ${source_url}/director-setup.sh && chmod 744 ./director-setup.sh && ./director-setup.sh"
