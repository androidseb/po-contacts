#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "linux_build_app_deb_as_root started"

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

# Checking that we have exactly one argument
if [ $# -ne 1 ]
  then
    echo "Usage: linux_build_app_deb_as_root.sh user"
    exit
fi

echo "Checking the specified user exists"
#fail the script if the user doesn't exist
USER_NAME=$1
id -u $USER_NAME

echo "Building deb file"
cd bin/tmp_linux
DEB_ROOT_OUTPUT_FOLDER_NAME="pocontactsdeb"
DEB_OUTPUT_FILE="pocontactsdeb.deb"
chown root:root -R $DEB_ROOT_OUTPUT_FOLDER_NAME
dpkg -b $DEB_ROOT_OUTPUT_FOLDER_NAME
rm -rf $DEB_ROOT_OUTPUT_FOLDER_NAME
chown $USER_NAME $DEB_OUTPUT_FILE

echo "linux_build_app_deb_as_root completed"
