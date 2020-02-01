#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

cd resources/images

sh generate_ios_icon.sh 1024 Icon-App-1024x1024@1x.png
sh generate_ios_icon.sh 20 Icon-App-20x20@1x.png
sh generate_ios_icon.sh 40 Icon-App-20x20@2x.png
sh generate_ios_icon.sh 60 Icon-App-20x20@3x.png
sh generate_ios_icon.sh 29 Icon-App-29x29@1x.png
sh generate_ios_icon.sh 58 Icon-App-29x29@2x.png
sh generate_ios_icon.sh 87 Icon-App-29x29@3x.png
sh generate_ios_icon.sh 40 Icon-App-40x40@1x.png
sh generate_ios_icon.sh 80 Icon-App-40x40@2x.png
sh generate_ios_icon.sh 120 Icon-App-40x40@3x.png
sh generate_ios_icon.sh 120 Icon-App-60x60@2x.png
sh generate_ios_icon.sh 180 Icon-App-60x60@3x.png
sh generate_ios_icon.sh 76 Icon-App-76x76@1x.png
sh generate_ios_icon.sh 152 Icon-App-76x76@2x.png
sh generate_ios_icon.sh 167 Icon-App-83.5x83.5@2x.png
