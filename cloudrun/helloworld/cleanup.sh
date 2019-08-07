#!/bin/bash

# GCP project name
PROJECT=$(gcloud config get-value project)

gcloud beta run services delete helloworld \
    --platform managed \
    --region us-central1

gcloud iam service-accounts delete \
    helloworld-sa@${PROJECT}.iam.gserviceaccount.com