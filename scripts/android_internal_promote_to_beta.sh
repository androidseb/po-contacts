#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

cd ./scripts
fastlane internal_promote

