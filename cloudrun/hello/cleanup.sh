#!/usr/bin/env bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../.."/common/functions.sh

gcloud beta run services delete $APP \
    --platform managed \
    --region us-central1

gcloud iam service-accounts delete \
    ${SVC_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com