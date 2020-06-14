#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "macos_build_app_zip started"

sh scripts/subscripts/macos_build_app_folder.sh
cd bin/tmp_macos
OUTPUT_FOLDER_NAME="pocontacts.app"

echo "Zipping the result"
#zip the result into a final distributable file
zip -q -r macos_app.zip $OUTPUT_FOLDER_NAME

echo "Moving the result file into bin/macos_app.zip"
rm -f ../macos_app.zip
mv macos_app.zip ../

echo "Deleting temporary build files..."
rm -rf bin/tmp
rm -rf bin/web

echo "macos_build_app_zip completed"
