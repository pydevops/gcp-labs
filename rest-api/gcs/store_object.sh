#!/usr/bin/env bash
set -x
urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

bucket=${1:-influxdb-backup-restore}
prefix=${2:-backup/upload.manifest}
url=$(urlencode $prefix)
echo $url
project_id=$(gcloud config get-value core/project)
zone=$(gcloud config get-value compute/zone)
TOKEN=$(gcloud config config-helper --format='value(credential.access_token)')
curl -v -X POST \
--data-binary @upload.manifest \
-H "Content-Type: application/json"  \
-H "Authorization: Bearer $TOKEN" \
https://www.googleapis.com/upload/storage/v1/b/${bucket}/o?name=${prefix}&uploadType=json