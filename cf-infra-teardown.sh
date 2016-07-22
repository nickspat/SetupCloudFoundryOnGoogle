#!/usr/bin/env bash
set -e

source_url="https://github.com/cgrant/setupcfongcp/raw/master"
google_region="us-central1"
google_zone=$google_region"-a"


if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget ${source_url}/constants.sh && chmod 744 ./constants.sh && source ./constants.sh

echo "Deleting forwarding-rules"
gcloud -q compute forwarding-rules delete cf-http --region ${google_region}
gcloud -q compute forwarding-rules delete cf-https --region ${google_region}
gcloud -q compute forwarding-rules delete cf-ssh --region ${google_region}
gcloud -q compute forwarding-rules delete cf-wss --region ${google_region}

echo "Deleting target-pools"
gcloud -q compute target-pools delete ${google_target_pool} --region ${google_region}

echo "Deleting http-health-checks"
gcloud -q compute http-health-checks delete ${google_backend_service}

gcloud -q compute firewall-rules delete ${cf_firewall_internal}
gcloud -q compute firewall-rules delete ${cf_firewall_public}

gcloud -q compute networks subnets delete ${cf_private_subnetwork} --region ${google_region}
gcloud -q compute networks subnets delete ${cf_public_subnetwork} --region ${google_region}

echo "Deleting addresses"
gcloud -q compute addresses delete ${google_address_cf} --region ${google_region}

set -e
