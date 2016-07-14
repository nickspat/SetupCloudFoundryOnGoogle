#!/usr/bin/env bash
set -e

gsutil cp gs://hd-labs-cfongcp/automation/constants.sh .
chmod 744 ./constants.sh
source ./constants.sh

echo "-----------Setting up Infrastructure for BOSH director and Cloud Foundry----------------"
gsutil cp gs://hd-labs-cfongcp/automation/setup-infrastructure.sh . && chmod 744 ./setup-infrastructure.sh && ./setup-infrastructure.sh

gcloud compute ssh bosh-bastion --zone ${google_zone} --command "gsutil cp gs://hd-labs-cfongcp/automation/setup-director.sh . && chmod 744 ./setup-director.sh && ./setup-director.sh"

ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine `gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :` 'gsutil cp gs://hd-labs-cfongcp/automation/setup-cf.sh . && chmod 744 ./setup-cf.sh && ./setup-cf.sh'

dns_zone_name="labs"

echo "Setting dns record set"
gcloud dns record-sets transaction start -z ${dns_zone_name}
cf_address=`gcloud compute addresses describe cf | grep ^address: | cut -f2 -d' '`
gcloud dns record-sets transaction add --name *.labs.homedepot.com. --ttl 300 --type A ${cf_address} -z ${dns_zone_name}
gcloud dns record-sets transaction execute -z ${dns_zone_name}

echo "Use CF CLI to login ...."
echo "cf login -a https://api.${cf_domain} -u admin -p c1oudc0w --skip-ssl-validation"

set -e