#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

sh scripts/subscripts/increment_version.sh
