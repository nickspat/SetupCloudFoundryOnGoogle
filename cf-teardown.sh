#!/usr/bin/env bash
source ./constants.sh

echo "Setting up bosh target"
/usr/local/bin/bosh target ${director_ip}

deployment_name="cf"

echo "Starting to destroy cloudfoundry"
/usr/local/bin/bosh delete deployment ${deployment_name}

echo "Delete cloudfoundry successful"
