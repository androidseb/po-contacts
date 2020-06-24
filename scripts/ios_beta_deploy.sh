#!/bin/bash
set -e

if [ -z "$POC_IOS_APP_GOOGLE_OAUTH_CLIENT_ID" ]; then
    echo "Missing env variable: POC_IOS_APP_GOOGLE_OAUTH_CLIENT_ID"
    exit 1
fi

if [ -z "$POC_IOS_APP_GOOGLE_OAUTH_REVERSED_CLIENT_ID" ]; then
    echo "Missing env variable: POC_IOS_APP_GOOGLE_OAUTH_REVERSED_CLIENT_ID"
    exit 1
fi

cd $(git rev-parse --show-toplevel)

sh scripts/subscripts/deploy_ios_app_update.sh beta
