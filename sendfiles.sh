#!/usr/bin/env bash

source ./constants.sh


tar -cvzf ../setupfiles.tar.gz ./
gcloud compute copy-files ../setupfiles.tar.gz bosh-bastion:~/ --zone us-west1-b

gcloud compute ssh bosh-bastion --zone ${google_zone} --command "mkdir -p ./setupfiles && tar -xvzf setupfiles.tar.gz -C ./setupfiles && chmod 744 ./setupfiles/*.sh"
