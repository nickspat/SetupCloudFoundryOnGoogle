#!/usr/bin/env bash

set -e

wget https://gist.github.com/nickspat/77430d2958e6b5a012674edb64dd8ed6/raw/ff6d2c369b595696f199d67e081a8ddf70e562d8/constants.sh
chmod 744 ./constants.sh
source ./constants.sh


deployment_dir="${PWD}/google-bosh-director"
if [ -d "${deployment_dir}" ]; then
  rm -rf ${deployment_dir}
fi
mkdir google-bosh-director
manifest_filename="director-manifest.yml"

gcloud config set project ${google_project}
gcloud config set compute/region ${google_region}
gcloud config set compute/zone ${google_zone}

if [ -f /tmp/project_keys.pub ]; then
    rm -rf /tmp/project_keys.pub
fi

gcloud compute project-info describe | while read line ; do
  if [[ $line == *"ssh-rsa"* ]]; then
    echo $line >> /tmp/project_keys.pub;
  fi
done

if [ ! -f ~/.ssh/bosh ]; then
  ssh-keygen -t rsa -f ~/.ssh/bosh -C bosh -N ""
fi

(echo -en "bosh:"; cat ~/.ssh/bosh.pub; ) | cat  >> /tmp/project_keys.pub

gcloud compute project-info add-metadata --metadata-from-file sshKeys=/tmp/project_keys.pub

cd google-bosh-director
echo "Creating ${manifest_filename}..."
zone=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/zone)
zone=${zone##*/}
region=${zone%-*}
gcloud config set compute/zone ${zone}
gcloud config set compute/region ${region}

cat > "${manifest_filename}"<<EOF
---
name: bosh

releases:
  - name: bosh
    url: https://bosh.io/d/github.com/cloudfoundry/bosh?v=256.2
    sha1: ff2f4e16e02f66b31c595196052a809100cfd5a8
  - name: bosh-google-cpi
    url: https://storage.googleapis.com/bosh-cpi-artifacts/bosh-google-cpi-20.tgz
    sha1: 9b4ada4267f1523f5d278e0813eb055e91ea15ed 

resource_pools:
  - name: vms
    network: private
    stemcell:
      url: https://storage.googleapis.com/bosh-cpi-artifacts/bosh-stemcell-3262.2-google-kvm-ubuntu-trusty-go_agent.tgz
      sha1: 3bdd94fdb7cf277346e6a4c5e54d10dfd8f2380d 
    cloud_properties:
      machine_type: n1-standard-4
      root_disk_size_gb: 40
      root_disk_type: pd-standard
      service_scopes:
        - compute
        - devstorage.full_control

disk_pools:
  - name: disks
    disk_size: 32_768
    cloud_properties:
      type: pd-standard

networks:
  - name: vip
    type: vip
  - name: private
    type: manual
    subnets:
    - range: 10.0.0.0/29
      gateway: 10.0.0.1
      static: [10.0.0.3-10.0.0.7]
      cloud_properties:
        network_name: cf
        subnetwork_name: bosh-{{REGION}}
        ephemeral_external_ip: true
        tags:
          - bosh-internal

jobs:
  - name: bosh
    instances: 1

    templates:
      - name: nats
        release: bosh
      - name: postgres
        release: bosh
      - name: powerdns
        release: bosh
      - name: blobstore
        release: bosh
      - name: director
        release: bosh
      - name: health_monitor
        release: bosh
      - name: google_cpi
        release: bosh-google-cpi

    resource_pool: vms
    persistent_disk_pool: disks

    networks:
      - name: private
        static_ips: [10.0.0.6]
        default:
          - dns
          - gateway

    properties:
      nats:
        address: 127.0.0.1
        user: nats
        password: nats-password

      postgres: &db
        listen_address: 127.0.0.1
        host: 127.0.0.1
        user: postgres
        password: postgres-password
        database: bosh
        adapter: postgres

      dns:
        address: 10.0.0.6
        domain_name: microbosh
        db: *db
        recursor: 169.254.169.254

      blobstore:
        address: 10.0.0.6
        port: 25250
        provider: dav
        director:
          user: director
          password: director-password
        agent:
          user: agent
          password: agent-password

      director:
        address: 127.0.0.1
        name: micro-google
        db: *db
        cpi_job: google_cpi
        user_management:
          provider: local
          local:
            users:
              - name: ${director_username}
                password: ${director_password}
              - name: hm
                password: hm-password
      hm:
        director_account:
          user: hm
          password: hm-password
        resurrector_enabled: true

      google: &google_properties
        project: {{PROJECT_ID}}
        default_zone: {{ZONE}}

      agent:
        mbus: nats://nats:nats-password@10.0.0.6:4222
        ntp: *ntp
        blobstore:
           options:
             endpoint: http://10.0.0.6:25250
             user: agent
             password: agent-password

      ntp: &ntp
        - 169.254.169.254

cloud_provider:
  template:
    name: google_cpi
    release: bosh-google-cpi

  ssh_tunnel:
    host: 10.0.0.6
    port: 22
    user: bosh
    private_key: {{SSH_KEY_PATH}}

  mbus: https://mbus:mbus-password@10.0.0.6:6868

  properties:
    google: *google_properties
    agent:
      mbus: https://mbus:mbus-password@0.0.0.0:6868
      blobstore:
        provider: local
        options:
          blobstore_path: /var/vcap/micro_bosh/data/cache
      ntp: *ntp
EOF

sed -i s#{{PROJECT_ID}}#`curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/project/project-id`# ${manifest_filename}
chmod 600 ${private_key}
sed -i s#{{SSH_KEY_PATH}}#${private_key}# ${manifest_filename}
sed -i s#{{REGION}}#$region# ${manifest_filename}
sed -i s#{{ZONE}}#$zone# ${manifest_filename}

pushd ${deployment_dir}
  function finish {
    echo "Final state of director deployment:"
    echo "=========================================="
    cat director-manifest-state.json
    echo "=========================================="

  }
  trap finish ERR

  echo -ne "Waiting for bosh-init to be available.."
  until /usr/bin/bosh-init -v | grep -m 1 "version"; do echo -ne "."; done

  echo "Deploying BOSH Director..."
  /usr/bin/bosh-init deploy ${manifest_filename}

  trap - ERR
  finish
popd