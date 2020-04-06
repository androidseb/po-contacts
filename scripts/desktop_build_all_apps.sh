#!/bin/bash

set -e

bash scripts/linux_build_app_zip.sh
bash scripts/linux_build_app_deb.sh
bash scripts/macos_build_app_zip.sh
bash scripts/windows_build_app_zip.sh

