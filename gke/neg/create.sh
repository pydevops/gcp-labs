#!/usr/bin/env bash
# "---------------------------------------------------------"
# "-                                                       -"
# "-  Create starts a GKE Cluster                          -"
# "-                                                       -"
# "---------------------------------------------------------"

set -o errexit
set -o nounset
set -o pipefail
set -x


PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
source "$PROJECT_ROOT"/common/functions.sh

export GCP_REGION="us-west1"
export GKE_CLUSTER_NAME="west1-001"
export GKE_CLUSTER_CHANNEL="None"
export NETWORK_NAME="ignw-pod"


# enable APIs
gcloud services enable compute.googleapis.com \
    container.googleapis.com

# create cluster
gcloud container --project $PROJECT_ID clusters create $GKE_CLUSTER_NAME \
    --region $GCP_REGION \
    --num-nodes 1 \
    --enable-ip-alias \
    --release-channel $GKE_CLUSTER_CHANNEL

gcloud container clusters get-credentials "$GKE_CLUSTER_NAME" --region $GCP_REGION
