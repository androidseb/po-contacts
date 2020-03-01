#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

security unlock-keychain ~/Library/Keychains/login.keychain
cd scripts
fastlane ios $1
