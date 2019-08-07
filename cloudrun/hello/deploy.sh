#!/usr/bin/env bash
PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../.."/common/functions.sh

gcloud beta run deploy $APP \
	--allow-unauthenticated \
	--image gcr.io/$PROJECT_ID/$APP:0.0.1 \
	--platform managed \
	--region us-central1 \
	--service-account ${SVC_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com
	# --set-env-vars "TARGET=CloudRun" \
