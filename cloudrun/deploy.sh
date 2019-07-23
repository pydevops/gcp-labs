#!/usr/bin/env bash
gcloud builds submit --tag gcr.io/${GCLOUD_PROJECT}/helloworld
gcloud beta run deploy --image gcr.io/${GCLOUD_PROJECT}/helloworld --platform managed
