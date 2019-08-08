#!/usr/bin/env bash
set -eu


# GCP project name
PROJECT=$(gcloud config get-value project)

gcloud beta run deploy visitor \
	--allow-unauthenticated \
	--image gcr.io/$PROJECT/sql:0.0.1 \
	--platform managed \
	--region us-central1 \
	--set-env-vars "TARGET=CloudSQL,host=mydev-238905:us-central1:demo,db=test,user=app,password=passw0rd" \
	--service-account sql-sa@${PROJECT}.iam.gserviceaccount.com \
	--add-cloudsql-instances demo
