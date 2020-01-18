#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

cd scripts/subscripts

NWJS_FILE_NAME="nwjs-v0.43.6-linux-x64.tar.gz"
wget https://dl.nwjs.io/v0.43.6/nwjs-v0.43.6-linux-x64.tar.gz --continue
