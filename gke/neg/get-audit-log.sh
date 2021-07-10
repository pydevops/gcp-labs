#!/usr/bin/env bash
# "---------------------------------------------------------"
# "-                                                       -"
# "-  check audit log                          -"
# "-                                                       -"
# "---------------------------------------------------------"

set -euo pipefail


PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
source "$PROJECT_ROOT"/common/functions.sh

# get k8s.io audit log
# gcloud logging read  \
# "logName=projects/${PROJECT_ID}/logs/cloudaudit.googleapis.com%2Factivity AND protoPayload.serviceName="k8s.io" " \
# --limit 2 --freshness 300d

set -x
gcloud logging read  \
"logName=projects/${PROJECT_ID}/logs/cloudaudit.googleapis.com%2Factivity resource.type=k8s_cluster \
protoPayload.resourceName:certificates.k8s.io/v1beta1/certificatesigningrequests" \
--limit 2 --freshness 300d
