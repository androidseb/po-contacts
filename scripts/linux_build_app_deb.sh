#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "linux_build_app_deb started"

APP_VERSION=$(cat po_contacts_flutter/lib/app_version.dart|cut -d\' -f2|cut -d\+ -f1)
sh scripts/subscripts/linux_build_app_folder.sh
cd bin/tmp_linux
OUTPUT_FOLDER_NAME="po-contacts"
DEB_ROOT_OUTPUT_FOLDER_NAME="pocontactsdeb"
DEB_DEBIAN_OUTPUT_FOLDER_NAME=$DEB_ROOT_OUTPUT_FOLDER_NAME"/DEBIAN"
DEB_CONTROL_OUTPUT_FILE_NAME=$DEB_DEBIAN_OUTPUT_FOLDER_NAME"/control"
DEB_SHARE_OUTPUT_FOLDER_NAME=$DEB_ROOT_OUTPUT_FOLDER_NAME"/usr/share/pocontacts"
DEB_BIN_OUTPUT_FOLDER_NAME=$DEB_ROOT_OUTPUT_FOLDER_NAME"/usr/bin"
DEB_BIN_OUTPUT_FILE_NAME=$DEB_BIN_OUTPUT_FOLDER_NAME"/pocontacts"
DEB_BIN_OUTPUT_FILE_CONTENT="/usr/share/pocontacts/nw"
DEB_OUTPUT_FILE="pocontactsdeb.deb"

echo "Building deb package folder"
#build the result into a final distributable file
#process learned from there: https://senties-martinelli.com/articles/debian-packages
rm -rf $DEB_ROOT_OUTPUT_FOLDER_NAME
mkdir -p $DEB_SHARE_OUTPUT_FOLDER_NAME
mkdir -p $DEB_BIN_OUTPUT_FOLDER_NAME
mkdir -p $DEB_DEBIAN_OUTPUT_FOLDER_NAME
echo "Package: POContacts">$DEB_CONTROL_OUTPUT_FILE_NAME
echo "Version: "$APP_VERSION>>$DEB_CONTROL_OUTPUT_FILE_NAME
echo "Architecture: all">>$DEB_CONTROL_OUTPUT_FILE_NAME
echo "Maintainer: theandroidseb+pocontactssupport@gmail.com">>$DEB_CONTROL_OUTPUT_FILE_NAME
echo "Installed-Size: 100000">>$DEB_CONTROL_OUTPUT_FILE_NAME
echo "Homepage: https://github.com/androidseb/po-contacts">>$DEB_CONTROL_OUTPUT_FILE_NAME
echo "Description: Privacy Oriented Contacts Manager">>$DEB_CONTROL_OUTPUT_FILE_NAME
echo " For a complete description, see the website: https://github.com/androidseb/po-contacts">>$DEB_CONTROL_OUTPUT_FILE_NAME
cp -r $OUTPUT_FOLDER_NAME/* $DEB_SHARE_OUTPUT_FOLDER_NAME/
echo $DEB_BIN_OUTPUT_FILE_CONTENT>$DEB_BIN_OUTPUT_FILE_NAME
chmod 0755 $DEB_BIN_OUTPUT_FILE_NAME

sudo bash ../../scripts/subscripts/linux_build_app_deb_as_root.sh $(whoami)

echo "Moving the result file into bin/linux_app.deb"
rm -f ../linux_app.deb
mv $DEB_OUTPUT_FILE ../linux_app.deb

echo "linux_build_app_deb completed"
