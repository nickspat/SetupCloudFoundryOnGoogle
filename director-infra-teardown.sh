#!/usr/bin/env bash
set -e

source_url="https://github.com/cgrant/setupcfongcp/raw/master"
google_region="us-west1"
google_zone=$google_region"-b"


if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget ${source_url}/constants.sh && chmod 744 ./constants.sh && source ./constants.sh
echo "Deleting bosh-bastion"
gcloud -q compute instances delete bosh-bastion --zone ${google_zone}

echo "Deleting firewall-rules"

gcloud -q compute firewall-rules delete ${bosh_firewall}
gcloud -q compute firewall-rules delete ${google_firewall_internal}

echo "Deleting networks"

gcloud -q compute networks subnets delete ${google_subnetwork} --region ${google_region}
gcloud -q compute networks delete ${google_network}

set -e
