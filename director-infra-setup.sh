#!/usr/bin/env bash
source ./constants.sh

echo "create cf network and subnets"
gcloud -q compute networks create ${google_network} --mode custom
gcloud -q compute networks subnets create ${google_subnetwork} --network ${google_network} --range ${google_subnetwork_range} --region ${google_region} --description "Subnet for BOSH Director and bastion"

echo "create fire-wall rules"
gcloud -q compute firewall-rules create ${google_firewall_internal} --description "BOSH internal traffic" --network ${google_network} --source-tags ${google_firewall_internal} --target-tags ${google_firewall_internal} --allow tcp,udp,icmp
gcloud -q compute firewall-rules create ${bosh_firewall} --description "BOSH bastion" --network ${google_network} --target-tags ${bosh_firewall} --allow tcp:22,icmp


echo "creating bosh bastion server"
gcloud -q compute instances create bosh-bastion --image-family=ubuntu-1404-lts --image-project=ubuntu-os-cloud --subnet ${google_subnetwork} --private-network-ip 10.0.0.200 --tags bosh-bastion,bosh-internal --scopes cloud-platform --metadata "startup-script=apt-get update -y ; apt-get upgrade -y ; apt-get install -y build-essential zlibc zlib1g-dev ruby ruby-dev openssl libxslt-dev libxml2-dev libssl-dev libreadline6 libreadline6-dev libyaml-dev libsqlite3-dev sqlite3 ; gem install bosh_cli ; curl -o /usr/bin/bosh-init https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.94-linux-amd64; chmod +x /usr/bin/bosh-init; curl -o /tmp/cf.tgz https://s3.amazonaws.com/go-cli/releases/v6.19.0/cf-cli_6.19.0_linux_x86-64.tgz; tar -zxvf /tmp/cf.tgz && mv cf /usr/bin/cf && chmod +x /usr/bin/cf"
