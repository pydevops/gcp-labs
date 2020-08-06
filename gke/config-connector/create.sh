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

CLUSTER_NAME=cc-demo
REGION=us-west1
ZONE=us-west1-a
NETWORK=default
SUBNET=us-central1

gcloud beta container clusters create  $CLUSTER_NAME\
 --zone ${ZONE} \
 --network ${NETWORK} \
 --subnetwork ${SUBNET} \
 --release-channel stable --addons ConfigConnector \
 --preemptible \
 --workload-pool=$PROJECT_ID.svc.id.goog --enable-stackdriver-kubernetes

# Get the kubectl credentials for the GKE cluster.
gcloud container clusters get-credentials "$CLUSTER_NAME" --zone "$ZONE"
kubectl wait pod/configconnector-operator-0 -n configconnector-operator-system --for=condition=Initialized

# set up configconnector
kubectl apply -f configconnector.yaml
kubectl get crds --selector cnrm.cloud.google.com/managed-by-kcc=true

