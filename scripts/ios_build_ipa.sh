#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "Copying 'po_contacts_flutter' to 'bin/tmp'..."
rm -rf bin/tmp
rm -rf bin/web
cp -r po_contacts_flutter bin/tmp

cd bin/tmp

echo "Editing source file locally for ios..."
# Deleting all .web.dart files
find . -type f -name '*.web.dart' -delete

echo "Executing flutter build ios..."
flutter pub get
flutter build ios

echo "Building the iOS IPA file..."
cd ios
fastlane gym scheme:"Runner" export_method:"app-store"
mv Runner.ipa ../../ios_app.ipa

echo "iOS app successfully built under 'bin/ios_app.ipa'"
