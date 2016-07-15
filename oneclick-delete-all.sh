#!/usr/bin/env bash
set -e

wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/ff6d2c369b595696f199d67e081a8ddf70e562d8/constants.sh
chmod 744 ./constants.sh
source ./constants.sh

ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine `gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :` 'gsutil cp gs://hd-labs-cfongcp/automation/teardown-cf.sh . && chmod 744 ./teardown-cf.sh && ./teardown-cf.sh'

gcloud compute ssh bosh-bastion --zone ${google_zone} --command "gsutil cp gs://hd-labs-cfongcp/automation/teardown-director.sh . && chmod 744 ./teardown-director.sh && ./teardown-director.sh"

gsutil cp gs://hd-labs-cfongcp/automation/teardown-infrastructure.sh . && chmod 744 ./teardown-infrastructure.sh && ./teardown-infrastructure.sh


echo "Deleteing DNS record set"
dns_zone_name="labs"
gcloud dns record-sets transaction start -z ${dns_zone_name}
cf_address=`gcloud compute addresses describe cf | grep ^address: | cut -f2 -d' '`
gcloud dns record-sets transaction remove --name *.labs.homedepot.com. --ttl 300 --type A ${cf_address} -z ${dns_zone_name}
gcloud dns record-sets transaction execute -z ${dns_zone_name}

echo "Successfully deleted bosh director, cloud foundry and GCP components"

set -e