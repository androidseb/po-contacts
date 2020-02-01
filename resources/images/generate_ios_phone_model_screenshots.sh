#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

cd resources/images

PHONE_MODEL_FILE_NAME_PREFIX=$1
PHONE_MODEL_SCREEN_SIZE=$2

convert base_screenshots/phone_1.png -background '#f9ebd8' -crop 1080x1704+0+72 -resize 1242x1960 -gravity center -extent $PHONE_MODEL_SCREEN_SIZE "../AppleStore/screenshots/en-US/"$PHONE_MODEL_FILE_NAME_PREFIX"_1.png"
convert base_screenshots/phone_2.png -background '#f9ebd8' -crop 1080x1704+0+72 -resize 1242x1960 -gravity center -extent $PHONE_MODEL_SCREEN_SIZE "../AppleStore/screenshots/en-US/"$PHONE_MODEL_FILE_NAME_PREFIX"_2.png"
convert base_screenshots/phone_3.png -background '#f9ebd8' -crop 1080x1704+0+72 -resize 1242x1960 -gravity center -extent $PHONE_MODEL_SCREEN_SIZE "../AppleStore/screenshots/en-US/"$PHONE_MODEL_FILE_NAME_PREFIX"_3.png"
convert base_screenshots/phone_4.png -background '#f9ebd8' -crop 1080x1704+0+72 -resize 1242x1960 -gravity center -extent $PHONE_MODEL_SCREEN_SIZE "../AppleStore/screenshots/en-US/"$PHONE_MODEL_FILE_NAME_PREFIX"_4.png"
convert base_screenshots/phone_5.png -background '#f9ebd8' -crop 1080x1704+0+72 -resize 1242x1960 -gravity center -extent $PHONE_MODEL_SCREEN_SIZE "../AppleStore/screenshots/en-US/"$PHONE_MODEL_FILE_NAME_PREFIX"_5.png"
