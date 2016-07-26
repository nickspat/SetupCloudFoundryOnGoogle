#!/usr/bin/env bash

source ./constants.sh
tar -cvzf ../setupfiles.tar.gz ./

echo "-----------Setting up Infrastructure for BOSH director ----------------"
./director-infra-setup.sh




gcloud compute copy-files ../setupfiles.tar.gz bosh-bastion:~/ --zone us-west1-b

gcloud compute ssh bosh-bastion --zone ${google_zone} --command "mkdir -p ./setupfiles && tar -xvzf setupfiles.tar.gz -C ./setupfiles && chmod 755 ./setupfiles/*.sh && cd ./setupfiles && ./bastion-script.sh"
