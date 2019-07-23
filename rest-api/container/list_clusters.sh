#!/bin/bash
#set -x
project_id=$(gcloud config get-value core/project)
zone_default=$(gcloud config get-value compute/zone)
zone=${1:-$zone_default}
TOKEN=$(gcloud config config-helper --format='value(credential.access_token)')
curl -s -X GET \
-H "Content-Type: application/json"  \
-H "Authorization: Bearer $TOKEN" \
https://container.googleapis.com/v1/projects/${project_id}/zones/${zone}/clusters