#!/bin/bash

# GCP project name
PROJECT_ID=$(gcloud config get-value project)

# modules
go mod tidy
go mod vendor

gcloud builds submit --tag gcr.io/$PROJECT_ID/sql:0.0.1 .
