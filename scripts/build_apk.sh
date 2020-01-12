#!/bin/bash
set -e

cd $(git rev-parse --show-toplevel)

cd po_contacts_flutter
flutter build apk
