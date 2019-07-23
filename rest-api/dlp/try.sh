#!/usr/bin/env bash
set -x
TOKEN=$(gcloud config config-helper --format='value(credential.access_token)')
#TOKEN=$(gcloud auth print-access-token)
curl -s -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $TOKEN" \
  'https://dlp.googleapis.com/v2/infoTypes'