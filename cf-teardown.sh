#!/usr/bin/env bash
set -e

source_url="https://github.com/cgrant/setupcfongcp/raw/master"
google_region="us-west1"
google_zone=$google_region"-b"


if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget ${source_url}/constants.sh && chmod 744 ./constants.sh && source ./constants.sh

echo "Setting up bosh target"
/usr/local/bin/bosh target ${director_ip}

deployment_name="cf"

echo "Starting to deploy cloudfoundry"
/usr/local/bin/bosh delete deployment ${deployment_name}

echo "Delete cloudfoundry successful"
set -e
