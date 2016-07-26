#!/usr/bin/env bash
source ./constants.sh
echo "-------------- Starting to delete cloud foundry setup -----------------"
./cf-teardown.sh
echo "-------------- Starting to teardown Cloud Foundry infrastructure components ---------------------"
./cf-infra-teardown.sh


echo "-------------- Starting to teardown Bosh Director -----------------"
./director-teardown.sh
