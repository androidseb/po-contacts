#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo $APPLE_REVIEW_PHONE_NUMBER>resources/AppleStore/metadata/review_information/phone_number.txt
sh scripts/subscripts/deploy_ios_app_update.sh prod

