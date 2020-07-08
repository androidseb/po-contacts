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

echo "Copying 'po_contacts_flutter' to 'bin/tmp'..."
rm -rf bin/tmp
rm -rf bin/web
cp -r po_contacts_flutter bin/tmp
echo "const POC_GOOGLE_OAUTH_CLIENT_ID = 'Not needed for this implementation';">bin/tmp/lib/assets/constants/google_oauth_client_id.dart
echo "const POC_GOOGLE_OAUTH_CLIENT_ID_DESKTOP = '$POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_ID';">>bin/tmp/lib/assets/constants/google_oauth_client_id.dart
echo "const POC_GOOGLE_OAUTH_CLIENT_SECRET_DESKTOP = '$POC_DESKTOP_APP_GOOGLE_OAUTH_CLIENT_SECRET';">>bin/tmp/lib/assets/constants/google_oauth_client_id.dart

cd bin/tmp

echo "Editing source file locally for ios..."
# Deleting all .web.dart files
find . -type f -name '*.web.dart' -delete
# Injecting Google oAuth reverse client ID into ios/Runner/Info.plist
sed -i -e "s/SCRIPT_WILL_INSERT_REVERSED_CLIENT_ID_HERE/$POC_IOS_APP_GOOGLE_OAUTH_REVERSED_CLIENT_ID/" ios/Runner/Info.plist
# Injecting Google oAuth client ID into ios/Runner/GoogleService-Info.plist
sed -i -e "s/SCRIPT_WILL_INSERT_CLIENT_ID_HERE/$POC_IOS_APP_GOOGLE_OAUTH_CLIENT_ID/" ios/Runner/GoogleService-Info.plist
# Injecting Google oAuth reverse client ID into ios/Runner/GoogleService-Info.plist
sed -i -e "s/SCRIPT_WILL_INSERT_REVERSED_CLIENT_ID_HERE/$POC_IOS_APP_GOOGLE_OAUTH_REVERSED_CLIENT_ID/" ios/Runner/GoogleService-Info.plist

echo "Executing flutter build ios..."
flutter pub get
flutter build ios

echo "Building the iOS IPA file..."
cd ios
fastlane gym scheme:"Runner" export_method:"app-store"
mv Runner.ipa ../../ios_app.ipa

echo "Deleting temporary build files..."
cd $(git rev-parse --show-toplevel)
rm -rf bin/tmp

echo "iOS app successfully built under 'bin/ios_app.ipa'"
