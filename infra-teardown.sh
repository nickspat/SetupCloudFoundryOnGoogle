#!/usr/bin/env bash
set -e

source_url="https://github.com/cgrant/setupcfongcp/raw/master"
google_region="us-west1"
google_zone=$google_region"-b"


echo "-------------- Starting to teardown Cloud Foundry infrastructure components ---------------------"
wget ${source_url}/cf-infra-teardown.sh && chmod 744 ./cf-infra-teardown.sh && ./cf-infra-teardown.sh


echo "-------------- Starting to teardown Bosh Director infrastructure components ---------------------"
wget ${source_url}/director-infra-teardown.sh && chmod 744 ./director-infra-teardown.sh && ./director-infra-teardown.sh

set -e
