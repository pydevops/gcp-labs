#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x

# Reference
# https://cloud.google.com/functions/docs/connecting-vpc
# https://medium.com/google-cloud/connecting-cloud-functions-with-compute-engine-using-serverless-vpc-access-79c5cd7420c7

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../"/common/functions.sh


enable_project_api ${PROJECT_ID} vpcaccess.googleapis.com

gcloud compute firewall-rules create allow-redis --network ${NETWORK} --allow tcp:6379
gcloud compute instances create-with-container redis-cache \
--machine-type=f1-micro \
--container-image=marketplace.gcr.io/google/redis4 \
--tags=allow-redis \
--zone=${ZONE} \
--network-interface=network=${NETWORK},subnet=${SUBNET},\
no-address,private-network-ip=10.0.50.9

gcloud beta compute networks vpc-access connectors create \
cache-connector \
--network ${NETWORK} \
--region us-central1 \
--range 172.16.16.240/28



gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcf-admin-robot.iam.gserviceaccount.com \
--role=roles/viewer

gcloud projects add-iam-policy-binding $PROJECT_ID \
--member=serviceAccount:service-$PROJECT_NUMBER@gcf-admin-robot.iam.gserviceaccount.com \
--role=roles/compute.networkUser

VPC_CONNECTOR=projects/${PROJECT_ID}/locations/us-central1/connectors/cache-connector

gcloud beta functions deploy random-cache --entry-point main \
--runtime python37 \
--trigger-http \
--region us-central1 \
--vpc-connector $VPC_CONNECTOR \
--set-env-vars REDIS_HOST=10.0.50.9
