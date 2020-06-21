#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "linux_build_app_zip started"

sh scripts/subscripts/linux_build_app_folder.sh
cd bin/tmp_linux
OUTPUT_FOLDER_NAME="po-contacts"

echo "Zipping the result"
#zip the result into a final distributable file
zip -r linux_app.zip $OUTPUT_FOLDER_NAME

echo "Moving the result file into bin/linux_app.zip"
rm -f ../linux_app.zip
mv linux_app.zip ../

echo "Deleting temporary build files..."
cd $(git rev-parse --show-toplevel)
rm -rf bin/tmp
rm -rf bin/web

echo "linux_build_app_zip completed"
