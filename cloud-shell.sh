#!/usr/bin/env bash
set -e

./constants.sh
tar -cvzf ../setupfiles.tar.gz ./

echo "-----------Setting up Infrastructure for BOSH director ----------------"
./director-infra-setup.sh




#tar -cvzf setupfiles.tar.gz ./
gcloud compute copy-files ../setupfiles.tar.gz bosh-bastion:~/ --zone us-west1-b
#tar -xvzf deployfiles.tar.gz
