#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

CURRENT_VERSION_LINE=$(cat po_contacts_flutter/pubspec.yaml|grep version:)
CURRENT_VERSION_STRING=$(echo $CURRENT_VERSION_LINE|cut -d\  -f2|cut -d+ -f1)
CURRENT_VERSION_CODE=$(echo $CURRENT_VERSION_LINE|cut -d\  -f2|cut -d+ -f2)
NEW_VERSION_CODE=$(( $CURRENT_VERSION_CODE + 1 ))
NEW_VERSION_STRING=$CURRENT_VERSION_STRING"+"$NEW_VERSION_CODE
NEW_VERSION_LINE=$(echo "version: "$NEW_VERSION_STRING)
V1=$(echo $CURRENT_VERSION_STRING|cut -d\. -f1)
V2=$(echo $CURRENT_VERSION_STRING|cut -d\. -f2)
V3=$(echo $CURRENT_VERSION_STRING|cut -d\. -f3)
SED_REPLACE_STR=$(echo "\'s/version\: "$V1"\."$V2"\."$V3"\+"$NEW_VERSION_CODE"/"$NEW_VERSION_LINE"/g\'")

sed -i s/version\:.*/"$NEW_VERSION_LINE"/g po_contacts_flutter/pubspec.yaml
echo "const PO_APP_VERSION = '"$NEW_VERSION_STRING"';">po_contacts_flutter/lib/app_version.dart

git add po_contacts_flutter/pubspec.yaml
git add po_contacts_flutter/lib/app_version.dart

git commit -m "$NEW_VERSION_LINE"
git push
