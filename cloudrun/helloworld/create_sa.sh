#!/bin/bash

# GCP project name
PROJECT=$(gcloud config get-value project)

gcloud iam service-accounts create helloworld-sa \
	--display-name "Go Run HelloWorld Service Account"

gcloud projects add-iam-policy-binding $PROJECT \
	--member serviceAccount:helloworld-sa@${PROJECT}.iam.gserviceaccount.com \
	--role roles/logging.logWriter

gcloud projects add-iam-policy-binding $PROJECT \
	--member serviceAccount:helloworld-sa@${PROJECT}.iam.gserviceaccount.com \
	--role roles/cloudtrace.agent