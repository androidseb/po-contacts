#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "Copying 'po_contacts_flutter' to 'bin/tmp'..."
rm -rf bin/tmp
rm -rf bin/web
cp -r po_contacts_flutter bin/tmp

cd bin/tmp

echo "Editing source file locally for the web..."
# Deleting all .mobile.dart files
find . -type f -name '*.mobile.dart' -delete
# Replacing the conditional import in lib/controller/platform/platform_specific_controller.dart to only consider the web
sed -i '' 's/import.*.mobile\.dart.*//g' lib/controller/platform/platform_specific_controller.dart
sed -i '' 's/\ \ \ \ if\ (dart\.library\.io)/import/g' lib/controller/platform/platform_specific_controller.dart
echo "Executing flutter build web..."
flutter pub get
flutter build web

cd $(git rev-parse --show-toplevel)
mv bin/tmp/build/web bin/web
rm -rf bin/tmp

echo "Web app successfully built under 'bin/web'"
