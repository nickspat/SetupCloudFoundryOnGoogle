#!/usr/bin/env bash
set -e

if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/ff6d2c369b595696f199d67e081a8ddf70e562d8/constants.sh
chmod 744 ./constants.sh
source ./constants.sh

gcloud config set project ${google_project}
gcloud config set compute/region ${google_region}
gcloud config set compute/zone ${google_zone}


echo "creating cf static address"
gcloud -q compute addresses create ${google_address_cf}


echo "create cf network and subnets"

gcloud -q compute networks create ${google_network} --mode custom
gcloud -q compute networks subnets create ${google_subnetwork} --network ${google_network} --range ${google_subnetwork_range} --region ${google_region} --description "Subnet for BOSH Director and bastion"
gcloud -q compute networks subnets create ${cf_public_subnetwork} --network ${google_network} --range ${cf_public_subnet_range} --description "Subnet for public CloudFoundry components" --region ${google_region}
gcloud -q compute networks subnets create ${cf_private_subnetwork} --network ${google_network} --range ${cf_private_subnet_range} --description "Subnet for private CloudFoundry components" --region ${google_region}

echo "create fire-wall rules"
gcloud -q compute firewall-rules create ${google_firewall_internal} --description "Cloud Foundry Internal traffic" --network ${google_network} --source-tags ${google_firewall_internal} --target-tags ${google_firewall_internal} --allow tcp,udp,icmp
gcloud -q compute firewall-rules create ${bosh_firewall} --description "BOSH bastion" --network ${google_network} --target-tags ${bosh_firewall} --allow tcp:22,icmp
echo "creating firewall-rules cf-public"
gcloud compute firewall-rules create ${cf_firewall_public} --description "Cloud Foundry Public Traffic" --network ${google_network} --target-tags ${cf_firewall_public} --allow tcp:80,tcp:443,tcp:2222,tcp:4443

echo "creating firewall-rules cf-internal"
gcloud compute firewall-rules create ${cf_firewall_internal} --description "Cloud Foundry Public Traffic" --network ${google_network} --source-tags ${cf_firewall_internal},${google_firewall_internal} --target-tags ${cf_firewall_internal} --allow tcp,icmp,udp


echo "creating bosh bastion server"
gcloud -q compute instances create bosh-bastion --image-family=ubuntu-1404-lts --image-project=ubuntu-os-cloud --subnet ${google_subnetwork} --private-network-ip 10.0.0.200 --tags bosh-bastion,bosh-internal --scopes cloud-platform --metadata "startup-script=apt-get update -y ; apt-get upgrade -y ; apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 ; gem install bosh_cli ; curl -o /usr/bin/bosh-init https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.94-linux-amd64; chmod +x /usr/bin/bosh-init; curl -o /tmp/cf.tgz https://s3.amazonaws.com/go-cli/releases/v6.19.0/cf-cli_6.19.0_linux_x86-64.tgz; tar -zxvf /tmp/cf.tgz && mv cf /usr/bin/cf && chmod +x /usr/bin/cf"

echo "creating http-health-checks"
gcloud -q compute http-health-checks create ${google_backend_service} --description "Cloud Foundry Public Health Check" --timeout "5s" --check-interval "30s" --healthy-threshold "10" --unhealthy-threshold "2" --port 80 --request-path "/info" --host "api.${cf_domain}"

echo "creating target-pools"
gcloud -q compute target-pools create ${google_target_pool} --description "Cloud Foundry Public Target Pool" --region=${google_region} --health-check ${google_backend_service}

echo "creating forwarding-rules"
gcloud compute forwarding-rules create cf-http --description "Cloud Foundry HTTP Traffic" --ip-protocol TCP --ports=80 --target-pool ${google_target_pool} --address ${cf_ip} --region ${google_region} 

gcloud compute forwarding-rules create cf-https --description "Cloud Foundry HTTPS Traffic" --ip-protocol TCP --ports=443 --target-pool ${google_target_pool} --address ${cf_ip} --region ${google_region} 

gcloud compute forwarding-rules create cf-ssh --description "Cloud Foundry SSH Traffic" --ip-protocol TCP --ports=2222 --target-pool ${google_target_pool} --address ${cf_ip} --region ${google_region} 

gcloud compute forwarding-rules create cf-wss --description "Cloud Foundry WSS Traffic" --ip-protocol TCP --ports=4443 --target-pool ${google_target_pool} --address ${cf_ip} --region ${google_region} 


set -e
