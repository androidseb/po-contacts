#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "macos_build_app_folder started"

echo "Building the web app"
sh scripts/web_build.sh

mkdir -p bin/tmp_macos
cd bin/tmp_macos

echo "Creating a blank nwjs folder"
#create a blank nwjs folder under $NWJS_FOLDER_NAME
NWJS_FOLDER_NAME="nwjs-v0.72.0-osx-x64"
NWJS_FILE_NAME=$NWJS_FOLDER_NAME".zip"
wget https://dl.nwjs.io/v0.72.0/$NWJS_FILE_NAME --continue
rm -rf $NWJS_FOLDER_NAME
unzip -q $NWJS_FILE_NAME

echo "Copying app data into the nwjs folder"
#copying app data into the nwjs folder
TARGET_RESOURCES_FOLDER=$NWJS_FOLDER_NAME/nwjs.app/Contents/Resources/
TARGET_RESOURCES_FOLDER_NW=$TARGET_RESOURCES_FOLDER/app.nw/
mkdir $TARGET_RESOURCES_FOLDER_NW
rm -rf $TARGET_RESOURCES_FOLDER/*.lproj
cp -r ../web/* $TARGET_RESOURCES_FOLDER_NW/
cp ../../resources/nwjs_package.json $TARGET_RESOURCES_FOLDER_NW/package.json
cp ../../resources/images/po_contacts_app_icon.icns $TARGET_RESOURCES_FOLDER/app.icns
cp ../../resources/MacOSAppInfo.plist $NWJS_FOLDER_NAME/nwjs.app/Contents/Info.plist
cp ../../resources/images/po_contacts_app_icon.icns $TARGET_RESOURCES_FOLDER/app.icns
cp ../../resources/images/po_contacts_app_icon.icns $TARGET_RESOURCES_FOLDER/document.icns

echo "Outputing the result in a dedicated folder"
#replacing the target folder with the newly built folder
OUTPUT_FOLDER_NAME="pocontacts.app"
rm -rf $OUTPUT_FOLDER_NAME
mv $NWJS_FOLDER_NAME/nwjs.app $OUTPUT_FOLDER_NAME

echo "macos_build_app_folder completed"
