#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

sh scripts/subscripts/deploy_android_app_update.sh beta
