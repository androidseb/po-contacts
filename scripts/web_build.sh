#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

if [ -z "$POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_ID" ]; then
    echo "Missing env variable: POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_ID"
    exit 1
fi

echo "web_build started"

echo "Copying 'po_contacts_flutter' to 'bin/tmp'..."
rm -rf bin/tmp
rm -rf bin/web
cp -r po_contacts_flutter bin/tmp
echo "const POC_GOOGLE_OAUTH_CLIENT_ID = '$POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_ID';">bin/tmp/lib/assets/constants/google_oauth_client_id.dart
echo "const POC_GOOGLE_OAUTH_CLIENT_ID_DESKTOP = '$POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_ID';">>bin/tmp/lib/assets/constants/google_oauth_client_id.dart
echo "const POC_GOOGLE_OAUTH_CLIENT_SECRET_DESKTOP = '$POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_SECRET';">>bin/tmp/lib/assets/constants/google_oauth_client_id.dart

cd bin/tmp

echo "Editing source file locally for the web..."
# Deleting all .mobile.dart files
find . -type f -name '*.mobile.dart' -delete

echo "Executing flutter build web..."
flutter pub get
flutter build web

cd $(git rev-parse --show-toplevel)
mv bin/tmp/build/web bin/web

echo "Web app successfully built under 'bin/web'"
echo "web_build completed"
