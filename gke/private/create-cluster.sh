#!/usr/bin/env bash

. env.sh

# enable apis
gcloud services enable \
    compute.googleapis.com \
    container.googleapis.com

# configure gcloud sdk
gcloud config set compute/region $GCP_REGION
gcloud config set compute/zone $GCP_ZONE

set -x
# create a sandboxed cluster
gcloud beta container clusters create $CLUSTER_NAME \
    --project $PROJECT_ID \
    --zone $GCP_ZONE \
    --release-channel "regular" \
    --num-nodes "1" \
    --machine-type $MACHINE_TYPE \
    --enable-ip-alias  \
    --enable-master-authorized-networks \
    --master-authorized-networks "$MAN_CIDR" \
    --enable-private-nodes \
    --master-ipv4-cidr "$MASTER_CIDR" \
    --enable-shielded-nodes \
    --shielded-secure-boot \
    --workload-pool=$IDNS \
    --preemptible

#--addons ConfigConnector \
# --enable-stackdriver-kubernetes \
 
export KUBECONFIG=$PWD/kubeconfig
gcloud container clusters get-credentials $CLUSTER_NAME --zone $GCP_ZONE 

# create cloud router and nat gateway
# gcloud compute routers create $CLOUD_ROUTER_NAME \
#     --network $NETWORK_NAME \
#     --asn $CLOUD_ROUTER_ASN \
#     --region $GCP_REGION

# gcloud compute routers nats create $NAT_GW_NAME \
#     --router=$CLOUD_ROUTER_NAME \
#     --region=$GCP_REGION \
#     --auto-allocate-nat-external-ips \
#     --nat-all-subnet-ip-ranges \
#     --enable-logging

# create IP address
#gcloud compute addresses create $NAT_GW_IP --region $GCP_REGION

# change to static IP (test)
# gcloud compute routers nats update $NAT_GW_NAME \
#     --router=$CLOUD_ROUTER_NAME \
#     --nat-external-ip-pool=$NAT_GW_IP
