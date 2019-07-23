#!/usr/bin/env bash
project_id=$(gcloud config get-value core/project)
zone=$(gcloud config get-value compute/zone)
instance_name=${1:-demo}

TOKEN=$(gcloud config config-helper --format='value(credential.access_token)')
curl -s -X DELETE \
-H "Content-Type: application/json"  \
-H "Authorization: Bearer $TOKEN" \
https://www.googleapis.com/compute/v1/projects/${project_id}/zones/${zone}/instances/${instance_name}

