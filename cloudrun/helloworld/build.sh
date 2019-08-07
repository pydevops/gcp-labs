#!/bin/bash

# GCP project name
PROJECT_ID=$(gcloud config get-value project)

# modules
go mod tidy
go mod vendor

gcloud builds submit --tag gcr.io/$PROJECT_ID/helloworld:0.0.1 .
