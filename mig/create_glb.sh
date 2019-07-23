#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../"/common/functions.sh

# local vars

# https://cloud.google.com/load-balancing/docs/https/content-based-example
# https://cloud.google.com/load-balancing/docs/https/cross-region-example

#Create IPv4 global address
gcloud compute addresses create ${GLB_IP} \
    --ip-version=IPV4 \
    --global

GLOBAL_IP=$(gcloud compute addresses list --filter "name:${GLB_IP}" --format "value(address)")
echo $GLOBAL_IP

gcloud compute instance-groups set-named-ports ${MIG_NAME} --named-ports http-port:80 --region ${REGION}

gcloud compute health-checks create http ${GLB_HC} \
    --port 80

gcloud compute backend-services create ${BE_SVC} \
    --protocol HTTP \
    --port-name http-port \
    --health-checks ${GLB_HC} \
    --global

gcloud compute backend-services add-backend ${BE_SVC} \
    --balancing-mode UTILIZATION \
    --max-utilization 0.8 \
    --capacity-scaler 1 \
    --instance-group ${MIG_NAME} \
    --instance-group-region ${REGION}  \
    --global

gcloud compute url-maps create ${URL_MAP} \
    --default-service ${BE_SVC}

gcloud compute target-http-proxies create ${TARGET_PROXY} \
    --url-map ${URL_MAP}

gcloud compute forwarding-rules create ${GLB_FW_RULE} \
    --address ${GLOBAL_IP} \
    --global \
    --target-http-proxy ${TARGET_PROXY}  \
    --ports 80
