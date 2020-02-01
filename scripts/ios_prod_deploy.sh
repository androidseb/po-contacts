#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

sh scripts/subscripts/deploy_ios_app_update.sh prod

