#!/usr/bin/env bash

set -o errexit
set -o nounset
PROJECT_ID=infra

bq --location=US mk \
--dataset \
--default_table_expiration 3600 \
--description description \
$PROJECT_ID:bigquerydatasetsample

# check
bq ls
bq show bigquerydatasetsample
stern -n cnrm-system cnrm-controller-manager-victory-0
