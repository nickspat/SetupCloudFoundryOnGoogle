#!/usr/bin/env bash
set -e

gsutil cp gs://hd-labs-cfongcp/automation/constants.sh .
chmod 744 ./constants.sh
source ./constants.sh

gcloud config set project ${google_project}
gcloud config set compute/region ${google_region}
gcloud config set compute/zone ${google_zone}

echo "Deleting forwarding-rules"
gcloud -q compute forwarding-rules delete cf-http --region ${google_region}
gcloud -q compute forwarding-rules delete cf-https --region ${google_region}
gcloud -q compute forwarding-rules delete cf-ssh --region ${google_region}
gcloud -q compute forwarding-rules delete cf-wss --region ${google_region}

echo "Deleting target-pools"
gcloud -q compute target-pools delete ${google_target_pool} --region ${google_region}

echo "Deleting http-health-checks"
gcloud -q compute http-health-checks delete ${google_backend_service}

echo "Deleting bosh-bastion"
gcloud -q compute instances delete bosh-bastion --zone ${google_zone}


echo "Deleting firewall-rules"
gcloud -q compute firewall-rules delete ${cf_firewall_internal}
gcloud -q compute firewall-rules delete ${cf_firewall_public}
gcloud -q compute firewall-rules delete ${bosh_firewall}
gcloud -q compute firewall-rules delete ${google_firewall_internal}

echo "Deleting networks"
gcloud -q compute networks subnets delete ${cf_private_subnetwork} --region ${google_region}
gcloud -q compute networks subnets delete ${cf_public_subnetwork} --region ${google_region}
gcloud -q compute networks subnets delete ${google_subnetwork} --region ${google_region}
gcloud -q compute networks delete ${google_network}

echo "Deleting addresses"
gcloud -q compute addresses delete ${google_address_cf} --region ${google_region}

set -e
