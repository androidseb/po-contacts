#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "Editing source file locally for the web..."
sed -i 's/import.*.mobile\.dart.*//g' po_contacts_flutter/lib/controller/platform/platform_specific_controller.dart
sed -i 's/\ \ \ \ if\ (dart\.library\.io)/import/g' po_contacts_flutter/lib/controller/platform/platform_specific_controller.dart
echo "Executing flutter build web..."
cd po_contacts_flutter
flutter build web
echo "Build successfull!"

