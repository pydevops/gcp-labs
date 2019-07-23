#!/usr/bin/env bash
set -e
export project_id=$(gcloud config get-value core/project)
export zone=$(gcloud config get-value compute/zone)
export region=$(gcloud config get-value compute/region)

export cluster_name=${1:-demo}
export custom_network=${2:-default}
export custom_subnet=${3:-default}

export gke_version=1.10.7-gke.2
export node_pool_name="default-pool"
export machine_type="n1-standard-1"
export initial_node_count=2
# export network="${custom_network}"
# export subnet="${custom_subnet}"

# OSX instruction for envsubst
# brew install gettext
# brew link --force gettext
envsubst < insert_template.json  > /tmp/insert_cluster.json

TOKEN=$(gcloud config config-helper --format='value(credential.access_token)')
curl -s -X POST \
-H "Content-Type: application/json"  \
-H "Authorization: Bearer $TOKEN" \
https://container.googleapis.com/v1beta1/projects/${project_id}/zones/${zone}/clusters \
-d @/tmp/insert_cluster.json

echo "insert instance api status=$?"

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
