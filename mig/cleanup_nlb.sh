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

gcloud compute firewall-rules delete ${NLB_FW_RULE}
gcloud compute forwarding-rules delete ${NLB_FR_RULE} --region ${REGION} 
gcloud compute target-pools delete ${TARGET_POOL}
gcloud compute http-health-checks delete ${NLB_HC}
gcloud compute addresses delete ${NLB_ADDRESS}