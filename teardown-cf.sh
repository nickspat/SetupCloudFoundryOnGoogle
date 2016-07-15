#!/usr/bin/env bash
set -e

if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget https://gist.githubusercontent.com/raw/77430d2958e6b5a012674edb64dd8ed6/constants.sh
chmod 744 ./constants.sh
source ./constants.sh

echo "Setting up bosh target"
/usr/local/bin/bosh target ${director_ip}

deployment_name="cf"

echo "Starting to deploy cloudfoundry"
/usr/local/bin/bosh delete deployment ${deployment_name}

echo "Delete cloudfoundry successful"
set -e
