#!/usr/bin/env bash
set -e

if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi

wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/e70ca11bebba1d1de696f84e7d7a651c5da8f4ab/constants.sh
chmod 744 ./constants.sh
source ./constants.sh

echo "-----------Setting up Infrastructure for BOSH director and Cloud Foundry----------------"
wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/bc2d0ea0d037f0d1d73dd932d4541f1b4f6eae29/setup-infrastructure.sh && chmod 744 ./setup-infrastructure.sh && ./setup-infrastructure.sh

gcloud compute ssh bosh-bastion --zone ${google_zone} --command "wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/bc2d0ea0d037f0d1d73dd932d4541f1b4f6eae29/setup-director.sh && chmod 744 ./setup-director.sh && ./setup-director.sh"

ssh -t -o StrictHostKeyChecking=no -i ~/.ssh/google_compute_engine `gcloud compute instances describe bosh-bastion --zone ${google_zone} | grep natIP: | cut -f2 -d :` 'wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/bc2d0ea0d037f0d1d73dd932d4541f1b4f6eae29/setup-cf.sh && chmod 744 ./setup-cf.sh && ./setup-cf.sh'

echo "Use CF CLI to login ...."
echo "cf login -a https://api.${cf_domain} -u admin -p c1oudc0w --skip-ssl-validation"

set -e