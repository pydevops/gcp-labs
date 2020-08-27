#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT/../"/common/functions.sh
source "$PROJECT_ROOT"/env

SA=gitlab-runner-manager@$PROJECT.iam.gserviceaccount.com

# enable services
# gcloud services enable compute.googleapis.com \
# cloudbuild.googleapis.com \
# container.googleapis.com  containerregistry.googleapis.com \
# --project $PROJECT \

# # create SA, bind roles
# gcloud iam service-accounts create gitlab-runner-manager \
#     --description "Gitlab Runner Manager" \
#     --display-name "Gitlab Runner Manager" \
#     --project $PROJECT \

# gcloud projects  add-iam-policy-binding $PROJECT \
#   --project $PROJECT \
#   --member serviceAccount:$SA \
#   --role roles/storage.admin

# gcloud projects  add-iam-policy-binding $PROJECT \
# --project $PROJECT \
# --member serviceAccount:$SA \
# --role roles/cloudbuild.builds.editor

# gcloud projects  add-iam-policy-binding $PROJECT \
#   --project $PROJECT \
#   --member serviceAccount:$SA \
#   --role roles/viewer

# grant gcr.io
#gsutil iam ch serviceAccount:gitlab-runner-manager@$PROJECT.iam.gserviceaccount.com:objectViewer gs://artifacts.$PROJECT.appspot.com


# grant cloud build service account with container.viewer
gcloud projects  add-iam-policy-binding $PROJECT \
  --project $PROJECT \
  --member serviceAccount:$PROJECT_NUMBER@cloudbuild.gserviceaccount.com\
  --role roles/container.developer


# create gitlab runner
# gcloud compute instances create gitlab-runner-manager \
#   --image-family=debian-10 --image-project=debian-cloud \
#   --zone=$ZONE --machine-type=g1-small --tags gitlab-ci-master \
#   --network-interface=network=$NETWORK,subnet=$SUBNET \
#   --project $PROJECT \
#   --service-account=gitlab-runner-manager@$PROJECT.iam.gserviceaccount.com \
#   --scopes https://www.googleapis.com/auth/cloud-platform \
#   --metadata startup-script='#! /bin/bash
#  # Installs apache and a custom homepage
#   sudo su -
#   apt update
#   curl -LJO https://gitlab-runner-downloads.s3.amazonaws.com/latest/deb/gitlab-runner_amd64.deb
#   dpkg -i gitlab-runner_amd64.deb
#   EOF'
