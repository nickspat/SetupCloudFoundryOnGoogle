#!/usr/bin/env bash



./infra-setup.sh

echo "-----------Setting up BOSH director ----------------"
ssh bosh-bastion ./director-setup.sh


echo "----------Starting to setup Cloud Foundry components ------------------"
ssh bosh-bastion ./cf-setup.sh
