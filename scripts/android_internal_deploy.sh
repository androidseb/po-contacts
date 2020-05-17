#!/bin/bash
set -e

if [ -z "$POC_ANDROID_APP_GOOGLE_OAUTH_CLIENT_ID" ]; then
    echo "Missing env variable: POC_ANDROID_APP_GOOGLE_OAUTH_CLIENT_ID"
    exit 1
fi

cd $(git rev-parse --show-toplevel)

sh scripts/subscripts/deploy_android_app_update.sh internal
