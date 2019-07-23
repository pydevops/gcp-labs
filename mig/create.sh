#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../"/common/functions.sh


# create a regional private MIG running nginx container
# gcloud compute instance-templates create-with-container ${INSTANCE_TEMPLATE} \
#  --network ${NETWORK} --subnet ${SUBNET} --region ${REGION} \
#  --container-image ${CONTAINER_IMAGE} \
#  --machine-type ${MACHINE_TYPE} \
#  --no-address  \
#  --tags ${NETWORK_TAG}

# Verify the instance template is created for worker
if ! gcloud compute instance-templates list --filter="name:${INSTANCE_TEMPLATE}"; then
  echo "${INSTANCE_TEMPLATE} is not created, Aborting"
  exit 2
fi

# creaate a MIG with the template
# gcloud compute instance-groups managed create ${MIG_NAME} \
#   --region $REGION --template ${INSTANCE_TEMPLATE} \
#   --size $MIG_SIZE

# update MIG with rolling update
# gcloud compute instance-groups managed rolling-action start-update nginx1-mig --version template=${INSTANCE_TEMPLATE} --region ${REGION}

# create health check and firewall rules for auto healing
# gcloud compute health-checks create http ${HC_NAME} --port 80 \
#    --check-interval 30s \
#    --healthy-threshold 1 \
#    --timeout 10s \
#    --unhealthy-threshold 3

gcloud compute firewall-rules create ${FW_NAME}  \
   --allow tcp:80 \
   --source-ranges 130.211.0.0/22,35.191.0.0/16 \
   --target-tags ${NETWORK_TAG} \
   --network $NETWORK

# update the MIG with the health check policy
gcloud compute instance-groups managed update ${MIG_NAME}  \
    --health-check ${HC_NAME} \
    --initial-delay 300 \
    --region ${REGION}
