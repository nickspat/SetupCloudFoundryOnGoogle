#!/usr/bin/env bash
set -e

wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/ff6d2c369b595696f199d67e081a8ddf70e562d8/constants.sh
chmod 744 ./constants.sh
source ./constants.sh

ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine `gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :` 'wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/bc2d0ea0d037f0d1d73dd932d4541f1b4f6eae29/teardown-cf.sh && chmod 744 ./teardown-cf.sh && ./teardown-cf.sh'

gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/bc2d0ea0d037f0d1d73dd932d4541f1b4f6eae29/teardown-director.sh && chmod 744 ./teardown-director.sh && ./teardown-director.sh"

wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/bc2d0ea0d037f0d1d73dd932d4541f1b4f6eae29/teardown-infrastructure.sh && chmod 744 ./teardown-infrastructure.sh && ./teardown-infrastructure.sh

echo "Successfully deleted bosh director, cloud foundry and GCP components"

set -e