#!/usr/bin/env bash

. env.sh

# gcloud compute routers nats delete $NAT_GW_NAME --router=$CLOUD_ROUTER_NAME
# gcloud compute routers delete $CLOUD_ROUTER_NAME 

gcloud beta container --project $PROJECT_ID clusters delete $CLUSTER_NAME \
    --zone $GCP_ZONE
