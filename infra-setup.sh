#!/usr/bin/env bash
set -e

source_url="https://github.com/nickspat/setupcfongcp/raw/master"

echo "-----------Setting up Infrastructure for BOSH director ----------------"
wget ${source_url}/director-infra-setup.sh && chmod 744 ./director-infra-setup.sh && ./director-infra-setup.sh

echo "-----------Setting up Infrastructure for Cloud Foundry ----------------"
wget ${source_url}/cf-infra-setup.sh && chmod 744 ./cf-infra-setup.sh && ./cf-infra-setup.sh

set -e