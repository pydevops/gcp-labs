#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../"/common/functions.sh

# local vars

# https://cloud.google.com/load-balancing/docs/network/setting-up-network
# create a network LB in steps

gcloud compute firewall-rules create ${NLB_FW_RULE} \
    --network ${NETWORK} \
    --source-ranges 0.0.0.0/0 \
    --target-tags ${NETWORK_TAG} --allow tcp:80

gcloud compute addresses create ${NLB_ADDRESS} \
    --region ${REGION}

gcloud compute http-health-checks create ${NLB_HC}

# create the target pool with health check
gcloud compute target-pools create ${TARGET_POOL} \
   --region ${REGION} --http-health-check ${NLB_HC}

# link the MIG with the target pool
gcloud compute instance-groups managed set-target-pools ${MIG_NAME} \
    --target-pools ${TARGET_POOL} --region ${REGION} 

# need a forwarding rule for forwarding traffic
gcloud compute forwarding-rules create ${NLB_FR_RULE} \
    --region ${REGION} \
    --ports 80 \
    --address ${NLB_ADDRESS} \
    --target-pool ${TARGET_POOL}
gcloud compute forwarding-rules describe ${NLB_FR_RULE} --region ${REGION}