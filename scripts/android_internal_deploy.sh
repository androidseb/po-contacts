#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

sh scripts/subscripts/deploy_app_update.sh internal

