#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

security unlock-keychain ~/Library/Keychains/login.keychain
cd po_contacts_flutter
flutter pub get
cd ios
pod install
cd ..
flutter build ios
cd $(git rev-parse --show-toplevel)
cd scripts
fastlane platform:ios $1
