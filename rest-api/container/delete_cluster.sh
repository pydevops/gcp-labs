#!/bin/bash
#set -x
project_id=$(gcloud config get-value core/project)
zone=$(gcloud config get-value compute/zone)
cluster_name=${1:-demo}
TOKEN=$(gcloud config config-helper --format='value(credential.access_token)')
curl -s -X DELETE \
-H "Content-Type: application/json"  \
-H "Authorization: Bearer $TOKEN" \
https://container.googleapis.com/v1/projects/${project_id}/zones/${zone}/clusters/${cluster_name}