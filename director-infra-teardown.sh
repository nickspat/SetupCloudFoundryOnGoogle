#!/usr/bin/env bash
source ./constants.sh
echo "Deleting bosh-bastion"
gcloud -q compute instances delete bosh-bastion --zone ${google_zone}

echo "Deleting firewall-rules"

gcloud -q compute firewall-rules delete ${bosh_firewall}
gcloud -q compute firewall-rules delete ${google_firewall_internal}

echo "Deleting networks"

gcloud -q compute networks subnets delete ${google_subnetwork} --region ${google_region}
gcloud -q compute networks delete ${google_network}
