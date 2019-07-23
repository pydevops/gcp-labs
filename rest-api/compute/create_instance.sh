#!/usr/bin/env bash
set -e
export project_id=$(gcloud config get-value core/project)
export project_number=$(gcloud projects list --filter="${project_id}"  --format='value(PROJECT_NUMBER)')
export zone=$(gcloud config get-value compute/zone)
export region=$(gcloud config get-value compute/region)

export instance_name=${1:-default}
export custom_network=${2:-default}
export custom_subnet=${3:-default}

export disk_name=${instance_name}
export machine_type="projects/${project_id}/zones/${zone}/machineTypes/n1-standard-1"
export latest_debian_image=$(gcloud compute images list --filter=debian-9 --format='value(NAME)')
export machine_image="projects/debian-cloud/global/images/${latest_debian_image}"
export network="projects/${project_id}/global/networks/${custom_network}"
export subnet="projects/${project_id}/regions/${region}/subnetworks/${custom_subnet}"

# OSX instruction for envsubst
# brew install gettext
# brew link --force gettext
envsubst < insert_template.json  > /tmp/insert.json

TOKEN=$(gcloud config config-helper --format='value(credential.access_token)')
curl -s -X POST \
-H "Content-Type: application/json"  \
-H "Authorization: Bearer $TOKEN" \
https://www.googleapis.com/compute/v1/projects/${project_id}/zones/${zone}/instances \
-d @/tmp/insert.json

echo "insert instance api status=$?"
envsubst < firewall_rule_template.json  > /tmp/firewall_rule.json
# add firewall rule
curl -s -X POST \
-H "Content-Type: application/json"  \
-H "Authorization: Bearer $TOKEN" \
https://www.googleapis.com/compute/v1/projects/${project_id}/global/firewalls \
-d @/tmp/firewall_rule.json
echo "insert firewall api status=$?"

# dump log for studying the request json
# function gce-create() {
#   GCE_SCOPES=default="https://www.googleapis.com/auth/cloud.useraccounts.readonly","https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write"
#   GCE_IMAGE="https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-8-jessie-v20180109"
#   GCE_POLICY=MIGRATE
#   GCE_ZONE=us-central1-f
#   GCE_TYPE=f1-micro
#   GCE_NETWORK=dev-network
#   GCE_SUBNETWORK=dev-subnet
#
#   gcloud compute instances create $1 --scopes ${GCE_SCOPES} --image ${GCE_IMAGE} --zone ${GCE_ZONE} --machine-type ${GCE_TYPE} \
#   --network ${GCE_NETWORK} --subnet ${GCE_SUBNETWORK} --log-http 2>create_instance.log
# }
#
# gce-create $instance_name
