#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

cd resources/images

sh generate_ios_phone_model_screenshots.sh iPhone55 1242x2208
sh generate_ios_phone_model_screenshots.sh iPhone65 1242x2688
sh generate_ios_tablet_model_screenshots.sh ipadPro 2732x2048
sh generate_ios_tablet_model_screenshots.sh ipadPro129 2732x2048
