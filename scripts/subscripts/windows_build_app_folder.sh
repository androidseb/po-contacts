#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "windows_build_app_folder started"

echo "Building the web app"
sh scripts/web_build.sh

mkdir -p bin/tmp_windows
cd bin/tmp_windows

echo "Creating a blank nwjs folder"
#create a blank nwjs folder under $NWJS_FOLDER_NAME
NWJS_FOLDER_NAME="nwjs-v0.44.5-win-x64"
NWJS_FILE_NAME=$NWJS_FOLDER_NAME".zip"
wget https://dl.nwjs.io/v0.44.5/$NWJS_FILE_NAME --continue
rm -rf $NWJS_FOLDER_NAME
unzip $NWJS_FILE_NAME

echo "Copying app data into the nwjs folder"
#copying app data into the nwjs folder
cp -r ../web/* $NWJS_FOLDER_NAME/
cp ../../resources/nwjs_package.json $NWJS_FOLDER_NAME/package.json
cp ../../po_contacts_flutter/android/app/src/main/ic_launcher-web.png $NWJS_FOLDER_NAME/
echo "To launch PO contacts, simply execute the \"nw.exe\" file inside this directory">$NWJS_FOLDER_NAME/README.txt

echo "Outputing the result in a dedicated folder"
#replacing the target folder with the newly built folder
OUTPUT_FOLDER_NAME="po-contacts"
rm -rf $OUTPUT_FOLDER_NAME
mv $NWJS_FOLDER_NAME $OUTPUT_FOLDER_NAME

echo "windows_build_app_folder completed"
