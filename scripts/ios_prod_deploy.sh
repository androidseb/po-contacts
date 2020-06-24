#!/bin/bash
set -e

if [ -z "$POC_APPLE_REVIEW_PHONE_NUMBER" ]; then
    echo "Missing env variable: POC_APPLE_REVIEW_PHONE_NUMBER"
    exit 1
fi

if [ -z "$POC_IOS_APP_GOOGLE_OAUTH_CLIENT_ID" ]; then
    echo "Missing env variable: POC_IOS_APP_GOOGLE_OAUTH_CLIENT_ID"
    exit 1
fi

if [ -z "$POC_IOS_APP_GOOGLE_OAUTH_REVERSED_CLIENT_ID" ]; then
    echo "Missing env variable: POC_IOS_APP_GOOGLE_OAUTH_REVERSED_CLIENT_ID"
    exit 1
fi

cd $(git rev-parse --show-toplevel)

echo $POC_APPLE_REVIEW_PHONE_NUMBER>resources/AppleStore/metadata/review_information/phone_number.txt
sh scripts/subscripts/deploy_ios_app_update.sh prod
