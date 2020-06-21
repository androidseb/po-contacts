#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "linux_build_app_deb started"

APP_VERSION=$(cat po_contacts_flutter/lib/assets/constants/app_version.dart|cut -d\' -f2|cut -d\+ -f1)
sh scripts/subscripts/linux_build_app_folder.sh
cd bin/tmp_linux
OUTPUT_FOLDER_PATH="po-contacts"
DEB_ROOT_OUTPUT_FOLDER_PATH="pocontactsdeb"
DEB_DEBIAN_OUTPUT_FOLDER_PATH=$DEB_ROOT_OUTPUT_FOLDER_PATH"/DEBIAN"
DEB_CONTROL_OUTPUT_FILE_PATH=$DEB_DEBIAN_OUTPUT_FOLDER_PATH"/control"
DEB_SHARE_OUTPUT_FOLDER_PATH=$DEB_ROOT_OUTPUT_FOLDER_PATH"/usr/share/pocontacts"
DEB_BIN_OUTPUT_FOLDER_PATH=$DEB_ROOT_OUTPUT_FOLDER_PATH"/usr/bin"
DEB_BIN_OUTPUT_FILE_PATH=$DEB_BIN_OUTPUT_FOLDER_PATH"/pocontacts"
DEB_BIN_OUTPUT_FILE_CONTENT="/usr/share/pocontacts/nw"
DEB_DESKTOP_FILE_FOLDER_PATH=$DEB_ROOT_OUTPUT_FOLDER_PATH"/usr/share/applications"
DEB_DESKTOP_FILE_PATH=$DEB_DESKTOP_FILE_FOLDER_PATH"/pocontacts.desktop"
DEB_OUTPUT_FILE="pocontactsdeb.deb"

echo "Building deb package folder"
#build the result into a final distributable file
#process learned from there: https://senties-martinelli.com/articles/debian-packages
rm -rf $DEB_ROOT_OUTPUT_FOLDER_PATH
mkdir -p $DEB_SHARE_OUTPUT_FOLDER_PATH
mkdir -p $DEB_BIN_OUTPUT_FOLDER_PATH
mkdir -p $DEB_DEBIAN_OUTPUT_FOLDER_PATH
mkdir -p $DEB_DESKTOP_FILE_FOLDER_PATH
echo "Package: POContacts">$DEB_CONTROL_OUTPUT_FILE_PATH
echo "Version: "$APP_VERSION>>$DEB_CONTROL_OUTPUT_FILE_PATH
echo "Architecture: all">>$DEB_CONTROL_OUTPUT_FILE_PATH
echo "Maintainer: theandroidseb+pocontactssupport@gmail.com">>$DEB_CONTROL_OUTPUT_FILE_PATH
echo "Depends: libatomic1">>$DEB_CONTROL_OUTPUT_FILE_PATH
echo "Installed-Size: 100000">>$DEB_CONTROL_OUTPUT_FILE_PATH
echo "Homepage: https://pocontacts.app">>$DEB_CONTROL_OUTPUT_FILE_PATH
echo "Description: Privacy Oriented Contacts Manager">>$DEB_CONTROL_OUTPUT_FILE_PATH
echo " For a complete description, see the website: https://pocontacts.app">>$DEB_CONTROL_OUTPUT_FILE_PATH
cp -r $OUTPUT_FOLDER_PATH/* $DEB_SHARE_OUTPUT_FOLDER_PATH/
echo $DEB_BIN_OUTPUT_FILE_CONTENT>$DEB_BIN_OUTPUT_FILE_PATH
chmod 0755 $DEB_BIN_OUTPUT_FILE_PATH

echo "#!/usr/bin/env xdg-open">$DEB_DESKTOP_FILE_PATH
echo "">>$DEB_DESKTOP_FILE_PATH
echo "[Desktop Entry]">>$DEB_DESKTOP_FILE_PATH
echo "Version=1.0">>$DEB_DESKTOP_FILE_PATH
echo "Type=Application">>$DEB_DESKTOP_FILE_PATH
echo "Terminal=false">>$DEB_DESKTOP_FILE_PATH
echo "Exec=/usr/bin/pocontacts">>$DEB_DESKTOP_FILE_PATH
echo "Name=PO Contacts">>$DEB_DESKTOP_FILE_PATH
echo "Icon=/usr/share/pocontacts/ic_launcher-web.png">>$DEB_DESKTOP_FILE_PATH

sudo bash ../../scripts/subscripts/linux_build_app_deb_as_root.sh $(whoami)

echo "Moving the result file into bin/linux_app.deb"
rm -f ../linux_app.deb
mv $DEB_OUTPUT_FILE ../linux_app.deb

echo "Deleting temporary build files..."
cd $(git rev-parse --show-toplevel)
rm -rf bin/tmp
rm -rf bin/web

echo "linux_build_app_deb completed"
