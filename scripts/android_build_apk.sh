#!/bin/bash
set -e

if [ -z "$POC_ANDROID_APP_GOOGLE_OAUTH_CLIENT_ID_PRODUCTION" ]; then
    echo "Missing env variable: POC_ANDROID_APP_GOOGLE_OAUTH_CLIENT_ID_PRODUCTION"
    exit 1
fi

cd $(git rev-parse --show-toplevel)

echo "Copying 'po_contacts_flutter' to 'bin/tmp'..."
rm -rf bin/tmp
rm -rf bin/web
cp -r po_contacts_flutter bin/tmp
echo "const POC_GOOGLE_OAUTH_CLIENT_ID = '$POC_ANDROID_APP_GOOGLE_OAUTH_CLIENT_ID_PRODUCTION';">bin/tmp/lib/assets/constants/google_oauth_client_id.dart
echo "const POC_GOOGLE_OAUTH_CLIENT_SECRET = 'Not needed for this implementation';">>bin/tmp/lib/assets/constants/google_oauth_client_id.dart

cd bin/tmp

echo "Editing source file locally for android..."
# Deleting all .web.dart files
find . -type f -name '*.web.dart' -delete

echo "Executing flutter build apk..."
flutter pub get
flutter build apk
mv build/app/outputs/apk/release/app-release.apk ../android_app.apk

echo "Deleting temporary build files..."
cd $(git rev-parse --show-toplevel)
rm -rf bin/tmp

echo "Android app successfully built under 'bin/android_app.apk'"
