#!/usr/bin/env bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$PROJECT_ROOT"/env
source "$PROJECT_ROOT/../.."/common/functions.sh

# modules
go mod tidy
go mod vendor

# fake SHORT_SHA for testing
gcloud builds submit --config cloudbuild.yaml --substitutions=_SVC_ACCOUNT=${SVC_ACCOUNT},SHORT_SHA=12345 .