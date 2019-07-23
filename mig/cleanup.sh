#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env


function dependency_installed () {
  command -v "${1}" >/dev/null 2>&1
}

# Ensure the necessary dependencies are installed
if ! dependency_installed "gcloud"; then
  echo "I require gcloud but it's not installed. Aborting."
  exit 1
fi


# Verify the instance template is created for worker
if ! gcloud compute instance-templates list --filter="name:${INSTANCE_TEMPLATE}"; then
  echo "Instance Template: ${INSTANCE_TEMPLATE} is not created, Aborting"
  exit 1
fi

if ! gcloud compute instance-groups managed list --filter="name:${MIG_NAME}"; then 
 echo "MIG:${MIG_NAME} is not created, Aborting"
  exit 2
fi


if ! gcloud compute health-checks list --filter="name:${HC_NAME}"; then 
 echo "healthcheck:${HC_NAME} is not created, Aborting"
  exit 3
fi

if ! gcloud compute firewall-rules list --filter="name:${FW_NAME}"; then 
 echo "firewall ruls:${FW_NAME} is not created, Aborting"
  exit 4
fi

# now, time to delete them
gcloud compute instance-groups managed delete ${MIG_NAME} --region $REGION
gcloud compute instance-templates delete ${INSTANCE_TEMPLATE}

gcloud compute health-checks delete ${HC_NAME}
gcloud compute firewall-rules delete ${FW_NAME}