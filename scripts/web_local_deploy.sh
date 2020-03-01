#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

echo "Building the web app into build/web..."
sh scripts/web_build.sh
echo "Web app built!"
cd po_contacts_flutter/build/web
echo "Starting local HTTP server on port 8000: http://localhost:8000"
python -m SimpleHTTPServer 8000

