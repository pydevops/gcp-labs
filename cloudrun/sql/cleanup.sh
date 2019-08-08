#!/bin/bash

# GCP project name
PROJECT=$(gcloud config get-value project)

gcloud beta run services delete visitor \
    --platform managed \
    --region us-central1

gcloud iam service-accounts delete \
    sql-sa@${PROJECT}.iam.gserviceaccount.com