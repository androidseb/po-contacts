#!/bin/bash
set -e

# The purpose of this script is to overwrite the local source code to update the Google oAuth client ID
# while reducing the risks of accidentally committing this to the repo

if [ -z "$POC_ANDROID_APP_GOOGLE_OAUTH_CLIENT_ID_DEBUG" ]; then
    echo "Missing env variable: POC_ANDROID_APP_GOOGLE_OAUTH_CLIENT_ID_DEBUG"
    exit 1
fi

if [ -z "$POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_ID" ]; then
    echo "Missing env variable: POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_ID"
    exit 1
fi

if [ -z "$POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_SECRET" ]; then
    echo "Missing env variable: POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_SECRET"
    exit 1
fi

cd $(git rev-parse --show-toplevel)

# mark the file as ignored by git indexing (changes will not be detected and committed)
# can be reversed with this command:
# git update-index --no-skip-worktree
git update-index --skip-worktree po_contacts_flutter/lib/assets/constants/google_oauth_client_id.dart

# overwrite the google oauth client id in the source code
echo "const POC_GOOGLE_OAUTH_CLIENT_ID = '$POC_ANDROID_APP_GOOGLE_OAUTH_CLIENT_ID_DEBUG';">po_contacts_flutter/lib/assets/constants/google_oauth_client_id.dart
echo "const POC_GOOGLE_OAUTH_CLIENT_ID_DESKTOP = '$POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_ID';">>po_contacts_flutter/lib/assets/constants/google_oauth_client_id.dart
echo "const POC_GOOGLE_OAUTH_CLIENT_SECRET = '$POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_SECRET';">>po_contacts_flutter/lib/assets/constants/google_oauth_client_id.dart
