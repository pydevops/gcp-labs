#!/usr/bin/env bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../.."/common/functions.sh

# modules
go mod tidy
go mod vendor

gcloud builds submit --tag gcr.io/$PROJECT_ID/$APP:0.0.1 .
