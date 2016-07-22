google_project=`gcloud compute project-info describe | grep ^name: | cut -f2 -d' '`

google_address_cf="cf"
gcloud config set project ${google_project}
gcloud config set compute/region ${google_region}
gcloud config set compute/zone ${google_zone}

director_ip="10.0.0.6"
google_network="cf"
google_subnetwork="bosh-"${google_region}
google_subnetwork_range="10.0.0.0/24"
cf_public_subnetwork="cf-public-"${google_region}
cf_public_subnet_range="10.200.0.0/16"
cf_private_subnetwork="cf-private-"${google_region}
cf_private_subnet_range="192.168.0.0/16"
google_firewall_internal="bosh-internal"
bosh_firewall="bosh-bastion"
cf_firewall_public="cf-public"
cf_firewall_internal="cf-internal"
google_target_pool="cf-public"
google_backend_service="cf-public"
#google_json_key_data="/tmp/cf-bosh.json"
director_password="admin"
director_username="admin"
private_key="${HOME}/.ssh/bosh"
