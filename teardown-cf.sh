#!/usr/bin/env bash
set -e

gsutil cp gs://hd-labs-cfongcp/automation/constants.sh .
chmod 744 ./constants.sh
source ./constants.sh

echo "Setting up bosh target"
/usr/local/bin/bosh target ${director_ip}

deployment_name="cf"

echo "Starting to deploy cloudfoundry"
/usr/local/bin/bosh delete deployment ${deployment_name}

echo "Delete cloudfoundry successful"
set -e
