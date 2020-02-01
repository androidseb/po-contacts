#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

cd resources/images

TABLET_MODEL_FILE_NAME_PREFIX=$1
TABLET_MODEL_SCREEN_SIZE=$2

convert base_screenshots/tablet_1.png -background '#f9ebd8' -crop 2560x1640+0+48 -resize 2732x1750 -gravity center -extent $TABLET_MODEL_SCREEN_SIZE "../AppleStore/screenshots/en-US/"$TABLET_MODEL_FILE_NAME_PREFIX"_1.png"
convert base_screenshots/tablet_2.png -background '#f9ebd8' -crop 2560x1640+0+48 -resize 2732x1750 -gravity center -extent $TABLET_MODEL_SCREEN_SIZE "../AppleStore/screenshots/en-US/"$TABLET_MODEL_FILE_NAME_PREFIX"_2.png"
convert base_screenshots/tablet_3.png -background '#f9ebd8' -crop 2560x1640+0+48 -resize 2732x1750 -gravity center -extent $TABLET_MODEL_SCREEN_SIZE "../AppleStore/screenshots/en-US/"$TABLET_MODEL_FILE_NAME_PREFIX"_3.png"
convert base_screenshots/tablet_4.png -background '#f9ebd8' -crop 2560x1640+0+48 -resize 2732x1750 -gravity center -extent $TABLET_MODEL_SCREEN_SIZE "../AppleStore/screenshots/en-US/"$TABLET_MODEL_FILE_NAME_PREFIX"_4.png"
convert base_screenshots/tablet_5.png -background '#f9ebd8' -crop 2560x1640+0+48 -resize 2732x1750 -gravity center -extent $TABLET_MODEL_SCREEN_SIZE "../AppleStore/screenshots/en-US/"$TABLET_MODEL_FILE_NAME_PREFIX"_5.png"
