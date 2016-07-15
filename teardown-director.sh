#!/usr/bin/env bash
set -e

if [ -f ./constants.sh ]; then
    rm -rf ./constants.sh
fi
wget https://gist.githubusercontent.com/raw/77430d2958e6b5a012674edb64dd8ed6/constants.sh
chmod 744 ./constants.sh
source ./constants.sh

manifest_filename="director-manifest.yml"

echo "Deleting director ...."
/usr/bin/bosh-init delete ${PWD}/google-bosh-director/${manifest_filename}

echo "Deleting SSH Keys"
if [ -f /tmp/project_keys.pub ]
then
  rm -rf /tmp/project_keys.pub
fi

gcloud compute project-info describe | while read line
do
  if [[ $line == *"ssh-rsa"* ]]
  then
    if [[ $line != *"bosh"* ]]; then
      echo $line >> /tmp/project_keys.pub
  	fi
  fi
done

gcloud compute project-info add-metadata --metadata-from-file sshKeys=/tmp/project_keys.pub

echo "Deleting director was successful"

set -e