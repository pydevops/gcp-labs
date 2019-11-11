#!/usr/bin/env bash
set -o errexit
set -o pipefail

if [ -z "$1" ]
  then
    echo "Usage: $0 <bucket_name>"
    exit 1
fi

# For one project only
# Please make sure to run `gcloud config set project <project_id> first`
command -v gsutil >/dev/null 2>&1 || \
  { echo >&2 "I require gcloud but it's not installed. Aborting.";exit 1; }

BUCKET=$1
gsutil lifecycle set lifecycle.json gs://$BUCKET

gsutil lifecycle get gs://$BUCKET