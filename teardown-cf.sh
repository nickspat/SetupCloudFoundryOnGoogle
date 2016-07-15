#!/usr/bin/env bash
set -e

if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/ff6d2c369b595696f199d67e081a8ddf70e562d8/constants.sh
chmod 744 ./constants.sh
source ./constants.sh

echo "Setting up bosh target"
/usr/local/bin/bosh target ${director_ip}

deployment_name="cf"

echo "Starting to deploy cloudfoundry"
/usr/local/bin/bosh delete deployment ${deployment_name}

echo "Delete cloudfoundry successful"
set -e
