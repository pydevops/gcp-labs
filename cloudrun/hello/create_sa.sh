#!/usr/bin/env bash
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../.."/common/functions.sh


gcloud iam service-accounts create ${SVC_ACCOUNT} \
	--display-name "Go Run Hello Service Account"

gcloud projects add-iam-policy-binding $PROJECT_ID \
	--member serviceAccount:${SVC_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com \
	--role roles/logging.logWriter

gcloud projects add-iam-policy-binding $PROJECT_ID \
	--member serviceAccount:${SVC_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com \
	--role roles/cloudtrace.agent