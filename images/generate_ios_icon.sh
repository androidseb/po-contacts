#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

cd images

inkscape -f po_contacts_app_icon.svg -w $1 -h $1 -b FFFFFF --export-png=../po_contacts_flutter/ios/Runner/Assets.xcassets/AppIcon.appiconset/$2
