#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "Copying 'po_contacts_flutter' to 'bin/tmp'..."
rm -rf bin/tmp
rm -rf bin/web
cp -r po_contacts_flutter bin/tmp

cd bin/tmp

echo "Editing source file locally for android..."
# Deleting all .web.dart files
find . -type f -name '*.web.dart' -delete

echo "Executing flutter build apk..."
flutter pub get
flutter build apk
mv build/app/outputs/apk/release/app-release.apk ../android_app.apk

echo "Android app successfully built under 'bin/android_app.apk'"
