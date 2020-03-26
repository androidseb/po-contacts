#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "windows_build_app_zip started"

sh scripts/subscripts/windows_build_app_folder.sh
cd bin/tmp_windows
OUTPUT_FOLDER_NAME="po-contacts"

echo "Zipping the result"
#zip the result into a final distributable file
zip -r windows_app.zip $OUTPUT_FOLDER_NAME

echo "Moving the result file into bin/windows_app.zip"
rm -f ../windows_app.zip
mv windows_app.zip ../

echo "windows_build_app_zip completed"
