#!/usr/bin/env bash
set -eu


# GCP project name
PROJECT=$(gcloud config get-value project)

gcloud beta run deploy helloworld \
	--allow-unauthenticated \
	--image gcr.io/$PROJECT/helloworld:0.0.1 \
	--platform managed \
	--region us-central1 \
	--set-env-vars "TARGET=CloudRun" \
	--service-account helloworld-sa@${PROJECT}.iam.gserviceaccount.com
