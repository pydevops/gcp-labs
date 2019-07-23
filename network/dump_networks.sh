#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail
# For one project only
# Please make sure to run `gcloud config set project <project_id> first`
command -v gcloud >/dev/null 2>&1 || \
  { echo >&2 "I require gcloud but it's not installed. Aborting.";exit 1; }

PROJECT_ID=$(gcloud config list project --format 'value(core.project)')
if [ -z "${PROJECT_ID}" ]
  then echo >&2 "I require default project is set but it's not. Aborting."; exit 1;
fi

OUT=$PROJECT_ID.txt
cat /dev/null > $OUT
echo "**networks**" >> $OUT
gcloud compute networks list >> $OUT
echo "**subnets**" >> $OUT
gcloud compute networks subnets list --sort-by=NETWORK >> $OUT
echo "**routes**" >> $OUT
gcloud compute routes list --sort-by=NETWORK  >> $OUT
echo "**firewall-rules**" >> $OUT
gcloud compute firewall-rules list --sort-by=NETWORK >> $OUT
echo "##Please send the content of $OUT to us, thanks!##"