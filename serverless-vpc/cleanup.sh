#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../"/common/functions.sh

gcloud functions delete random-cache
gcloud beta compute networks vpc-access connectors delete cache-connector --region us-central1
gcloud compute instances delete redis-cache --zone ${ZONE}
gcloud compute firewall-rules delete allow-redis