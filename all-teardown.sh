#!/usr/bin/env bash
source ./constants.sh

echo "-------------- Starting to delete cloud foundry setup -----------------"
ssh bosh-bastion ./cf-teardown.sh

echo "-------------- Starting to teardown Bosh Director -----------------"
ssh bosh-bastion ./director-teardown.sh

./infra-teardown.sh

echo "Successfully deleted bosh director, cloud foundry and GCP components"
