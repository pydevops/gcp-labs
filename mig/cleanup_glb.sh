#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
set -x

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../"/common/functions.sh


gcloud compute forwarding-rules delete ${GLB_FW_RULE} --global
gcloud compute target-http-proxies delete ${TARGET_PROXY}
gcloud compute url-maps delete ${URL_MAP}
gcloud compute backend-services delete ${BE_SVC} --global 
gcloud compute health-checks delete ${GLB_HC}
gcloud compute addresses delete ${GLB_IP} --global
