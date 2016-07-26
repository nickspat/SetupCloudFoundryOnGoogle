#!/usr/bin/env bash

set -e

source ./constants.sh


echo "-----------Setting up BOSH director ----------------"
./director-setup.sh


echo "-----------Setting up Infrastructure for Cloud Foundry ----------------"
./cf-infra-setup.sh


echo "-----------Setting up Cloud Foundry ----------------"
./cf-setup.sh
