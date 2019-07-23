#!/usr/bin/env bash
project_id=$(gcloud config get-value core/project)
TOKEN=$(gcloud config config-helper --format='value(credential.access_token)')
curl -s -X GET \
-H "Content-Type: application/json"  \
-H "Authorization: Bearer $TOKEN" https://www.googleapis.com/compute/v1/projects/${project_id}/zones
