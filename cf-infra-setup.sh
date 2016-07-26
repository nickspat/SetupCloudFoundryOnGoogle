#!/usr/bin/env bash

source ./constants.sh

echo "creating cf static address"
gcloud -q compute addresses create ${google_address_cf}
cf_ip=`gcloud compute addresses describe cf | grep ^address: | cut -f2 -d' '`
cf_domain="${cf_ip}.xip.io"

echo "creating subnets for cloud foundry"
gcloud -q compute networks subnets create ${cf_public_subnetwork} --network ${google_network} --range ${cf_public_subnet_range}  --region ${google_region}
gcloud -q compute networks subnets create ${cf_private_subnetwork} --network ${google_network} --range ${cf_private_subnet_range}  --region ${google_region}

echo "creating firewall-rules cf-public"
gcloud compute firewall-rules create ${cf_firewall_public}  --network ${google_network} --target-tags ${cf_firewall_public} --allow tcp:80,tcp:443,tcp:2222,tcp:4443

echo "creating firewall-rules cf-internal"
gcloud compute firewall-rules create ${cf_firewall_internal}  --network ${google_network} --source-tags ${cf_firewall_internal},${google_firewall_internal} --target-tags ${cf_firewall_internal} --allow tcp,icmp,udp

echo "creating http-health-checks"
gcloud -q compute http-health-checks create ${google_backend_service} --timeout "5s" --check-interval "30s" --healthy-threshold "10" --unhealthy-threshold "2" --port 80 --request-path "/info" --host "api.${cf_domain}"

echo "creating target-pools"
gcloud -q compute target-pools create ${google_target_pool}  --region=${google_region} --health-check ${google_backend_service}

echo "creating forwarding-rules"
gcloud compute forwarding-rules create cf-http  --ip-protocol TCP --ports=80 --target-pool ${google_target_pool} --address ${cf_ip} --region ${google_region}

gcloud compute forwarding-rules create cf-https  --ip-protocol TCP --ports=443 --target-pool ${google_target_pool} --address ${cf_ip} --region ${google_region}

gcloud compute forwarding-rules create cf-ssh  --ip-protocol TCP --ports=2222 --target-pool ${google_target_pool} --address ${cf_ip} --region ${google_region}

gcloud compute forwarding-rules create cf-wss  --ip-protocol TCP --ports=4443 --target-pool ${google_target_pool} --address ${cf_ip} --region ${google_region}
