#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

security unlock-keychain ~/Library/Keychains/login.keychain
cd po_contacts_flutter
flutter pub get
cd ios
pod install
cd ..
cd $(git rev-parse --show-toplevel)
cd scripts
sh ios_buid_ipa.sh
fastlane platform:ios $1
