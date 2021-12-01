###########################################
# Project
###########################################
export PROJECT_ID=$(gcloud config get-value project)
export PROJECT_USER=$(gcloud config get-value core/account) # set current user
export PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")


###########################################
# GKE cluster
###########################################

export IDNS=${PROJECT_ID}.svc.id.goog # workflow identity domain
export MAN_CIDR=135.0.150.138/32

export GCP_REGION="us-central1" # CHANGEME (OPT)
export GCP_ZONE="us-central1-a" # CHANGEME (OPT)
export NETWORK_NAME="default"
export MACHINE_TYPE="e2-standard-4"
export PREEEMPTIBLE="--preemptible"
export CLUSTER_NAME="sandbox"

###########################################
# NAT GATEWAY 
###########################################

export NAT_GW_IP="nat-gw-ip"
export CLOUD_ROUTER_NAME="router-1"
export CLOUD_ROUTER_ASN="64523"
export NAT_GW_NAME="nat-gateway-1"
